//
//  SettingsViewController.m
//  BirthdayCalendar
//  Created by Petko Yanakiev on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

#import "SettingsViewController.h"
#import "DataModelManager.h"
#import "UserData.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"
#import "HolidayAppDelegate.h"
#import "KalViewController.h"
#import "KalDate.h"
#import "KalTileView.h"
#import "UpcomingViewController.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "Constants.h"
#import "InAppPurchaseManager.h"
#import "ASIHTTPRequest.h"

@interface SettingsViewController()

- (void)initControls;
@end

@implementation SettingsViewController
@synthesize settingsTable=_settingsTable;
@synthesize viewRemindersAccountSettings;
@synthesize viewReminders;
@synthesize viewTimeOfDayAccountSettings;
@synthesize viewTimeOfDay;
@synthesize viewDaysBeforeAccountSettings;
@synthesize viewDaysBefore;
@synthesize viewRemindDayOfAccountSettings;
@synthesize viewRemindDayOf;
@synthesize enabledSwitch;
@synthesize remindDayOfSwitch;
@synthesize timeOfDaySlider;
@synthesize daysBeforeSlider;
@synthesize timeOfDayLabel;
@synthesize daysBeforeLabel;
@synthesize managedObjectContext;
@synthesize dataModel;
@synthesize birthday;
@synthesize scrollViewAccountSettings;
@synthesize scrollViewAccountCreate;

-(void) dealloc{
    
    [_settingsTable release];
    [viewRemindersAccountSettings release];
    [viewReminders release];
    [viewTimeOfDayAccountSettings release];
    [viewTimeOfDay release];
    [viewDaysBeforeAccountSettings release];
    [viewDaysBefore release];
    [viewRemindDayOfAccountSettings release];
    [viewRemindDayOf release];
    [enabledSwitch release];
    [remindDayOfSwitch release];
    [timeOfDaySlider release];
    [daysBeforeSlider release];
    [timeOfDayLabel release];
    [daysBeforeLabel release];
    [managedObjectContext release];
    [dataModel release];
    [birthday release];
    [scrollViewAccountSettings release];
    [scrollViewAccountCreate release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBarItem setTitle:@"Settings"];
        self.tabBarItem.tag=5;
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"SettingsD-selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"SettingsD.png"]];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction) timeOfDaySliderMove:(UISlider *)sender {
    timeOfDayLabel.text = [Utils mapTimeValues:sender.value];
}

- (IBAction) daysBeforeSliderMove:(UISlider *)sender {
    daysBeforeLabel.text = [NSString stringWithFormat:@"%d",(int)daysBeforeSlider.value];
}

- (IBAction) timeOfDaySliderVC:(UISlider *)sender 
{
    NSUserDefaults *timeOfDay = [NSUserDefaults standardUserDefaults];
    [timeOfDay setInteger:sender.value forKey:@"timeOfDay"];
    timeOfDayLabel.text = [Utils mapTimeValues:sender.value];
    
    if(enabledSwitch.isOn)
    {
        [Utils setLocalNotification:sender.value:remindDayOfSwitch.isOn:daysBeforeSlider.value];
    }
} 


- (IBAction) remindDayOfSwitch:(UISwitch *)sender{
    
    BOOL remindDayOf = sender.isOn;
    //BOOL flagRemindDayOf = TRUE;
    //NSString *remindDayOfString = [NSString stringWithFormat:@"%d", remindDayOf];
    //NSString *flagRemindDayOfString = [NSString stringWithFormat:@"%d", flagRemindDayOf];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:remindDayOf forKey:@"remindDayOf"];
    [defaults setBool:TRUE forKey:@"flagRemindDayOf"];
}

- (IBAction) reminderSwitch:(UISwitch *)sender
{
    BOOL enabled = sender.isOn;
    //BOOL flagEnabled = TRUE;
    //NSString *enabledString = [NSString stringWithFormat:@"%d", enabled];
    //NSString *flagEnabledString = [NSString stringWithFormat:@"%d", flagEnabled];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:enabled forKey:@"enabled"];
    [defaults setBool:TRUE forKey:@"flagEnabled"];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    if(alertView.tag == 2)
    {
        if(buttonIndex == 0){
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
    if(alertView.tag == 1)
    {
        if(buttonIndex == 0)
        {
            HolidayAppDelegate *appDelegate = (HolidayAppDelegate *)[[UIApplication sharedApplication] delegate];
            //appDelegate.kalVC.dataSource = nil;
            [dataModel deleteAllObjects:@"UserData"];
            [dataModel deleteAllObjects:@"ContactsData"];
            [appDelegate.kalVC reloadData];
            [appDelegate.kalVC redrawEntireMonth];
            //[(KalView *)appDelegate.kalVC.view selectDate:[KalDate dateFromNSDate:/*self.initialDate]*/[NSDate date]]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CalendarReset" object:@""];
            
            NSString *message=@"Calendar reset successfully";
            [Utils messageDisplay:message:nil:2];
       
        }
        else if(buttonIndex == 1)
        {        
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}

- (IBAction) resetCalendar:(UIButton *)sender
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Reseting your calendar will permanently remove all saved birthdays. This action cannot be undone. Are you sure?" message:nil delegate:self cancelButtonTitle:@"Reset" otherButtonTitles:@"Cancel", nil];
    [alert show];
    alert.tag = 1;
    [alert release];
}

- (IBAction) daysBeforeSliderVC:(UISlider *)sender 
{  
    daysBeforeLabel.text = [NSString stringWithFormat:@"%d",(int)daysBeforeSlider.value];
    NSUserDefaults *daysBefore = [NSUserDefaults standardUserDefaults];
    [daysBefore setFloat:(int)sender.value forKey:@"daysBefore"];
    
} 

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.trackedViewName = @"SettingsViewController";
    
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
    
    //CALayer *l = [viewm layer];
    //[l setMasksToBounds:YES];
    //[l setCornerRadius:10.0];
    //l.borderColor = [UIColor grayColor].CGColor;
    //l.borderWidth = 1.0f;
    
    viewRemindersAccountSettings.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"OptionsButtonBase.png"]];
    viewReminders.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"OptionsButtonBase.png"]];
    
    viewTimeOfDayAccountSettings.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"OptionsButtonBase.png"]];
    viewTimeOfDay.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"OptionsButtonBase.png"]];
    
    viewDaysBeforeAccountSettings.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"OptionsButtonBase.png"]];
    viewDaysBefore.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"OptionsButtonBase.png"]];
    
    viewRemindDayOfAccountSettings.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"OptionsButtonBase.png"]];
    viewRemindDayOf.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"OptionsButtonBase.png"]];
    
    //CGRect _headerImageViewRect = viewReminders.frame;
    //_headerImageViewRect.size.height += [Utils nonRetina4correction];
    //viewReminders.frame = _headerImageViewRect;
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    //UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 1)];
    //separator.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    
    //UIView * separator2 = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 320, 1)];
    //separator2.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    
    //UIView *separator3 = [[UIView alloc] initWithFrame:CGRectMake(0, 153, 320, 1)];
    //separator3.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    
    //[self.viewm addSubview:separator];
    //[self.viewm addSubview:separator2];
    //[self.viewm addSubview:separator3];
    
    //[separator release];
    //[separator2 release];
    //[separator3 release];
    
    timeOfDayLabel.text  = @"11 AM";
    daysBeforeLabel.text = @"3";
    self.managedObjectContext=[DataModelManager getObjectModel];
    
    dataModel = [[DataModelManager alloc]init];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    CGRect viewRect = self.view.frame;
    viewRect.size.height -= [Utils nonRetina4correction];
    self.view.frame = viewRect;
    
    BOOL accountCreated = NO;
    
    if (accountCreated) {
        // set the content size to be the size our our whole frame
        self.scrollViewAccountSettings.contentSize = self.scrollViewAccountSettings.frame.size;
    
        // then set frame to be the size of the view's frame
        self.scrollViewAccountSettings.frame = self.view.frame;
    
        // now add our scroll view to the main view
        [self.view addSubview:self.scrollViewAccountSettings];
    } else {
        // set the content size to be the size our our whole frame
        self.scrollViewAccountCreate.contentSize = self.scrollViewAccountCreate.frame.size;
        
        // then set frame to be the size of the view's frame
        self.scrollViewAccountCreate.frame = self.view.frame;
        
        // now add our scroll view to the main view
        [self.view addSubview:self.scrollViewAccountCreate];
    }
}

- (void)initControls
{
    BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"enabled"];
    BOOL flagenabled = [[NSUserDefaults standardUserDefaults]  boolForKey:@"flagEnabled"];
    BOOL remindDayOf = [[NSUserDefaults standardUserDefaults] boolForKey:@"remindDayOf"];
    BOOL flagRemindDayOf = [[NSUserDefaults standardUserDefaults] boolForKey:@"flagRemindDayOf"];
    int timeOfDay = [[NSUserDefaults standardUserDefaults] integerForKey:@"timeOfDay"];
    int daysBefore = [[NSUserDefaults standardUserDefaults] integerForKey:@"daysBefore"];
    
    BOOL initEnableSwitch = enabledSwitch.isOn;
    BOOL initRemindDayOfSwitch = remindDayOfSwitch.isOn;
    
    if(flagenabled){
        [enabledSwitch setOn:enabled];
    }else{
        [enabledSwitch setOn:initEnableSwitch];
    }
    
    if(flagRemindDayOf){
        [remindDayOfSwitch setOn:remindDayOf];
    }else{
        [remindDayOfSwitch setOn:initRemindDayOfSwitch];
    }
    
    if(timeOfDay != 0)
    {
        [timeOfDaySlider setValue:timeOfDay];
        NSString *result = [Utils mapTimeValues:timeOfDay];
        timeOfDayLabel.text = result;
    }
    if(daysBefore != 0)
    {
        [daysBeforeSlider setValue:daysBefore];
        daysBeforeLabel.text=[NSString stringWithFormat:@"%d",daysBefore];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self initControls];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    UIImage *backgroundImage = [UIImage imageNamed:@"NavBar_Account_Settings"];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:44];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
     [[self.navigationController navigationBar] resetBackground:44];
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

- (IBAction) buttonLogoutClicked:(UIButton*)sender
{
    NSLog(@"buttonLogoutClicked");
    NSString *sessionID = [Utils getSessionID];
    NSLog(@"session id: '%@'", sessionID);
    if (sessionID && [Utils logoutAccount:sessionID]) {
        [Utils setSessionID:nil];
    }
}

- (IBAction) buttonSendConfirmMailClicked:(UIButton*)sender
{
    NSLog(@"buttonSendConfirmMailClicked");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultEmail = [userDefaults stringForKey:@"defaultUserEmail"];
    if (defaultEmail) {
        [Utils resendEmail:defaultEmail];    
    }
}

- (IBAction) buttonUpgradeClicked:(UIButton*)sender
{
    NSLog(@"buttonUpgradeClicked");
    if ([[InAppPurchaseManager sharedManager] inAppPurchasesAllowed]) {
        [[InAppPurchaseManager sharedManager] requestProductData:self];
    }
}

- (IBAction) buttonRestorePurchasesClicked:(UIButton*)sender
{
    NSLog(@"buttonRestorePurchasesClicked");
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (IBAction) buttonCreateAccountClicked:(UIButton*)sender
{
    NSLog(@"buttonCreateAccountClicked");
    HolidayAppDelegate *appDelegate = (HolidayAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = appDelegate.createAccountViewController;
}

#pragma mark InApp Purchase Callbacks

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *myProducts = response.products;
    for (SKProduct* skProduct in myProducts) {
        NSLog(@"skProduct.localizedDescription: %@", skProduct.localizedDescription);
        NSLog(@"skProduct.localizedTitle: %@", skProduct.localizedTitle);
        NSLog(@"skProduct.price: %@", skProduct.price);
        NSLog(@"skProduct.priceLocale: %@", skProduct.priceLocale);
        NSLog(@"skProduct.productIdentifier: %@", skProduct.productIdentifier);
        NSLog(@"skProduct.downloadable: %d", skProduct.downloadable);
        NSLog(@"skProduct.downloadContentLengths: %@", skProduct.downloadContentLengths);
        NSLog(@"skProduct.downloadContentVersion: %@", skProduct.downloadContentVersion);
        
        if ([SKPaymentQueue canMakePayments]) {
            NSLog(@"Can Make Payments");
            //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            //[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        }
        
        SKPayment* payment = [SKPayment paymentWithProduct:skProduct];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
        //SKPaymentQueue* paymentQueue = [[[SKPaymentQueue alloc] init] autorelease];
        //[paymentQueue addPayment:payment];
        
        //MyStoreObserver *observer = [[MyStoreObserver alloc] init];
        //[[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
    }
    // Populate your UI from the products list.
    // Save a reference to the products list.
    
    
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        [self restoreTransaction:transaction];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your add-ons have been restored." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    return;
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        NSData *receiptData;
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                receiptData = [transaction transactionReceipt];
                NSLog(@"reciept data: %@", receiptData);
                break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    // Your application should implement these two methods.
    //[self recordTransaction:transaction];
    //[self provideContent:transaction.payment.productIdentifier];
    
    NSData *receiptData = [transaction transactionReceipt];
    NSLog(@"reciept data: %@", receiptData);
    // Remove the transaction from the payment queue.
    NSLog(@"transactionReceipt %@", transaction.transactionReceipt);
    NSLog(@"transactionState %d", transaction.transactionState);
    NSLog(@"transactionDate %@", transaction.transactionDate);
    NSLog(@"transactionIdentifier %@", transaction.transactionIdentifier);
    NSLog(@"transactionIdentifier %@", transaction.payment.productIdentifier);
    
    //[Utils messageDisplay:@"completeTransaction" :transaction.description :-1];
    //[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [self finishTransaction:transaction wasSuccessful:YES];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    //[self recordTransaction: transaction];
    //[self provideContent: transaction.originalTransaction.payment.productIdentifier];
    
    //[Utils messageDisplay:@"completeTransaction" :transaction.description :-1];
    //[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [self finishTransaction:transaction wasSuccessful:YES];
}

- (BOOL) verifyReciept: (NSData*) reciept
{
    NSString *base64 = [ASIHTTPRequest base64forData:reciept];
    NSLog(@"base64 %@", reciept);
    NSLog(@"base64 %@", base64);
    
    NSString *recieptJSON = [[[NSString alloc] initWithFormat:@"{\"receipt-data\" : \"%@\"}", base64] autorelease];
    //NSLog(@"recieptJSON: %@", recieptJSON);
    
    //NSURL *url = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
    NSURL *url = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setValidatesSecureCertificate:NO];
    
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request  setRequestMethod:@"POST"];
    [request appendPostData:[recieptJSON  dataUsingEncoding:NSUTF8StringEncoding]];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"Response: %@", response);
        if ([response rangeOfString:@"status"].location != NSNotFound) {
            NSLog(@"Logon Successful");
            NSArray* components = [response componentsSeparatedByString:@":"];
            if ([components count] > 1) {
                NSString* statusCode = [[[[components objectAtIndex:1]stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""]stringByReplacingOccurrencesOfString:@"}" withString:@""];
                if ([statusCode compare:@"21007"] == NSOrderedSame) {
                    // Check Sandbox
                    request.url = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
                    NSLog(@"request is: %@", request);
                    [request startSynchronous];
                    NSError *error = [request error];
                    if (!error) {
                        NSLog(@"Response: %@", response);
                    } else {
                        NSLog(@"Error Validating User");    
                    }
                }
            } else {
                NSLog(@"Error Validating User");
            }
        } else {
            NSLog(@"Error Validating User");
        }
    } else {
        NSLog(@"Error Validating User");
    }
    
    //{
    //
    //    "receipt-data" : "(receipt bytes here)"
    //
    //}
    return YES;
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        // Optionally, display an error here.
        NSLog(@"Real ERROR:");
        [self finishTransaction:transaction wasSuccessful:NO];
    } else {
        NSLog(@"Code Enum: %d", SKErrorPaymentCancelled);
        NSLog(@"Error: %@", transaction.error.localizedDescription);
        NSLog(@"Code: %d", transaction.error.code);
        NSData *receiptData = [transaction transactionReceipt];
        //NSLog(@"reciept data: %@", receiptData);
        //[Utils messageDisplay:@"failedTransaction" :transaction.description :-1];
        //[Utils messageDisplay:@"failedTransaction" :transaction.error.localizedDescription :-1];
        //[Utils messageDisplay:@"restoreTransaction" :transaction.error.debugDescription :-1];
    
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    }
}

- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    NSLog(@"finishTransaction: %@", userInfo);
    if (wasSuccessful)
    {
        [self verifyReciept:transaction.transactionReceipt];
        // send out a notification that we’ve finished the transaction
        //[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        //[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

@end
