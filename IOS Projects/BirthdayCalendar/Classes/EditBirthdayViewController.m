//
//  EditBirthdayViewController.m
//  BirthdayCalendar
//  Created by Petko Yanakiev on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditBirthdayViewController.h"
#import "Utils.h"
#import "DataModelManager.h"
#import "ManageBirthdayViewController.h"
#import "HolidayAppDelegate.h"
#import "KalViewController.h"
#import "Birthday.h"
#import "MainViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NSDate+Helper.h"
#import "Constants.h"

#define EDIT 0
#define ADD 1

@implementation EditBirthdayViewController

@synthesize actionSheet;
@synthesize photoButton;
@synthesize userImageData;
@synthesize firstNameTextField;
@synthesize lastNameTextField;
@synthesize birthdayTextField;
@synthesize birthDate;
@synthesize userName;
@synthesize userDate;
@synthesize userID;
@synthesize managedObjectContext;
@synthesize dataModel;
@synthesize addBirthday;
@synthesize pickedImage;
@synthesize photo;
@synthesize editRecords;


-(void) dealloc
{
    [firstNameTextField release];
    [lastNameTextField release];
    [birthdayTextField release];
    [birthDate release];
    [actionSheet release];
    [userName release];
    [userDate release];
    [userID release];
    [photo release];
    [photoButton release];
    [pickedImage release];
    [userImageData release];
    [editRecords release];
    
    [super dealloc];
}

-(id)initWithAddController :(BOOL)add :(DataModelManager*)p_dataModel :(NSManagedObjectContext *)p_managedObjectContext
{
    
    if ((self = [super initWithNibName:@"EditBirthdayViewController" bundle:[NSBundle mainBundle]]))
    {
        self.addBirthday=add;
        self.dataModel=p_dataModel;
        self.managedObjectContext=p_managedObjectContext;

    }
    return self;
}

-(id) initWithUserData :(NSString*)auserID :(NSString*)auserName :(NSString*)auserDate :(NSData*)userImage :(NSString *)uPhoto :(DataModelManager*)p_dataModel :(NSManagedObjectContext *)p_managedObjectContext{
    
    if ((self = [super initWithNibName:@"EditBirthdayViewController" bundle:[NSBundle mainBundle]]))
    {
        self.userImageData=userImage;
        self.userName=auserName;
        self.photo=uPhoto;
        NSString *newDate=[Utils changeYearToCurrent:auserDate];
        self.userDate=newDate;
        self.userID=auserID;
        self.addBirthday=FALSE;
        dataModel=p_dataModel;
        managedObjectContext=p_managedObjectContext;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.trackedViewName = @"EditBirthdayViewController";
    
    //NSLog(@"%f,%f", self.tabBarController.view.frame.origin.y, self.tabBarController.view.frame.size.height);
    //NSLog(@"%f,%f", self.tabBarController.tabBar.frame.origin.y, self.tabBarController.tabBar.frame.size.height);
    //NSLog(@"%f,%f", self.view.frame.origin.y, self.view.frame.size.height);
    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    //bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
#ifdef __DISPLAY_BANNER__
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
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
   if (addBirthday == EDIT)
   {
            UIImage *image;
           if(self.userImageData != nil){
               image = [[[UIImage alloc] initWithData:self.userImageData] autorelease];
           }
           else
           {
               NSURL *imageURL = [NSURL URLWithString:self.photo];
               NSData* imageD = [NSData dataWithContentsOfURL:imageURL];
               image = [[[UIImage alloc] initWithData:imageD] autorelease];
           }
           
            [photoButton setImage:image forState:UIControlStateNormal];
       
       NSArray* components;
       if([userName rangeOfString:@"?"].location != NSNotFound) {
           components = [userName componentsSeparatedByString:@"?"];
       }else{
           components = [userName componentsSeparatedByString:@" "];
       }
       
       if([components count] == 2){
           [firstNameTextField setText:[Utils trimWhitespace:[components objectAtIndex:0]]];
           [lastNameTextField setText:[Utils trimWhitespace:[components objectAtIndex:1]]];
       }
       else if([components count] == 3)
       {
           [firstNameTextField setText:[Utils trimWhitespace:[components objectAtIndex:0]]];
           [lastNameTextField setText:[Utils trimWhitespace:[components objectAtIndex:2]]];
       }
       [birthdayTextField setText:[Utils trimWhitespace:[Utils formatDateStringWithMonthAndDay:userDate]]];
       firstNameTextField.tag=1;
       lastNameTextField.tag=2;
       birthdayTextField.tag=3;
       [photoButton setTitle:@"" forState:UIControlStateNormal];
   }
   
    birthdayTextField.tag=3;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    //Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setBirthDate:nil];
    [self setUserName:nil];
    [self setUserDate:nil];
    [self setBirthdayTextField:nil];
    [self setLastNameTextField:nil];
    [self setFirstNameTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
}

-(void) setBirth{
 
    UIColor *toolBarColor=  [UIColor colorWithRed:86.0/255 green:66.0/255 blue:16.0/255 alpha:1.0];
    actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    CGRect pickerFrame=CGRectMake(0,44,0,0);
    UIDatePicker *birthdayPicker=[[UIDatePicker alloc]  initWithFrame:pickerFrame];
    
    NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]] autorelease];
    [birthdayPicker setDatePickerMode: UIDatePickerModeDate];
    [birthdayPicker setLocale:locale];
    
    if(self.addBirthday == EDIT)
    {
        NSDate* uDate=[NSDate dateFromString:self.userDate withFormat:@"yyyy-MM-dd"];
        birthdayPicker.date = uDate;
    }
    
    [actionSheet addSubview:birthdayPicker];
    [birthdayPicker release];
    UIToolbar *controlToolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, actionSheet.bounds.size.width, 44)];
    
    [controlToolBar setTintColor:toolBarColor];
    [controlToolBar setBarStyle:UIBarStyleDefault];
    [controlToolBar sizeToFit];
    UIBarButtonItem *spacer=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:
                             UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:
                                 UIBarButtonItemStyleBordered target:self action:@selector(dismissDateSet)];
   
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:
                                   UIBarButtonItemStyleBordered target:self action:@selector(cancelDateSet)];
    
    [controlToolBar setItems:[NSArray arrayWithObjects:cancelButton,spacer,doneButton, nil] animated:NO];
    [spacer release];
    [cancelButton release];
    [doneButton release];
    
    [actionSheet addSubview:controlToolBar];
    [controlToolBar release];
    [actionSheet showInView:self.view];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
}

-(void)cancelDateSet{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void) dismissDateSet{
    
    NSArray *listOfViews=[actionSheet subviews];
    for(UIView *subView in listOfViews){
        if([subView isKindOfClass:[UIDatePicker class]]){
            self.birthDate=[(UIDatePicker*)subView date];
        }
        //NSLog(@"The read date is:%@",self.birthDate);
    }

    [birthdayTextField setText:[NSDate stringFromDate:self.birthDate withFormat:@"MMMM d YYYY"]];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{

    //NSLog(@"The text field tag is:%d",[textField tag]);
    if([textField tag] == 3){
        
        [self setBirth];
        
            BOOL firstTextFieldState =
                    [self.firstNameTextField isFirstResponder];
            BOOL secondTextFieldState =
                    [self.lastNameTextField isFirstResponder];
        
            if (firstTextFieldState){
                [self.firstNameTextField resignFirstResponder];
            }
            if(secondTextFieldState){
                [self.lastNameTextField resignFirstResponder];
            }
        return NO;
    }
    else{
        return YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    if(alertView.tag == 2)
    { 
        if(buttonIndex == 0)
        {
            if(self.addBirthday == EDIT)
            {
                ManageBirthdayViewController *mBirthdayVC=[[ManageBirthdayViewController alloc]initWithNibName:@"ManageBirthdayViewController" bundle:nil];
                // Pop this controller and replace with another
                [self.navigationController  popViewControllerAnimated:YES];
                [self.navigationController pushViewController:mBirthdayVC animated:YES];
                [mBirthdayVC release];
            }
            else
            {
                MainViewController *mBirthdayVC=[[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
                // Pop this controller and replace with another
                [self.navigationController  popViewControllerAnimated:YES];
                [self.navigationController pushViewController:mBirthdayVC animated:YES];
                [mBirthdayVC release];
                
            }
        }
    }
}

-(IBAction)cancelUser:(id)sender{
    
    if(self.addBirthday == 0)
    {
        ManageBirthdayViewController *mBirthdayVC=[[ManageBirthdayViewController alloc]initWithNibName:@"ManageBirthdayViewController" bundle:nil];
        // Pop this controller and replace with another
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController pushViewController:mBirthdayVC animated:YES];
        [mBirthdayVC release];

    }
    else{
        MainViewController *mBirthdayVC=[[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
        // Pop this controller and replace with another
        [self.navigationController  popViewControllerAnimated:YES];
        [self.navigationController pushViewController:mBirthdayVC animated:YES];
        [mBirthdayVC release];

    }
}

- (IBAction)photoTapped {
    // If in editing state, then display an image picker; if not, create and push a photo view controller.
    
	if (self.addBirthday == ADD || self.addBirthday == EDIT) 
    {
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.allowsEditing=YES;
		imagePicker.delegate = self;
        imagePicker.sourceType = 
        UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentModalViewController:imagePicker animated:YES];
		[imagePicker release];
	} 
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
    
	self.pickedImage=selectedImage;
        //NSLog(@"The picked image is:%@",self.pickedImage);
	// Create a thumbnail version of the image for the recipe object.
	CGSize size = selectedImage.size;
	CGFloat ratio = 0;
	if (size.width > size.height) {
		ratio = 60.0 / size.width;
	} else {
		ratio = 60.0 / size.height;
	}

	CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
	
	UIGraphicsBeginImageContext(rect.size);
	[selectedImage drawInRect:rect];
	self.pickedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	[photoButton setImage:self.pickedImage forState:UIControlStateNormal];
    [photoButton setTitle:@"" forState:UIControlStateNormal];
    [self dismissModalViewControllerAnimated:YES];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}


- (void)saveOrEditUser:(NSString *)dateForInsertion nname:(NSString *)nname
{
    NSDictionary *customData = nil;
    if(self.addBirthday == EDIT)
    {
        //self.pickedImage = [UIImage imageNamed:@"DaviaLogo.png"];
        
        if(self.pickedImage != nil)
        {
            NSData* imData  = UIImagePNGRepresentation(self.pickedImage);
            
            NSString *photoForUpdate;
            //if ([self.photo rangeOfString:@"static-ak"].location == NSNotFound)
            //{
                //photoForUpdate = self.photo;
            //}else{
                photoForUpdate = @"empty";
            //}
            
            [dataModel updateCurrentObject:self.userID:
                                    nname:
                                    dateForInsertion:
                                    photoForUpdate:
                                    imData];
            customData = [NSDictionary dictionaryWithObjectsAndKeys:self.userID, @"userID", nname, @"nname", dateForInsertion, @"dateForInsertion", photoForUpdate, @"photo", imData, @"imageData", nil];
            
        }
        else
        {  
            //UIImage *image=[UIImage imageNamed:@"person.png"];
            //NSData *imageData = UIImagePNGRepresentation(image);
            NSData *imageData = nil;
            [dataModel updateCurrentObject:self.userID:
                                                nname:
                                                dateForInsertion:
                                                self.photo:nil];
            customData = [NSDictionary dictionaryWithObjectsAndKeys:self.userID, @"userID", nname, @"nname", dateForInsertion, @"dateForInsertion", self.photo, @"photo", imageData, @"imageData", nil];
            //NSLog(@"%@", customData);
        }
    }
    else if(self.addBirthday == ADD)
    {   
        NSData *imageData = UIImagePNGRepresentation(self.pickedImage);
        int  number = (arc4random()%10000000) + 1;
        NSString *convID = [NSString stringWithFormat:@"%i", number];
        //NSLog(@"the photo is:%@",imageData);
        
        if(imageData != nil){
            customData = [NSDictionary dictionaryWithObjectsAndKeys:convID, @"userID", nname, @"nname", dateForInsertion, @"dateForInsertion", nil, @"photo", imageData, @"imageData", nil];
            [dataModel saveUserToModel:convID:nname:dateForInsertion:nil:imageData];
            [dataModel savingContext];
        }
        else{
            UIImage *image=[UIImage imageNamed:@"person.png"];
            NSData *imageData = UIImagePNGRepresentation(image);
            customData = [NSDictionary dictionaryWithObjectsAndKeys:convID, @"userID", nname, @"nname", dateForInsertion, @"dateForInsertion", @"", @"photo", imageData, @"imageData", nil];
            [dataModel saveUserToModel:convID:nname:dateForInsertion:@"":imageData];
            [dataModel savingContext];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserEdited" object:customData];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Profile successfully updated."
                                                  message:nil
                                                 delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"Ok", nil];
    [alert show];
    alert.tag = 2;
    [alert release];

}

-(IBAction)saveUser:(id)sender
{
    if([firstNameTextField.text length] == 0)
    {
        NSString *message=@"The First Name is required!";
        [Utils messageDisplay:message :nil:(int)nil];
        return;
    } else if ([birthdayTextField.text length] == 0) {
        NSString *message=@"The Birthday Date is required!";
        [Utils messageDisplay:message :nil:(int)nil];
        return;
    } else {
        NSString *fName=[Utils trimWhitespace:firstNameTextField.text];
        NSString *lName=[Utils trimWhitespace:lastNameTextField.text];
        NSString *birthdate=[Utils trimWhitespace:birthdayTextField.text];
        
        //remove the year here.
        NSArray* components = [birthdate componentsSeparatedByString:@" "];
        NSMutableString *mutString=[[[NSMutableString alloc]init] autorelease];
        [mutString appendString:[components objectAtIndex:0]];
        [mutString appendString:@" "];
        [mutString appendString:[components objectAtIndex:1]];
        
        NSString *formatDate=[Utils formatDateStringWithYearMonthDay:mutString];
        NSString *dateForInsertion = [Utils changeYearToCurrent:formatDate];
        NSString *name = [fName stringByAppendingString:@"?"];
        NSString *nname;
        
        if(lName != @"")
        {
            NSString* med=[name stringByAppendingString:@" "];
            nname=[med stringByAppendingString:lName];
        }
        else
        {
            nname=[name stringByAppendingString:@""];
        }
        
        [self saveOrEditUser:dateForInsertion nname:nname];
        
        HolidayAppDelegate *appDelegate = (HolidayAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.kalVC reloadData];
        [appDelegate.kalVC redrawEntireMonth];
        [appDelegate.kalVC clearTable];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end