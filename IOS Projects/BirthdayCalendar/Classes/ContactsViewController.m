//
//  ContactsViewController.m
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactsViewController.h"
#import <AddressBook/AddressBook.h>
#import "MBProgressHUD.h"
#import "ContactInfo.h"
#import "DataModelManager.h"
#import "ContactsData.h"
#import "Utils.h"
#import "HolidayAppDelegate.h"

#import "NSDate+Helper.h"

#import "GAI.h"
#import "Constants.h"

#import "config.h"

#define sendLimit 20

@interface ContactsViewController()
@property (nonatomic, retain) NSMutableArray *searchRecords;
- (void)sendLogic;
- (void)sendMessage:(NSMutableArray *)recTen;
- (void)constructMessage;
- (void)updateTable;
- (void)updateData;
- (void)sendLogicHelper:(NSMutableArray *)recUsers;

- (void) searchRecords:(NSString*)searchString;
- (void) performSearch;


@end


@implementation ContactsViewController

@synthesize phoneList;
@synthesize contactsTable;
@synthesize toolBar;
@synthesize continueButton;
@synthesize selectButton;
@synthesize myBoolean,dataModel,
            managedObjectContext,
            markedUsers,markedMemorize;
@synthesize searchBar=_searchBar;
@synthesize searchRecords=_searchRecords;

- (NSString*)getUserPhone:(ABRecordRef)ref
{
    NSString *phoneNumber = nil;
    ABMultiValueRef phones = ABRecordCopyValue(ref, kABPersonPhoneProperty);
    for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
    {
        CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
        phoneNumber = (NSString *)phoneNumberRef;
        CFRelease(phoneNumberRef);
        break;
    }
    CFRelease(phones);
    return phoneNumber;
}

- (NSString *)getPersonName:(NSString *)lastName firstName:(NSString *)firstName
{
    NSString* personName = nil;
    if(firstName != nil)
    {
        personName = [firstName stringByAppendingString:@" "];
        if(lastName != nil)
        {
            personName = [personName stringByAppendingString:lastName];
        }
    }
    else
    {
        if(lastName != nil)
        {
            personName = [@"" stringByAppendingString:lastName];
        }
    }
    return personName;
}

- (BOOL)isABAddressBookCreateWithOptionsAvailable
{
    return &ABAddressBookCreateWithOptions != NULL;
}

-(void) readAddressBook
{
    //NSMutableArray *addressBookUsers;
    ABAddressBookRef addressBook;
    if ([self isABAddressBookCreateWithOptionsAvailable]) {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    } else {
        addressBook = ABAddressBookCreate();
    }
    
    //NSMutableArray *array = nil;
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if  (accessGranted) {
        
        /*
        CFArrayRef allSources = ABAddressBookCopyArrayOfAllSources(addressBook);
        for (CFIndex i = 0; i < CFArrayGetCount(allSources); i++)
        {
            ABRecordRef aSource = CFArrayGetValueAtIndex(allSources,i);
            
            // Fetch all groups included in the current source
            CFArrayRef result = ABAddressBookCopyArrayOfAllGroupsInSource (addressBook, aSource);
            
            NSString *sourceName = (NSString *)ABRecordCopyValue(aSource, kABSourceNameProperty);
            NSString *sourceType = (NSString *)ABRecordCopyValue(aSource, kABSourceTypeProperty);

            NSLog(@"sourceName: %@", sourceName);
            NSLog(@"sourceType: %@", sourceType);
            
            // The app displays a source if and only if it contains groups
            if (CFArrayGetCount(result) > 0)
            {
                NSMutableArray *groups = [[NSMutableArray alloc] initWithArray:(NSArray *)result];
                
                // Fetch the source name
                ////NSString *sourceName = [self nameForSource:aSource];
                //Create a MySource object that contains the source name and all its groups
                ////MySource *source = [[MySource alloc] initWithAllGroups:groups name:sourceName];
                
                // Save the source object into the array
                //[list addObject:source];
                //[source release];
                [groups release];
            }
            else
            {
                
                CFArrayRef result2= ABAddressBookCopyArrayOfAllPeopleInSource(addressBook, aSource);
                NSLog(@"count %d", CFArrayGetCount(result2));
                CFRelease(result2);
            }
            
            CFRelease(result);
        }
        */
        
#define USE_ALL_CONTACTS
//#undef  USE_ALL_CONTACTS
#ifdef  USE_ALL_CONTACTS
        CFArrayRef all = ABAddressBookCopyArrayOfAllPeople(addressBook);
        //ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(addressBook);
        //CFArrayRef all = ABAddressBookCopyArrayOfAllPeopleInSource(addressBook, defaultSource);
        CFIndex personCount = ABAddressBookGetPersonCount(addressBook);
#else
        ABRecordRef aSource;
        CFArrayRef allSources = ABAddressBookCopyArrayOfAllSources(addressBook);
        for (CFIndex i = 0; i < CFArrayGetCount(allSources); i++)
        {
            aSource = CFArrayGetValueAtIndex(allSources,i);
            NSNumber *sourceType = (NSNumber *)ABRecordCopyValue(aSource, kABSourceTypeProperty);
            if ([sourceType intValue] == 0) {
                break;
            }
        }
        CFArrayRef all = ABAddressBookCopyArrayOfAllPeopleInSource(addressBook, aSource);
        CFIndex personCount = CFArrayGetCount(all);
#endif
        
        //CFArrayRef all = ABAddressBookCopyArrayOfAllPeople(addressBook);
        //ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(addressBook);
        //CFArrayRef all = ABAddressBookCopyArrayOfAllPeopleInSource(addressBook, defaultSource);
        //CFIndex personCount = ABAddressBookGetPersonCount(addressBook);
        
        phoneList = [[NSMutableArray alloc] initWithCapacity:personCount];
        
        for(int i = 0 ; i < personCount ; i++)
        {
            ABRecordRef ref = CFArrayGetValueAtIndex(all, i);
            ABPropertyID propID = ABRecordGetRecordID(ref);
            //NSLog(@"%d", propID);
            NSString *firstName = (NSString *)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
            NSString *lastName = (NSString *)ABRecordCopyValue(ref, kABPersonLastNameProperty);
            NSDate *birthday =(NSDate*)ABRecordCopyValue(ref,kABPersonBirthdayProperty);
            NSData *personPhoto=(NSData*)ABPersonCopyImageDataWithFormat(ref,kABPersonImageFormatThumbnail);
            
            ContactInfo *info= [[ContactInfo alloc]init];
            //NSString *stringFromDate=nil;
            if(birthday != nil)
            {
                info.birthDay = birthday;
            //    stringFromDate=[NSDate stringFromDate:birthday withFormat:@"yyyy-MM-dd"];
            }
            [birthday release];
            
            NSString *personName = [self getPersonName:lastName firstName:firstName];
            NSString *phoneNumber =  [self getUserPhone:ref];
            
            NSNumber *numberID=[NSNumber numberWithInt:propID];
            //NSNumber *numberChecked=[NSNumber numberWithInt:1];
            
            /*
             if(personName != nil && phoneNumber != nil)
             {
             [dataModel saveContactsToModel:numberID:personName:phoneNumber:numberChecked];
             }
             
             if(stringFromDate != nil && personPhoto != nil)
             {
             NSString* numberIDString=[numberID stringValue];
             [dataModel saveUserToModel:numberIDString:personName:stringFromDate:@"":personPhoto];
             }
             */
            
            if(personName != nil && phoneNumber != nil)
            {
                //[dataModel saveContactsToModel:numberID:personName:phoneNumber:numberChecked];
                
                //NSString* numberIDString=[numberID stringValue];
                //[dataModel saveUserToModel:numberIDString:personName:stringFromDate:@"":personPhoto];
            }
            
            //if(stringFromDate != nil) {
            //    NSString* numberIDString=[numberID stringValue];
            //    [dataModel saveUserToModel:numberIDString:personName:stringFromDate:@"":personPhoto];
            //}
            
            info.name = personName;
            //info.phone = phoneNumber;
            info.marked = TRUE;
            
            info.index = [numberID integerValue];
            info.personPhoto = personPhoto;
            info.phone = phoneNumber;
            
            //info.message = con.sendMessage;
            
            if(birthday != nil) {
                [self.phoneList addObject:info];
            }
            [info release];
            
            [personPhoto release];
            [lastName release];
            [firstName release];
        }
        CFRelease(all);
        CFRelease(addressBook);
        //[dataModel savingContext];
    } else {
        [Utils messageDisplay:@"Birthday Calendar" :@"Access to the Address Book Not Granted" :-1];
        if (addressBook) {
            CFRelease(addressBook);
        }
    }
}

-(id) initWithContacts:(NSMutableArray*)contacts
{
    if ((self = [super initWithNibName:@"ContactsViewController" bundle:[NSBundle mainBundle]]))
    {        
        //[self updateTable];
        [self readAddressBook];
    }
    return self;
}

-(void) dealloc
{
    [phoneList release];
    [contactsTable release];
    [toolBar release];
    [continueButton release];
    [selectButton release];
    [markedUsers release];
    [markedMemorize release];
    [_searchBar release];
    [_searchRecords release];
    [dataModel release];
    [managedObjectContext release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        searchPerformed = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void) searchRecords:(NSString *)searchString
{
    NSMutableArray *foundPersons = [[NSMutableArray alloc] init];
    for (ContactInfo *conData in self.phoneList)
    {
        if ([conData.name rangeOfString:searchString options:NSCaseInsensitiveSearch].length > 0)
        {
            [foundPersons addObject:conData];
            // NSLog(@"The author name is:%@",currAuthor.lastName);
        }
    }
    self.searchRecords = foundPersons;
    [foundPersons release];
}
- (void) performSearch
{
    NSString *searchString = self.searchBar.text;
    
    [self searchRecords:searchString];
    searchPerformed = YES;
    [self.contactsTable reloadData];
}

#pragma mark - View lifecycle

- (void)updateTable{
   
    //phoneList = [[NSMutableArray alloc]init];
    //NSMutableArray *ar= [dataModel fetchContactsRecords];
    
    [phoneList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ContactInfo *con1 = (ContactInfo *)obj1;
        ContactInfo *con2 = (ContactInfo *)obj2;
        return [con1.name compare:con2.name options:NSCaseInsensitiveSearch];
    }];
    [self.contactsTable reloadData];
    
    return;
    
    for(ContactsData *con in phoneList)
    {
        ContactInfo *info= [[ContactInfo alloc]init];
        info.name = con.username;
        info.phone = con.userphone;
        
        if([con.sendMessage length] > 0)
        {
            info.marked = FALSE;
        }else{
            info.marked=TRUE;
        }
        info.index = [con.userID integerValue];
        info.message = con.sendMessage;
        
        [self.phoneList addObject:info];
        [info release];
    }
    [phoneList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ContactInfo *con1 = (ContactInfo *)obj1;
        ContactInfo *con2 = (ContactInfo *)obj2;
        return [con1.name compare:con2.name options:NSCaseInsensitiveSearch];
    }];
    [self.contactsTable reloadData];
}


-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self updateTable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.trackedViewName = @"ContactsViewController";
    
    //NSLog(@"%f,%f", self.tabBarController.view.frame.origin.y, self.tabBarController.view.frame.size.height);
    //NSLog(@"%f,%f", self.tabBarController.tabBar.frame.origin.y, self.tabBarController.tabBar.frame.size.height);
    //NSLog(@"%f,%f", self.view.frame.origin.y, self.view.frame.size.height);
    
#ifdef __DISPLAY_BANNER__
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    //bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            self.view.frame.size.height -
                                            GAD_SIZE_320x50.height,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];
#endif /* __DISPLAY_BANNER__ */
    
    self.managedObjectContext=[DataModelManager getObjectModel];
    dataModel = [[DataModelManager alloc]init];
    
    [selectButton setTitle:@"Deselect all"];
    [continueButton setTitle:@"Continue"];
    continueButton.tintColor=[UIColor orangeColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDataSource protocol conformance

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ContactInfo *object;
    if(searchPerformed){
        object = [self.searchRecords objectAtIndex:indexPath.row];
    }else{
        object = [phoneList objectAtIndex:indexPath.row];
    }
    if (object.marked) 
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } 
    else 
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.font=[UIFont boldSystemFontOfSize:17.0];
    cell.textLabel.textColor=[UIColor colorWithRed:86.0/255 green:66.0/255 blue:16.0/255 alpha:1.0];
    cell.textLabel.text = object.name;
    cell.detailTextLabel.text=object.message;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(searchPerformed){
         return [self.searchRecords count];
    }else{
         return [phoneList count];
    }

    return [phoneList count];
}


-(IBAction)buttonPressed:(id)sender
{
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    NSString* str = button.title;
    myBoolean = FALSE;
    if([str isEqualToString:@"Deselect all"])
    {
        for(ContactInfo *info in phoneList)
        {
            info.marked = FALSE;
            
            [contactsTable reloadData];
        }
        [continueButton setTitle:@"Continue"];
        [selectButton setTitle:@"Select all"];
    }
    
    if([str isEqualToString:@"Select all"])
    {
        for(ContactInfo *info in self.phoneList)
        {
            
             info.marked = TRUE;
             [contactsTable reloadData];
             //countOfSended++;
        }
        [selectButton setTitle:@"Deselect all"];
    }
}

- (void)constructMessage
{
    NSMutableString *mes = [NSMutableString stringWithString: @"Send"];
    NSString *index=[NSString stringWithFormat:@"%d",countOfSended];
    [mes appendString:index];
    [mes appendString:@" Requests"];
    [continueButton setTitle:mes];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    ContactInfo *object;
    if(searchPerformed){
        object = [self.searchRecords objectAtIndex:indexPath.row];
    }else{
        object = [self.phoneList objectAtIndex:indexPath.row];
    }
    object.marked = !object.marked;
    
    [self.contactsTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateData
{
    for(ContactInfo *info in markedUsers)
    {
        NSNumber *myInt = [NSNumber numberWithInteger:info.index];
        [dataModel updateCurrentContactObject:myInt:info.name :info.phone:0];
    }
    [self updateTable];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
    {
        [selectButton setTitle:@"Deselect all"];
    }
    else if (result == MessageComposeResultSent)
    {
        [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"SMS"
                                                         withAction:@"sent"
                                                          withLabel:nil
                                                          withValue:nil];
        
        NSInteger markedCount = [markedMemorize count];
        if(markedCount != 0)
        {   
                NSString * message = @"Birthday requests are sent in groups of 20. You may see more than one text message screen.";
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Birthday Calendar" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.tag = 1;    
                [alert show];
                [alert release];
        }
        [self updateData];
        [selectButton setTitle:@"Deselect all"];
    }
    else 
        NSLog(@"Message failed");  
}

- (void)sendMessage:(NSMutableArray *)recTen
{
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
   
    
    if([MFMessageComposeViewController canSendText])
    {
        NSMutableString *mes = [NSMutableString stringWithString: 
                                @"Hey, I want to add your birthday to my Birthday Calendar."];
        NSString* link =@"http://itunes.apple.com/us/app/birthday-calendar-by-davia/id540611558?mt=8";
        [mes appendString:@"\n"];
        [mes appendString:link];
        controller.body = mes;
        controller.recipients = recTen;            
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}

- (void)sendLogicHelper:(NSMutableArray *)recUsers
{
    NSMutableArray *recTen=[[NSMutableArray alloc]init];
    int recCount=[recUsers count];
    if([recUsers count] >= sendLimit)
    {
        for(int i = 0,j = sendLimit - 1; i < sendLimit || j >= 0; i++, j--)
        {
            [recTen addObject:[recUsers objectAtIndex:i]];
            [markedMemorize removeObjectAtIndex:j];
        }
        [self sendMessage:recTen];
    }
    else
    {
        if(recCount != 0)
        {
            for(int i = 0; i < recCount; i++)
            {
                [recTen addObject:[recUsers objectAtIndex:i]];
                [markedMemorize removeLastObject];
            }
            [self sendMessage:recTen];
        }
    }
    [recTen release];
}

- (void)sendLogic
{
    NSMutableArray *recUsers = [[NSMutableArray alloc]init];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for(ContactInfo *info in markedMemorize)
        {
            if(info.marked == 1)
            {
                if (info.phone != nil) {
                    [recUsers addObject:info.phone];
                }
            }
        }  
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendLogicHelper:recUsers];
            [recUsers release];  
        });
    });       
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    if(alertView.tag == 1)
    {
        if(buttonIndex == 0)
        {
            [self sendLogic];
        }
    }
}

-(IBAction)buttonContinuePressed:(id)sender
{
   
    markedUsers = [[NSMutableArray alloc]init];
    markedMemorize=[[NSMutableArray alloc]init];
    
    if(searchPerformed)
    {
        for(ContactInfo *info in self.searchRecords)
        {
            if(info.marked == 1){
                [markedUsers addObject:info];
                [markedMemorize addObject:info];
            }
        }    
    }
    else
    {
        for(ContactInfo *info in self.phoneList)
        {
            if(info.marked == 1){
                [markedUsers addObject:info];
                [markedMemorize addObject:info];
            }
        }    
    }

    for (ContactInfo *contactInfo in markedUsers) {
        NSNumber *numberChecked=[NSNumber numberWithInt:1];
        
        if(contactInfo.name != nil/* && contactInfo.phone != nil*/)
        {
            [dataModel saveContactsToModel:[NSNumber numberWithInt:contactInfo.index]:contactInfo.name:contactInfo.phone:numberChecked];
            
            NSString *stringFromDate=nil;
            if(contactInfo.birthDay != nil)
            {
                stringFromDate=[NSDate stringFromDate:contactInfo.birthDay withFormat:@"yyyy-MM-dd"];
            } else {
                contactInfo.birthDay = [NSDate dateFromString:@"2000-01-01" withFormat:@"yyyy-MM-dd"];
                stringFromDate=[NSDate stringFromDate:contactInfo.birthDay withFormat:@"yyyy-MM-dd"];
            }
            //[contactInfo.birthDay release];
            
            //if(stringFromDate != nil && contactInfo.personPhoto != nil)
            //{
                NSString* numberIDString=[[NSNumber numberWithInt:contactInfo.index] stringValue];
            
                if (contactInfo.personPhoto != nil) {
                    //[dataModel saveUserToModel:numberIDString:personName:stringFromDate:nil:personPhoto];
                    [dataModel deleteCurrentObjectWithNameAndID:contactInfo.name :numberIDString];
                    [dataModel saveUserToModel:numberIDString:contactInfo.name:stringFromDate:nil:contactInfo.personPhoto];
                } else {
                    //[dataModel saveUserToModel:numberIDString:personName:stringFromDate:@"":personPhoto];
                    UIImage *image=[UIImage imageNamed:@"person.png"];
                    contactInfo.personPhoto = UIImagePNGRepresentation(image);
                    
                    [dataModel deleteCurrentObjectWithNameAndID:contactInfo.name :numberIDString];
                    [dataModel saveUserToModel:numberIDString:contactInfo.name:stringFromDate:@"":contactInfo.personPhoto];
                }
                
            //}
        }
        
        [dataModel savingContext];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOnStartup" object:@""];
    HolidayAppDelegate *appDelegate = (HolidayAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.tabBarController.selectedIndex=1;

    //[self dismissModalViewControllerAnimated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    return;
    
    if([markedMemorize count] >= sendLimit)
    {
        //show message.
        NSString * message = @"Birthday requests are sent in groups of 20. You may see more than one text message screen.";
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Birthday Calendar" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = 1;    
            [alert show];
            [alert release];
    }
    else
    {
        [self sendLogic];
    }
}

#pragma mark -
#pragma mark UISearchBarDelegate methods

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    [self performSearch];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
}

@end