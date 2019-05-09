//
//  ForgotPinViewController.m
//  BirthdayCalendar
//
//  Created by Dimitar Kamenov on 2/1/13.
//
//

#import "ForgotPinViewController.h"
#import "Utils.h"
#import "HolidayAppDelegate.h"

@interface ForgotPinViewController ()

@end

@implementation ForgotPinViewController

@synthesize emailTextView;
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
    if ([defaultEmail length] == 0) {
        [self.emailTextView becomeFirstResponder];;
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
    [_headerImageView release];
}

- (IBAction)sendEmailButtonClicked:(UIButton*)sender
{
    NSLog(@"sendEmailButtonClicked");
    [self closeKeyboard:self.emailTextView];
    
    [Utils messageDisplay:@"Forgot Pin" :@"A temporary new pin will be sent to you via email" :-1];
    if ([Utils resetAccount:self.emailTextView.text]) {
        NSLog(@"Reset Pin Succeeded");
    } else {
        NSLog(@"Reset Pin Failed. May be email is not registered");
    }
    
    //HolidayAppDelegate *appDelegate = (HolidayAppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.window.rootViewController = appDelegate.forgotPinViewController;
}

- (IBAction)backButtonClicked:(UIButton*)sender
{
    NSLog(@"backButtonClicked");
    [self closeKeyboard:self.emailTextView];
    
    HolidayAppDelegate *appDelegate = (HolidayAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = appDelegate.loginViewController;
}

- (IBAction)closeKeyboard:(UITextField*)sender
{
    NSLog(@"sender: %@", sender);
    [sender resignFirstResponder];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [self closeKeyboard:textField];
}

- (IBAction)closeEmailKeyboard:(id)sender
{
    [self closeKeyboard:self.emailTextView];
}

@end
