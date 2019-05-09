#import <UIKit/UIKit.h>
#import <Facebook.h>
#import <MessageUI/MFMessageComposeViewController.h>

#import "CreateAccountViewController.h"
#import "LoginViewController.h"
#import "ForgotPinViewController.h"

@class  KalViewController;
@class  MainViewController;
@class  Birthday;
@class  UpcomingViewController;
@class  AlertsViewController;
@class  SettingsViewController;
@class  DataModelManager;
@class  CreateAccountViewController;
@class  LoginViewController;
@class  ForgotPinViewController;


@interface HolidayAppDelegate : NSObject <UIApplicationDelegate,UITableViewDelegate,FBDialogDelegate,FBRequestDelegate,UITabBarDelegate,UIAlertViewDelegate>
{
  UIWindow *window;
  UITabBarController *tabBarController;
  UINavigationController *navController;
  KalViewController *kalVC;
  id dataSource;
  MainViewController *mainViewController;
  UpcomingViewController *upcomingVC;
  AlertsViewController *alertsVC;
  SettingsViewController *settingsVC;
  Birthday *birthday;
  DataModelManager *dataModel;
  NSManagedObjectContext *managedContext;



}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic,retain) UINavigationController *navController;
@property (nonatomic,retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic,retain) MainViewController *mainViewController;
@property (nonatomic,retain)  UpcomingViewController *upcomingVC;
@property (nonatomic,retain)  KalViewController *kalVC;
@property (nonatomic,retain)  AlertsViewController *alertsVC;
@property (nonatomic,retain)  SettingsViewController *settingsVC;
@property (nonatomic,retain) Birthday *birthday;
@property (nonatomic,retain) CreateAccountViewController *createAccountViewController;
@property (nonatomic,retain) LoginViewController *loginViewController;
@property (nonatomic,retain) ForgotPinViewController *forgotPinViewController;
@property (nonatomic,retain)id datasource;
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,retain) DataModelManager *dataModel;

@property (assign, nonatomic) BOOL registered;
@property (retain, nonatomic) NSString* token;

- (void)publishStream;
- (void)tabBarInit;
- (void)startNotifications;

@end
