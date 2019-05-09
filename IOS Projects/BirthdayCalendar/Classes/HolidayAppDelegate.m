

#import "HolidayAppDelegate.h"
#import "BirthdayCoreDataSource.h"
#import "Kal.h"
#import "Constants.h"
#import "MainViewController.h"
#import "UpcomingViewController.h"
#import "AlertsViewController.h"
#import "SettingsViewController.h"
#import "KalViewController.h"
#import <Facebook.h>
#import "Birthday.h"
#import "Constants.h"
#import "Utils.h"
#import "DataModelManager.h"
#import "Utils.h"

#import "config.h"
#import "GAI.h"

#import "FacebookManager.h"

#import "CreateAccountViewController.h"


@implementation HolidayAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize mainViewController;
@synthesize navController=_navController;
@synthesize birthday;
@synthesize upcomingVC;
@synthesize kalVC;
@synthesize alertsVC;
@synthesize settingsVC;
@synthesize createAccountViewController;
@synthesize loginViewController;
@synthesize forgotPinViewController;
@synthesize datasource;
@synthesize dataModel,managedObjectContext;

@synthesize registered;
@synthesize token;

- (void)startNotifications {
    //NSLog(@"start");
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if ([standardUserDefaults objectForKey:@"daysBefore"] == nil)
    {
        [standardUserDefaults setBool:YES forKey:@"enabled"];
        [standardUserDefaults setBool:YES forKey:@"remindDayOf"];
        [standardUserDefaults setInteger:11 forKey:@"timeOfDay"];
        [standardUserDefaults setInteger:3 forKey:@"daysBefore"];
    }

    BOOL enabled = [standardUserDefaults 
                   boolForKey:@"enabled"];
    BOOL remindDayOf = [standardUserDefaults boolForKey:@"remindDayOf"];
    int  timeOfDay = [standardUserDefaults integerForKey:@"timeOfDay"];
    int  daysBefore = [standardUserDefaults integerForKey:@"daysBefore"];
    
    if (enabled) {
        [Utils setLocalNotification:timeOfDay:remindDayOf:daysBefore];
    }
}

-(void) applicationDidBecomeActive:(UIApplication *)application{
    
    [[FacebookManager sharedManager] handleDidBecomeActive];
        
    if(application.applicationIconBadgeNumber != 0)
    {   
        UIImageView *splashScreen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        
        splashScreen.image = [UIImage imageNamed:@"Default"];
        [window addSubview:splashScreen];
        [UIView transitionWithView: splashScreen
                          duration: 1.8
                           options: UIViewAnimationOptionCurveEaseIn
                        animations: ^{
                            splashScreen.alpha = 0;
                        }
                        completion:^(BOOL finished){
                        }];
        tabBarController.selectedIndex = 1;
        application.applicationIconBadgeNumber = 0;
    }
}

- (void)tabBarInit
{
    kalVC = [[KalViewController alloc] init];
    kalVC.delegate = self;
    dataSource = [[BirthdayCoreDataSource alloc] init];
    kalVC.dataSource = dataSource;
    
    mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    upcomingVC= [[UpcomingViewController alloc] initWithNibName:@"UpcomingViewController" bundle:nil];
    alertsVC= [[AlertsViewController alloc] initWithNibName:@"AlertsViewController" bundle:nil];
    settingsVC= [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    NSArray *controllersArray=[[NSArray alloc]initWithObjects:mainViewController,upcomingVC,kalVC,alertsVC,settingsVC, nil];
    
    createAccountViewController = [[CreateAccountViewController alloc] initWithNibName:@"CreateAccountViewController" bundle:nil];
    
    loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    forgotPinViewController = [[ForgotPinViewController alloc] initWithNibName:@"ForgotPinViewController" bundle:nil];
    
    tabBarController = [[UITabBarController alloc] init];
    [tabBarController  setViewControllers:controllersArray animated:YES];
    tabBarController.selectedIndex = 0;
   // UIColor *color= [UIColor colorWithRed:126.0/255 green:208.0/255 blue:237.0/255 alpha:1.0];
    UIColor *backButtonColor =  [UIColor colorWithRed:86.0/255 green:66.0/255 blue:16.0/255 alpha:1.0];
    //[[UITabBar appearance]  setSelectedImageTintColor:color];
    [[UIBarButtonItem appearance] setTintColor:backButtonColor];
     [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_background.png"]];
    [controllersArray release];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"In applicationDidEnterBackground.");
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.registered = NO;
    
    [self tabBarInit];
    //NSLog(@"In became launching.");
    navController=[[UINavigationController alloc] initWithRootViewController:self.tabBarController];
   
    UILocalNotification *aNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsLocalNotificationKey]; 
    application.applicationIconBadgeNumber = aNotification.applicationIconBadgeNumber;
    
    if (aNotification) {

        NSString *inStr = [NSString stringWithFormat:@"%d", aNotification.applicationIconBadgeNumber];
        if(aNotification.applicationIconBadgeNumber != 0)
        {   
            //upcomingVC.tabBarItem.badgeValue = 0;
            upcomingVC.tabBarItem.badgeValue = inStr;
            application.applicationIconBadgeNumber = 0;
             tabBarController.selectedIndex = 1;
            NSMutableArray *friendsRecords =[dataModel fetchRecords];
            int today = [Utils getUserNumberWithTodayBirthday:friendsRecords];
            if (today > 0) {
                //NSLog(@"TODAY");
            }
        }
    }
    
    DataModelManager* localDataModel = [[DataModelManager alloc]init];
    NSMutableArray* ar=[localDataModel fetchRecords];
    if([ar count] != 0) {
        tabBarController.selectedIndex = 1;
    }
    [localDataModel release];
    
    //[NSThread sleepForTimeInterval:0.5];
    window.rootViewController = navController;
    [window makeKeyAndVisible];
    [navController release];
    
    UIImageView *splashScreen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    splashScreen.image = [UIImage imageNamed:@"Default"];
    [window addSubview:splashScreen];
    [UIView transitionWithView: splashScreen
                      duration: 1.0
                       options: UIViewAnimationOptionCurveEaseIn
                    animations: ^{
                        splashScreen.alpha = 0;
                    }
                    completion:^(BOOL finished){
                    }];
    
    // Let the device know we want to receive push notifications.
    
    [self startNotifications];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOnStartup" object:@""];
    
    // Register to Google Analytics
    
    // Optional: automatically track uncaught exceptions with Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = YES;
    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:GA_TRACKING_ID];
    
    NSLog(@"Initializing GAITracker: %@", tracker);
    
    //[tracker trackView:@"Application Started"];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    
    NSDictionary *remoteNotif = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotif) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        NSDictionary *aps = [remoteNotif valueForKey:@"aps"];
        if (aps) {
            //[Utils messageDisplay:[aps objectForKey:@"alert"]];
            //cardViewController.cardID = [remoteNotif objectForKey:@"card_id"];
            //self.window.rootViewController = cardViewController;
            //[[NSNotificationCenter defaultCenter] postNotificationName:PUSH_NOTIFICATION_ARRIVED object:remoteNotif];
        }
    } else {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        // Check Next Card
        //User* activeUser = [[UserManager sharedManager] activeUser];
        //if (activeUser) {
            //NSNumber *cardID = [Utils nextCardForUser:activeUser];
            //if (cardID && [cardID longLongValue] > 0) {
            //    cardViewController.cardID = cardID;
            //    self.window.rootViewController = cardViewController;
            //}
        //}
    }
    
    //self.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    return YES;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
    //const void *devTokenBytes = [devToken bytes];
    
    //NSLog(@"%@", devToken);
    
    self.registered = YES;
    self.token = [[[[NSString stringWithFormat:@"%@", devToken] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Bytes: %@", self.token);
    
    //User* activeUser = [[UserManager sharedManager] activeUser];
    //if (activeUser != nil) {
    //    NSLog(@"App Lunch: User(%@) active with token: %@", activeUser.userID, devToken);
    //
    //    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:SAVE_APN_URL]];
        
    //    [request setValidatesSecureCertificate:NO];
        
    //    [request addPostValue:@"1.2" forKey:@"proto_version"];
    //    [request addPostValue: @"C4rdi0SH0l1d4y4P1" forKey:@"api_key"];
    //    [request addPostValue:activeUser.userID forKey:@"facebook_id"];
    //    [request addPostValue:token forKey:@"device_token"];
        
    //    [request startSynchronous];
    //    NSError *error = [request error];
    //    if (!error) {
    //        NSString *response = [request responseString];
    //        NSLog(@"Response: %@", response);
    //    } else {
    //        NSLog(@"Error Registering Device");
    //    }
    //}
    //[self sendProviderDeviceToken:devTokenBytes]; // custom method
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

- (void)application:(UIApplication *)app didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Handle the notificaton when the app is running
    NSLog(@"Recieved Notification %@",userInfo);
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //NSLog(@"Recieved Notification %@",UIApplicationLaunchOptionsRemoteNotificationKey);
    NSDictionary* remoteNotif = [userInfo objectForKey:@"aps"];
    if (remoteNotif) {
        [Utils messageDisplay:@"Success" :@"Email successfully confirmed." :-1];
        ///[Utils messageDisplay:@"Birthday Calendar" :[remoteNotif objectForKey:@"alert"] :-1];
        //[Utils messageDisplayWithTag:[Utils applicationDisplayName] :[remoteNotif objectForKey:@"alert"] :1];
        //[[NSNotificationCenter defaultCenter] postNotificationName:PUSH_NOTIFICATION_ARRIVED object:userInfo];
    }
}

// DISABLE remote Notifications
/*
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}
*/

- (void)messageForTodayBirthdays:(int)births {
    NSMutableString *mutString=[[NSMutableString alloc]init];
    [mutString appendString:@"You have "];
    [mutString appendString:[NSString stringWithFormat:@"%d",births]];
    [mutString appendString:@" friends with birthdays today."];
    //NSString* mes=@"You have friends with upcoming birthdays";
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Birthday Reminder" message:mutString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.tag = 2;
    [alert show];
    [alert release];
    [mutString release];
}

- (void)messageForBirthdaysAhead :(int)birthsAhead :(int)daysBefore {
    NSMutableString *mutString=[[NSMutableString alloc]init];
    [mutString appendString:@"You have "];
    [mutString appendString:[NSString stringWithFormat:@"%d",birthsAhead]];
    [mutString appendString:@" friends with birthdays "];
    [mutString appendString:[NSString stringWithFormat:@"%d",daysBefore]];
    [mutString appendString:@" days ahead"];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Birthday Reminder" message:mutString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.tag = 2;
    [alert show];
    [alert release];
    [mutString release];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    self.managedObjectContext=[DataModelManager getObjectModel];
    dataModel = [[DataModelManager alloc]init];

    NSLog(@" app number - %d",notification.applicationIconBadgeNumber);
    
    if(notification.applicationIconBadgeNumber != 0)
    {
        upcomingVC.tabBarItem.badgeValue = 0;
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        
        BOOL remindDayOf = [standardUserDefaults boolForKey:@"remindDayOf"];
        
        NSMutableArray *friendsRecords =[dataModel fetchRecords];        
        if([friendsRecords count] > 0)
        {
            if(remindDayOf)
            {
                int births = [Utils getUserNumberWithTodayBirthday:friendsRecords];
                if(births != 0)
                {
                    [self messageForTodayBirthdays:births];
                }
              
            }
            else
            {
                if([standardUserDefaults objectForKey:@"daysBefore"] != nil)
                {
                    int  daysBefore = [standardUserDefaults
                                            integerForKey:@"daysBefore"];
                    int birthsAhead = [Utils getUserNumberDaysAhead:daysBefore:friendsRecords];
                    if(birthsAhead != 0)
                    {
                        [self messageForBirthdaysAhead:birthsAhead:daysBefore];
                    }
                }
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    birthday = [dataSource holidayAtIndexPath:indexPath];
    NSMutableString *mes = [Utils constructFriendWishMessage:birthday.name];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:mes message:nil delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"Post to Wall",@"Send SMS" ,nil];   
    [alert show];
    alert.tag = 1;
    [alert release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    if(alertView.tag == 1)
    { 
        if(buttonIndex == 0)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
        else if(buttonIndex == 1){        
            [self performSelector:@selector(publishStream) withObject:nil afterDelay:0.3f];
        }else{
            [kalVC sendSMS:birthday.name];            
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
    
    [[[GAI sharedInstance] defaultTracker] trackEventWithCategory:@"Facebook"
                                                       withAction:@"feed"
                                                        withLabel:nil
                                                        withValue:nil];
    
    [[FacebookManager sharedManager].facebook dialog:@"feed"
                    andParams:params
                  andDelegate:self];
    [ms release];
    
   }

- (void)dialogCompleteWithUrl:(NSURL *)url{
    
    NSString *myString = [url absoluteString];
    
    if ([myString rangeOfString:@"post_id"].location != NSNotFound) 
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message posted successfully." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        [alert release];
    }
}

#pragma mark UITableViewDelegate protocol conformance

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FacebookManager sharedManager] handleOpenURL:url];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[FacebookManager sharedManager] closeSession];
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:    (NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        //[alertView dismissWithClickedButtonIndex:0 animated:YES];
        tabBarController.selectedIndex = 1;
        //window.rootViewController = navController;
        //[window makeKeyAndVisible];
        //[navController release];
        
        UIImageView *splashScreen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        
        splashScreen.image = [UIImage imageNamed:@"Default"];
        [window addSubview:splashScreen];
        [UIView transitionWithView: splashScreen
                          duration: 1.0
                           options: UIViewAnimationOptionCurveEaseIn
                        animations: ^{
                            splashScreen.alpha = 0;
                        }
                        completion:^(BOOL finished){
                        }];
    }
}

- (void)dealloc
{
  [kalVC release];
  [dataSource release];
  [window release];
  [_navController release];
  [tabBarController release];
  [alertsVC release];
  [settingsVC release];
  [mainViewController release];
  [birthday release];
  [createAccountViewController release];
  [loginViewController release];
    [forgotPinViewController release];
  [dataModel release];
  [managedObjectContext release];
  [super dealloc];
}

@end