//
//  UpcomingViewController.m
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarBirthdaysViewController.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "DataModelManager.h"
#import "Birthday.h"
#import "CalendarTableViewCell.h"
#import "Utils.h"
#import "Constants.h"
#import <Facebook.h>
#import "UIAlertView+property.h"
#import "Reachability.h"
#import "NSDate+Helper.h"

#import "GAI.h"

#import "config.h"

#import "FacebookManager.h"

@interface CalendarBirthdaysViewController()

- (NSMutableString *)constructLabelTextString:(NSString *)navBarLabelText i_day:(int)i_day;
-(void)filterCalendarBirthdays;

@end

@implementation CalendarBirthdaysViewController

@synthesize birthdaysTableView=_birthdaysTableView;
@synthesize friendsList=_friendsList;
@synthesize managedObjectContext;
@synthesize dataModel;
@synthesize titleLabel;

-(void) dealloc
{    
    [_birthdaysTableView release];
    [_friendsList release];
    [managedObjectContext release];
    [dataModel release];
    [titleLabel release];

    [super dealloc];
}


- (NSMutableString *)constructLabelTextString:(NSString *)navBarLabelText i_day:(int)i_day
{
    NSArray *testArray=[navBarLabelText componentsSeparatedByString:@","]; 
    NSString *monthh=[testArray objectAtIndex:0];
    NSString *yearr=[testArray objectAtIndex:1];
    NSString *dayAsString=[NSString stringWithFormat:@"%d",i_day];
    
    NSMutableString *mutString=[[[NSMutableString alloc]init]autorelease];
    [mutString appendString:monthh];
    [mutString appendString:@" "];
    [mutString appendString:dayAsString];
    [mutString appendString:@","];
    [mutString appendString:yearr];
    return mutString;
}

- (id) initWithUserData :(int)i_year :(int)i_month :(int)i_day :(NSString*)navBarLabelText
{
    if ((self = [super initWithNibName:@"CalendarBirthdaysViewController" bundle:[NSBundle mainBundle]]))
    {
        NSMutableString *mutString;
        mutString = [self constructLabelTextString:navBarLabelText i_day:i_day];
        titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(70,6,200,40)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textColor=[UIColor colorWithRed:254.0/255 green:254.0/255 blue:245.0/255 alpha:1.0];
        titleLabel.font=[UIFont boldSystemFontOfSize:18.f];
        titleLabel.textAlignment=UITextAlignmentCenter;
        [titleLabel setText:mutString];
        
        year = i_year;
        month = i_month;
        day = i_day;
        
    }
    return self;

}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.hidesBackButton = YES;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"Month.png"];

    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        
        [self.navigationController.navigationBar addSubview:titleLabel];
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:11];
    }
    
    // Set the custom back button
    UIImage *buttonImage = [UIImage imageNamed:@"BackCalendar.png"];
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(0,0
                              ,buttonImage.size.width, 
                               buttonImage.size.height);
    [button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    // Cleanup
    [customBarItem release];   
    
}

- (IBAction) handleButton:(id)sender
{
    UIImage *image = [UIImage imageNamed:@"BackCalendar-selected.png"];
    [sender setImage:image forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [[self.navigationController navigationBar] resetBackground:11];
    [titleLabel removeFromSuperview];
    self.tabBarItem.badgeValue = 0;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)filterCalendarBirthdays
{
    NSString *currentYear = [Utils returnCurrentYear];
    NSMutableArray *fetchedRecords=[dataModel fetchRecords];
    
    NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]] autorelease];
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:locale];
	[inputFormatter setDateFormat:@"yyyy-MM-dd"];
    [inputFormatter setTimeZone:[NSTimeZone systemTimeZone]];

    for(int i = 0; i < [fetchedRecords count]; i++)
    {
        UserData *um=[fetchedRecords objectAtIndex:i];
        NSString *newDate=[Utils changeYearToPassed:um.birthday:currentYear];
        NSDate *userDate = [inputFormatter dateFromString:newDate];
        NSArray *splitedDate = [newDate componentsSeparatedByString:@"-"];
        NSInteger userMonth=[[splitedDate objectAtIndex:1] intValue];
        NSInteger userDay=[[splitedDate objectAtIndex:2] intValue];
        
        if(day == userDay && month == userMonth)
        {
            [_friendsList addObject:[Birthday birthdayNamed:um.name:
                                                userDate:um.birthday:um.photo:um.userID:-1:um.thumbimage]];
        }
    }
    if([_friendsList count] != 0){
        [Utils sortBirthdays:_friendsList];
    }
    [inputFormatter release];
    [self.birthdaysTableView reloadData];

}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.trackedViewName = @"CalendarBirthdaysViewController";
    
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
    
    self.managedObjectContext=[DataModelManager getObjectModel];
    dataModel = [[DataModelManager alloc]init];
    _friendsList = [[NSMutableArray alloc]init];
    [self filterCalendarBirthdays];
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
    calCell.userNameLabel.textColor = BROWN_COLOR;
    calCell.userBirthdayDateLabel.textColor=BROWN_COLOR;
    NSString* uname=[birth.name stringByReplacingOccurrencesOfString:@"?" withString:@""];
    calCell.userNameLabel.text = uname;
    
    NSString* result = [Utils formatDateForTableCell:birth.date];
    calCell.userBirthdayDateLabel.text=result;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        
        UIImage *image;
        if(birth.thumbimage != nil)
        {
            image = [[[UIImage alloc] initWithData:birth.thumbimage] autorelease];
            [Utils resizeImage:&image];
            [calCell.imageView stopAnimating];
            calCell.imageView.image = image;
            calCell.imageView.contentMode = UIViewContentModeScaleToFill;
        }
        else
        {
            //calCell.imageView.image = [UIImage imageNamed:@"Spinner.png"];
            calCell.imageView.animationImages = [Utils spinnerImages];
            calCell.imageView.animationDuration = 1.1;
            //calCell.imageView.contentMode = UIViewContentModeCenter;
            [calCell.imageView startAnimating];
            NSURL *imageURL = [NSURL URLWithString:birth.photo];
            NSData* imageD = [NSData dataWithContentsOfURL:imageURL];
            image = [[[UIImage alloc] initWithData:imageD] autorelease];
            [Utils resizeImage:&image];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [calCell.imageView stopAnimating];
            calCell.imageView.image=image;

            if (!birth.thumbimage) 
            {
                NSData *imageData = [[NSData alloc]initWithData:UIImagePNGRepresentation(image)];
                [imageData release];
            }
            [calCell setNeedsLayout];
        });
    });
    
    return calCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friendsList count];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    Birthday *birthday = [self.friendsList objectAtIndex:indexPath.row];
    NSString* uname=[birthday.name stringByReplacingOccurrencesOfString:@"?" withString:@""];
    NSMutableString *mes = [Utils constructFriendWishMessage:uname];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:mes message:nil delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"Post to Wall",@"Send SMS" ,nil];
    [alert show];
    alert.property = birthday;
    alert.tag=1;
    [alert release];
    
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
    Birthday *birthday = (Birthday *)alertView.property;
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
                [self performSelector:@selector(publishStream:) withObject:birthday afterDelay:0.3f];
            }
            else
            {
                    NSString* mes=@"There is no Internet connectivity.";
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

- (void)publishStream:(Birthday*) birthday;
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
                                   //@"https://apps.facebook.com/ davia_calendar/",@"name",
                                   //@"https://apps.facebook.com/davia_calendar/", @"link",
                                   @"  ", @"description",
                                   birthday.userID, @"to",
                                   ms, @"caption",nil];
    
    
    [[[GAI sharedInstance] defaultTracker] trackEventWithCategory:@"Facebook"
                                                       withAction:@"feed"
                                                        withLabel:nil
                                                        withValue:nil];
    
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
