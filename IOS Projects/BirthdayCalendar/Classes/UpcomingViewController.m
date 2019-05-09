//
//  UpcomingViewController.m
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UpcomingViewController.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "DataModelManager.h"
#import "Birthday.h"
#import "CalendarTableViewCell.h"
#import "Utils.h"
#import "Constants.h"
#import <Facebook.h>
#import "Reachability.h"
#import "NSDate+Helper.h"
#import "FacebookManager.h"
//#import "PostToWallSMSViewController.h"

#import "config.h"

#import "GAI.h"

// Define how many days will be displayed into the Upcomming birthdays.
#define numberOfDaysAhead 30

@interface UpcomingViewController()
-(void)filterUpcomingBirthdays;

@end

@implementation UpcomingViewController

@synthesize upcomingTableView=_upcomingTableView;
@synthesize friendsList=_friendsList;
@synthesize managedObjectContext;
@synthesize dataModel;
@synthesize birthday;

-(void) dealloc
{

    [_upcomingTableView release];
    [_friendsList release];
    [managedObjectContext release];
    [dataModel release];
    [birthday release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CalendarReset" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FacebookDownloadComplete" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserEdited" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserDeleted" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshOnStartup" object:nil];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {    
        self.tabBarItem.tag=2;
        [self.tabBarItem setTitle:@"Upcoming"];
        //[self.tabBarItem setImage:[UIImage imageNamed:@"UpcomingD"]];
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"UpcomingD-selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"UpcomingD.png"]];
        
        NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
        [notifyCenter addObserver:self selector:@selector(resetCalendar:)
                             name:@"CalendarReset" object:nil];
        [notifyCenter addObserver:self selector:@selector(trackFBDownloadAndEdit:)
                             name:@"FacebookDownloadComplete" object:nil];
         [notifyCenter addObserver:self selector:@selector(trackFBDownloadAndEdit:)
                             name:@"UserEdited" object:nil];
        [notifyCenter addObserver:self selector:@selector(trackFBDownloadAndEdit:)
                             name:@"UserDeleted" object:nil];
        [notifyCenter addObserver:self selector:@selector(trackFBDownloadAndEdit:)
                             name:@"RefreshOnStartup" object:nil];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    //NSDate *start = [NSDate date];
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    UIImage *backgroundImage = [UIImage imageNamed:@"BirthdaysC"];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:11];
    }
    
#ifdef __DISPLAY_BANNER__
    //bannerView_.frame = CGRectOffset(bannerView_.frame, 0, -bannerView_.frame.size.height);
    bannerView_.frame = CGRectMake(0.0,
                                   self.view.frame.size.height -
                                   GAD_SIZE_320x50.height,
                                   GAD_SIZE_320x50.width,
                                   GAD_SIZE_320x50.height);
#endif /* __DISPLAY_BANNER__ */
    
    //NSLog(@"%f,%f", self.tabBarController.view.frame.origin.y, self.tabBarController.view.frame.size.height);
    //NSLog(@"%f,%f", self.tabBarController.tabBar.frame.origin.y, self.tabBarController.tabBar.frame.size.height);
    //NSLog(@"%f,%f", self.view.frame.origin.y, self.view.frame.size.height);

    //NSLog(@"LOAD: %f", -[start timeIntervalSinceNow]);
    
    //self.tabBarController.tabBar.hidden = YES;
   }

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[self.navigationController navigationBar] resetBackground:11];
    self.tabBarItem.badgeValue = 0;

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)filterUpcomingBirthdays
{
    if(self.friendsList == nil){
        self.friendsList=[NSArray array];
    }
    if(self.managedObjectContext == nil){
        self.managedObjectContext=[DataModelManager getObjectModel];
    }
    if(dataModel == nil){
     dataModel = [[DataModelManager alloc]init];
    }
    
    NSMutableArray *fetchedRecords=[dataModel fetchRecords];
    NSDate *today = [NSDate date];
    NSMutableArray *friendArray = [[NSMutableArray alloc]init];
    //NSLog(@"Users: %d", [fetchedRecords count]);
    NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]] autorelease];
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:locale];
	[inputFormatter setDateFormat:@"yyyy-MM-dd"];
    [inputFormatter setTimeZone:[NSTimeZone systemTimeZone]];

   if([fetchedRecords count] > 0)
   {
      NSString *currentYear = [Utils returnCurrentYear];
      for(int i = 0; i < [fetchedRecords count]; i++)
      {
          UserData *um=[fetchedRecords objectAtIndex:i];
          NSString *newDate=[Utils changeYearToPassed:um.birthday:currentYear];
          NSDate *userDate = [inputFormatter dateFromString:newDate];
          int days= [Utils getDaysBetween2Dates:userDate:today];
        
          if(days >= 0 && days < numberOfDaysAhead)
          {
              [friendArray addObject:[Birthday birthdayNamed:um.name:
                                                userDate:um.birthday:um.photo:um.userID:days:um.thumbimage]];
          }
      }
      if([friendArray count] != 0){
          [Utils sortBirthdays:friendArray];
      }
   }
    [inputFormatter release];
    self.friendsList = friendArray;
    [friendArray release];
    [self.upcomingTableView reloadData];

}

-(void)resetCalendar:(NSNotification*) notification{
    id nname = [notification name];
    if([nname isEqual:@"CalendarReset"])
    {
        NSMutableArray *friendArray = [[[NSMutableArray alloc]init]autorelease];
        self.friendsList = friendArray;
        [self.upcomingTableView reloadData];
/Users/petkoyanakiev/Documents/xentioProjects/BirthdayCalendar/Classes/UpcomingViewController.m    }
    
}

- (void) trackFBDownloadAndEdit: (NSNotification *) notification
{
    id nname = [notification name];
    NSDictionary *customData = (NSDictionary *)[notification object];
    //NSLog(@"%@", customData);
    
    if([nname isEqual:@"FacebookDownloadComplete"] || [nname isEqual:@"RefreshOnStartup"])
    {
        //NSLog(@"Receive notifications.");
        [self filterUpcomingBirthdays];
    } else if ([nname isEqual:@"UserEdited"] || [nname isEqual:@"UserDeleted"] ) {
        // User added or edited
        NSData *imageData = nil;
        for (int i = 0; i<[self.friendsList count]; i++) {
            Birthday *bd = [self.friendsList objectAtIndex:i];
            //NSLog(@"bd: %@", bd.userID);
            //NSLog(@"current: %@", [customData objectForKey:@"userID"]);
            if ([bd.userID isEqual:[customData objectForKey:@"userID"]]) {
                imageData = [[bd.thumbimage retain] autorelease];
                [self.friendsList removeObjectAtIndex:i];
                //NSLog(@"Count After: %d", [friendsList count]);
                break;
            }
        }
        if ([nname isEqual:@"UserEdited"]) {
            // Add new/Update existing user in list if it has birthday in next 30 days.
            NSDate *today = [NSDate date];
            NSString *newDate=[Utils changeYearToCurrent:[customData objectForKey:@"dateForInsertion"]];
            NSDate *userDate = [NSDate dateFromString:newDate withFormat:@"yyyy-MM-dd"];
            int days= [Utils getDaysBetween2Dates:userDate:today];
            
            if(days >= 0 && days < numberOfDaysAhead)
            {
                //[friendArray addObject:[Birthday birthdayNamed:um.name:userDate:um.birthday:um.photo:um.userID:days:um.thumbimage]];
                NSData *imageDataToSet = [customData objectForKey:@"imageData"];
                if (imageDataToSet == nil) {
                    imageDataToSet = imageData;
                }
                [self.friendsList addObject:[Birthday birthdayNamed:[customData objectForKey:@"nname"]:userDate:[customData objectForKey:@"dateForInsertion"]:[customData objectForKey:@"photo"]:[customData objectForKey:@"userID"]:days:imageDataToSet]];
            }
            [Utils sortBirthdays:self.friendsList];
        }
        [self.upcomingTableView reloadData];
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.trackedViewName = @"UpcomingViewController";
    
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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    //self.managedObjectContext=[DataModelManager getObjectModel];
    //dataModel = [[DataModelManager alloc]init];
    //self.friendsList=[NSArray array];
    //[self filterUpcomingBirthdays];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
   
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark UITableViewDataSource protocol conformance

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef __DISPLAY_BANNER__
    bannerView_.frame = CGRectMake(0.0,
                                   self.view.frame.size.height -
                                   GAD_SIZE_320x50.height,
                                   GAD_SIZE_320x50.width,
                                   GAD_SIZE_320x50.height);
#endif /* __DISPLAY_BANNER__ */
    
    Birthday *birth = [self.friendsList objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"CalendarTableViewCell";
	
    CalendarTableViewCell *calCell = (CalendarTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (calCell == nil) {
        
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CalendarTableViewCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				calCell =  (CalendarTableViewCell *) currentObject;
				break;
			}
		}
	}
    [calCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    calCell.sendButton.tag = indexPath.row;
    calCell.userNameLabel.textColor = BROWN_COLOR;
    calCell.userBirthdayDateLabel.textColor=BROWN_COLOR;
   NSString* uname=[birth.name stringByReplacingOccurrencesOfString:@"?" withString:@""];
    calCell.userNameLabel.text = uname;

    NSString* result = [Utils formatDateForTableCell:birth.date];
    calCell.userBirthdayDateLabel.text=result;
    
    if(birth.thumbimage != nil) {
        
        UIImage *resizedImage=[UIImage imageWithData:birth.thumbimage];
        [Utils resizeImage:&resizedImage];
        [calCell.imageView stopAnimating];
        calCell.imageView.image = resizedImage;
    } else {
        //NSLog(@"Dragging %d", tableView.dragging);
        //NSLog(@"Decelerating %d", tableView.decelerating);
        
        if (tableView.dragging == NO && tableView.decelerating == NO)
        {
            //[self startIconDownload:appRecord forIndexPath:indexPath];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
            dispatch_async(queue, ^{
                NSURL *imageURL = [NSURL URLWithString:birth.photo];
                NSData* imageD = [NSData dataWithContentsOfURL:imageURL];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    birth.thumbimage = imageD;
                    [dataModel updateCurrentObject:birth.userID:birth.name:birth.dateAsString:birth.photo:imageD];
                    UIImage *resizedImage=[[[UIImage alloc] initWithData:imageD] autorelease];
                    [Utils resizeImage:&resizedImage];
                    [calCell.imageView stopAnimating];
                    calCell.imageView.image = resizedImage;
                    calCell.imageView.contentMode = UIViewContentModeScaleToFill;
                    [calCell setNeedsLayout];
                });
            });
        }
        // if a download is deferred or in progress, return a placeholder image
        //calCell.imageView.image = [UIImage imageNamed:@"Spinner.png"];
        //calCell.imageView.image = [UIImage imageNamed:@"Spinner.png"];
        calCell.imageView.animationImages = [Utils spinnerImages];
        calCell.imageView.animationDuration = 1.1;
        //calCell.imageView.contentMode = UIViewContentModeCenter;
        [calCell.imageView startAnimating];
    }
    
    return calCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#ifdef __DISPLAY_BANNER__
    bannerView_.frame = CGRectMake(0.0,
                                   self.view.frame.size.height -
                                   GAD_SIZE_320x50.height,
                                   GAD_SIZE_320x50.width,
                                   GAD_SIZE_320x50.height);
#endif /* __DISPLAY_BANNER__ */
    
    return [self.friendsList count];
}

//- (void) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"Select");
//}

//- (void) tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"Deselect");
//}

- (IBAction)sendClicked:(UIButton*)sender {
    //UITableViewCell *buttonCell = (UITableViewCell *)[sender superview];
    //UITableView* table = (UITableView *)[buttonCell superview];
    //NSIndexPath* pathOfTheCell = [table indexPathForCell:buttonCell];
    //NSInteger rowOfTheCell = [pathOfTheCell row];
    //NSLog(@"rowofthecell %d", rowOfTheCell);
    
    NSLog(@"rowofthecell %d", sender.tag);

    birthday=nil;
    birthday = [self.friendsList objectAtIndex:sender.tag/*rowOfTheCell*/];
    NSString* uname=[birthday.name stringByReplacingOccurrencesOfString:@"?" withString:@""];
    NSMutableString *mes = [Utils constructFriendWishMessage:uname];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:mes message:nil delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"Post to Wall",@"Send SMS" ,nil];
    [alert show];
    alert.tag=1;
    [alert release];
    
    /*
    PostToWallSMSViewController* postToWallSMSViewController = [[[PostToWallSMSViewController alloc] initWithNibName:@"PostToWallSMSViewController" bundle:nil] autorelease];
    
    //CGRect frame = postToWallSMSViewController.view.frame;
    //frame.origin.y = self.view.frame.size.height - frame.size.height + self.view.frame.origin.y;
    
    [postToWallSMSViewController setHandler:^(PostToWallSMSViewController *selectPhotoAlertSheet, int buttonIndex) {
        NSLog(@"tag: %d", buttonIndex);
        
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                
                break;
            default:
                break;
        }
    }];
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:postToWallSMSViewController animated:YES completion:^{
        //[postToWallSMSViewController.view setFrame:frame];
    }];
    */
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    birthday=nil;
    birthday = [self.friendsList objectAtIndex:indexPath.row];
    NSString* uname=[birthday.name stringByReplacingOccurrencesOfString:@"?" withString:@""];
    NSMutableString *mes = [Utils constructFriendWishMessage:uname];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:mes message:nil delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"Post to Wall",@"Send SMS" ,nil];
    [alert show];
    alert.tag=1;
    [alert release];
    
    /*
    PostToWallSMSViewController* postToWallSMSViewController = [[[PostToWallSMSViewController alloc] initWithNibName:@"PostToWallSMSViewController" bundle:nil] autorelease];
    
    //CGRect frame = postToWallSMSViewController.view.frame;
    //frame.origin.y = self.view.frame.size.height - frame.size.height + self.view.frame.origin.y;
    
    [postToWallSMSViewController setHandler:^(PostToWallSMSViewController *selectPhotoAlertSheet, int buttonIndex) {
        NSLog(@"tag: %d", buttonIndex);
        
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                
                break;
            default:
                break;
        }
    }];
    
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    //self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    //self.upcomingTableView .modalPresentationStyle = UIModalPresentationCurrentContext;
    [self.navigationController presentViewController:postToWallSMSViewController animated:YES completion:^{
        //[postToWallSMSViewController.view setFrame:frame];
    }];
    */
    
}

- (void)sendSMS:(NSString*)name
{
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    
    if([MFMessageComposeViewController canSendText])
    {
        NSArray *sepString =[name componentsSeparatedByString:@"?"];
        NSMutableString* ms = [[NSMutableString alloc] init];  
        [ms appendString:@"Happy Birthday "];
        [ms appendString:[sepString objectAtIndex:0]];
        [ms appendString:@" !"];
        controller.body = ms;
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
        [ms release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    if(alertView.tag == 1)
    { 
        if(buttonIndex == 0)
        {
           [alertView dismissWithClickedButtonIndex:0 animated:YES];
           
        }
        else if(buttonIndex == 1)
        {
            Reachability* wifiReach = [Reachability reachabilityWithHostName: @"www.facebook.com"];
            NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
            
            //if(netStatus == ReachableViaWWAN)
            //{
            //    netStatus = NotReachable;
            //}
            if (netStatus != NotReachable)
            {
                [self performSelector:@selector(publishStream) withObject:nil afterDelay:0.3f];
            }
            else
            {
                NSString* mes=@"There is no Internet connection.";
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:mes delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                return;
            }
            
        }else{
            
            [self sendSMS:birthday.name];
        }
    }
}

- (void)publishStream
{
    if (birthday.userID.longLongValue <= 10000000) {
        [Utils messageDisplay:@"Not a Facebook User" :nil:(int)nil];
        return;
    }
    NSString* uname=[birthday.name stringByReplacingOccurrencesOfString:@"?" withString:@""];
    NSArray *sepString =[uname componentsSeparatedByString:@" "];
    NSMutableString* ms = [[NSMutableString alloc] init];  
    [ms appendString:@"Happy Birthday "];
    [ms appendString:[sepString objectAtIndex:0]];
    
    NSMutableArray *todayList = [Utils filterSameDayCelebritiesBirthdays:birthday.date];
    
    if (todayList.count > 0) {        
        [ms appendString:@"! You have the same birthday as "];
        [ms appendString:[todayList objectAtIndex:0]];
        [ms appendString:@"!"];
    } else {
        [ms appendString:@"!"];
    }
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    FB_KEY, @"app_id",
            @"http://www.daviacalendar.com/assets/icon2x.png",@"picture",
            //@"https://apps.facebook.com/davia_calendar/",@"name",
            //@"https://apps.facebook.com/davia_calendar/", @"link",
            @"  ", @"description",
            birthday.userID, @"to",
            ms, @"caption",nil];

    
    [[[GAI sharedInstance] defaultTracker] trackEventWithCategory:@"Facebook"
                                                       withAction:@"feed"
                                                        withLabel:nil
                                                        withValue:nil];
    NSLog(@"FBSession token: %@", FBSession.activeSession.accessToken);
    Facebook* facebook = [FacebookManager sharedManager].facebook;
    NSLog(@"Facebook token: %@", facebook.accessToken);
    [[FacebookManager sharedManager].facebook dialog:@"feed"
                    andParams:params
                  andDelegate:self];
    [ms release];
}

/*** Called when the dialog is cancelled and is about to be dismissed. */
- (void)dialogDidNotComplete:(FBDialog *)dialog {
    NSLog(@"Post Cancelled");
}

/*** Called when the dialog get canceled by the user.*/
- (void)dialogDidNotCompleteWithUrl:(NSURL *)url {
    NSLog(@"Post Cancelled w/ URL");
    NSLog(@"%@",[url absoluteString]);
}

- (void)  dialogCompleteWithUrl:(NSURL *)url{
    
    NSString *myString = [url absoluteString];

    if ([myString rangeOfString:@"post_id"].location == NSNotFound) {
        // TODO:: There is a bug in Facebook API. It calls dialog with success instead of cancel if cancel button is clicked. When close button is clicked it works correct and calls dialogDidNotCompleteWithURL and dialogDidNotComplete which is correct.
        /*
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message can not be posted." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];   
        [alert release];
        */
    } else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message posted successfully." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        [alert release];
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
    {
        [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"SMS"
                                                         withAction:@"sent"
                                                          withLabel:nil
                                                          withValue:nil];
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message sent successfully." message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else 
        NSLog(@"Message failed");  
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.friendsList count] > 0)
    {
        NSArray *visiblePaths = [_upcomingTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            //NSLog(@"%@", indexPath);
            
            Birthday* birth = [self.friendsList objectAtIndex:indexPath.row];

            UITableViewCell *cell = [_upcomingTableView cellForRowAtIndexPath:indexPath];
            
            if (!birth.thumbimage) {
                //NSLog(@"%@", birth.name);
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
                dispatch_async(queue, ^{
                    NSURL *imageURL = [NSURL URLWithString:birth.photo];
                    NSData* imageD = [NSData dataWithContentsOfURL:imageURL];
             
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        birth.thumbimage = imageD;
                        [dataModel updateCurrentObject:birth.userID:birth.name:birth.dateAsString:birth.photo:imageD];
                       
                        //fix the problem with image when the device is offline.
                        if(imageD == nil){
                            //cell.imageView.image = [UIImage imageNamed:@"Spinner.png"];
                            cell.imageView.animationImages = [Utils spinnerImages];
                            cell.imageView.animationDuration = 1.1;
                            //cell.imageView.contentMode = UIViewContentModeCenter;
                            [cell.imageView startAnimating];
                        }else{
                            UIImage *resizedImage=[[[UIImage alloc] initWithData:imageD] autorelease];
                            [Utils resizeImage:&resizedImage];
                            [cell.imageView stopAnimating];
                            cell.imageView.image = resizedImage;
                            cell.imageView.contentMode = UIViewContentModeScaleToFill;
                        }
                        
                        [cell setNeedsLayout];
                    });
                });
            } else {
                UIImage *resizedImage= [[[UIImage alloc] initWithData:birth.thumbimage] autorelease];
                [Utils resizeImage:&resizedImage];
                [cell.imageView stopAnimating];
                cell.imageView.image = resizedImage;

            }
        }
    }
}

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        //NSLog(@"scrollViewDidEndDragging");
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating");
    [self loadImagesForOnscreenRows];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
