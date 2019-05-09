//
//  LoginViewController.m
//  BirthdayCalendar
//
//  Created by Dimitar Kamenov on 2/1/13.
//
//

#import "LoginViewController.h"
#import "HolidayAppDelegate.h"
#import "Utils.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize emailTextView;
@synthesize pinTextView;
@synthesize headerImageView=_headerImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"AccountBase.png"]]];
    
    CGRect _headerImageViewRect = _headerImageView.frame;
    _headerImageViewRect.size.height += [Utils nonRetina4correction];
    _headerImageView.frame = _headerImageViewRect;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultEmail = [userDefaults stringForKey:@"defaultUserEmail"];
    self.emailTextView.text = defaultEmail;
    if ([defaultEmail length] > 0) {
        [self.pinTextView becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [super dealloc];
    
    [emailTextView release];
    [pinTextView release];
    [_headerImageView release];
}

- (IBAction)loginButtonClicked:(UIButton*)sender
{
    NSLog(@"loginButtonClicked");
    [self closeAllKeyboards:sender];
    
    if ([self.pinTextView.text length] != 4) {
        [Utils messageDisplay:@"Invalid Pin" :@"Pin must be 4 digits long." :-1];
    } else {
        NSString *sessionID = [Utils loginAccount:self.emailTextView.text account_pin:self.pinTextView.text];
        if (sessionID) {
            // Login successeded. Persist Session ID.
            [Utils setSessionID:sessionID];

            HolidayAppDelegate *appDelegate = (HolidayAppDelegate *)[[UIApplication sharedApplication] delegate];
            //appDelegate.window.rootViewController = appDelegate.tabBarController;
            //appDelegate.tabBarController.selectedIndex = 4;
            
            appDelegate.tabBarController.selectedIndex=4;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:appDelegate.tabBarController];
            appDelegate.window.rootViewController = navController;
            [appDelegate.window makeKeyAndVisible];
            [navController release];
            
        } else {
            [Utils messageDisplay:@"Login Error" :@"Incorrect Pin" :-1];
        }
    }
}

- (IBAction)forgotPinButtonClicked:(UIButton*)sender
{
    NSLog(@"forgotPinButtonClicked");
    [self closeAllKeyboards:sender];
    
    HolidayAppDelegate *appDelegate = (HolidayAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = appDelegate.forgotPinViewController;
}

- (IBAction)closeKeyboard:(UITextField*)sender {
    NSLog(@"sender: %@", sender);
    [sender resignFirstResponder];
    if (sender == self.emailTextView) {
        if (![self.pinTextView.text length]) {
            [self.pinTextView becomeFirstResponder];
            return;
        }
    }
}

- (IBAction)closeAllKeyboards:(UIControl*)sender {
    NSLog(@"sender: %@", sender);
    [self.emailTextView resignFirstResponder];
    [self.pinTextView resignFirstResponder];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self closeAllKeyboards:textField];
}

@end
