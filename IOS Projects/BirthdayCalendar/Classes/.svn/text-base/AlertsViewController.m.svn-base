//
//  AlertsViewController.m
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlertsViewController.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "Constants.h"

#import "GAI.h"

#import "Utils.h"

@implementation AlertsViewController
@synthesize alertsTable =_alertsTable;
@synthesize alerts;
@synthesize sendLoveInteger;
@synthesize displayPopup;


-(void)dealloc{
    
    [_alertsTable release];
    [alerts release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBarItem setTitle:@"Alerts"];
        self.tabBarItem.tag=4;
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"AlertsD-selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"AlertsD.png"]];
        
        self.displayPopup = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [alerts count];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void) viewWillAppear:(BOOL)animated {
    if (self.displayPopup) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //NSDictionary *sendLoveDict = [NSDictionary dictionaryWithObject:0 forKey:@"sendLoveInteger"];
        //[userDefaults registerDefaults:sendLoveDict];
        sendLoveInteger = [userDefaults integerForKey:@"sendLoveInteger"];
        if (sendLoveInteger > 3) {
            sendLoveInteger = 0;
            self.displayPopup = NO;
            //return;
        }
        [userDefaults setInteger:sendLoveInteger+1 forKey:@"sendLoveInteger"];
        [userDefaults synchronize];
        NSLog(@"sendLove: %d", sendLoveInteger);
        
        if (sendLoveInteger == 0) {
            //NSString* mes = @"If you love the app, please leave us a rating in the app store!";
            NSString* mes = @"If you love the app, please leave us a 5-star rating in the app store!";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send Love" message:mes delegate:self cancelButtonTitle:@"Not now" otherButtonTitles:@"Review", nil];
            [alert show];
            alert.tag=2;
            [alert release];
        } else {
            NSString* mes = @"Click Yes to accept the birthday requests you've received";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Accept Birthday Requests?" message:mes delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
            alert.tag=234;
            [alert release];
            self.displayPopup = NO;
        }
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    UIImage *backgroundImage = [UIImage imageNamed:@"AlertsC"];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:34];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FBDidLogin" object:nil];
    [[self.navigationController navigationBar] resetBackground:34];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.trackedViewName = @"AlertsViewController";
    
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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    alerts = [[NSArray alloc] initWithObjects:@"", nil];
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.alertsTable.bounds.size.width, 20)] autorelease];  
    headerView.backgroundColor=[UIColor clearColor];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 150, headerView.bounds.size.width, 20)] autorelease];
    label.text=@"Your birthday requests have been accepted!";
    label.textColor=[UIColor colorWithRed:145.0/255 green:130.0/255 blue:105.0/255 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:label];
    
    /*
    UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(10, 35, 300, 1)];
    separator.backgroundColor = [UIColor colorWithRed:86.0/255 green:66.0/255 blue:16.0/255 alpha:1.0];
    [headerView addSubview:separator];
    [separator release];
     */
    
    [self.alertsTable setTableHeaderView:headerView];

    // Do any additional setup after loading the view from its nib.
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    if(alertView.tag == 2)
    {
        if(buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_LINK]];
            
            [[[GAI sharedInstance] defaultTracker] trackEventWithCategory:@"uiAction"
                                 withAction:@"buttonPress"
                                  withLabel:@"Send Love Review"
                                  withValue:[NSNumber numberWithInt:100]];
        }
        else {
            //if ([Utils inAppPurchasesAllowed]) {
            //    [Utils requestProductData:self];
            //}
            [[[GAI sharedInstance] defaultTracker] trackEventWithCategory:@"uiAction"
                                                               withAction:@"buttonPress"
                                                                withLabel:@"Send Love Cancel"
                                                                withValue:[NSNumber numberWithInt:101]];
            NSString* mes = @"Click Yes to accept the birthday requests you've received";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Accept Birthday Requests?" message:mes delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
            alert.tag=234;
            [alert release];
        }
    }
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

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
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
                break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    // Your application should implement these two methods.
    //[self recordTransaction:transaction];
    //[self provideContent:transaction.payment.productIdentifier];
    
    // Remove the transaction from the payment queue.
    NSLog(@"transactionReceipt %@", transaction.transactionReceipt);
    NSLog(@"transactionState %d", transaction.transactionState);
    NSLog(@"transactionDate %@", transaction.transactionDate);
    NSLog(@"transactionIdentifier %@", transaction.transactionIdentifier);
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    //[self recordTransaction: transaction];
    //[self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        // Optionally, display an error here.
    }
    NSLog(@"Error: %@", transaction.error.localizedDescription);
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

@end
