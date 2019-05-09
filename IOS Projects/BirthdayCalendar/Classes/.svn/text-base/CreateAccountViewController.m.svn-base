//
//  CreateAccountViewController.m
//  BirthdayCalendar
//
//  Created by Dimitar Kamenov on 1/21/13.
//
//

#import "CreateAccountViewController.h"

#import "HolidayAppDelegate.h"
#import "MainViewController.h"

#import "config.h"

#ifdef __DISPLAY_BANNER__
#import "GADBannerView.h"
#endif /* __DISPLAY_BANNER__ */

#import "Constants.h"
#import "Utils.h"
#import "EmailTableCell.h"

#import "NSDate+Helper.h"

#import <QuartzCore/QuartzCore.h>

@interface CreateAccountViewController ()

@end

@implementation CreateAccountViewController

@synthesize headerImageView = _headerImageView;
@synthesize menuTableView = _menuTableView;
@synthesize labelTermsOfService = _labelTermsOfService;
@synthesize labelPrivacyPolicy = _labelPrivacyPolicy;
@synthesize tapGestureRecognizerTerms = _tapGestureRecognizerTerms;
@synthesize tapGestureRecognizerPrivacy = _tapGestureRecognizerPrivacy;

@synthesize emailTableCell=_emailTableCell;
@synthesize birthdayTableCell=_birthdayTableCell;
@synthesize keepBirthPrivateCell=_keepBirthPrivateCell;
@synthesize genderTableViewCell=_genderTableViewCell;
@synthesize pinTableViewCell=_pinTableViewCell;

@synthesize arrayNo=_arrayNo;

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
#ifdef __DISPLAY_BANNER__
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            _headerImageView.frame.origin.y + _headerImageView.frame.size.height/* + 1*/,
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
    
    _menuTableView.layer.cornerRadius=10.0;

    self.tapGestureRecognizerTerms = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapTerms:)] autorelease];
    [self.tapGestureRecognizerTerms setDelegate:self];
    [_labelTermsOfService addGestureRecognizer:self.tapGestureRecognizerTerms];
    
    self.tapGestureRecognizerPrivacy = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapPrivacy:)] autorelease];
    [self.tapGestureRecognizerPrivacy setDelegate:self];
    [_labelTermsOfService addGestureRecognizer:self.tapGestureRecognizerPrivacy];
    [_labelPrivacyPolicy addGestureRecognizer:self.tapGestureRecognizerPrivacy];
    
    CGRect _headerImageViewRect = _headerImageView.frame;
    _headerImageViewRect.size.height += [Utils nonRetina4correction];
    _headerImageView.frame = _headerImageViewRect;
    
    CGRect _menuTableRect = _menuTableView.frame;
    _menuTableRect.size.height += [Utils nonRetina4correction];
    _menuTableView.frame = _menuTableRect;
    
    NSArray *nib;
    nib = [[NSBundle mainBundle] loadNibNamed:@"EmailTableCell" owner:self options:nil];
    _emailTableCell = [nib objectAtIndex:0];

    nib = [[NSBundle mainBundle] loadNibNamed:@"BirthdayTableCell" owner:self options:nil];
    _birthdayTableCell = [nib objectAtIndex:0];

    nib = [[NSBundle mainBundle] loadNibNamed:@"KeepBirthPrivateCell" owner:self options:nil];
    _keepBirthPrivateCell = [nib objectAtIndex:0];
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"GenderTableViewCell" owner:self options:nil];
    _genderTableViewCell = [nib objectAtIndex:0];

    nib = [[NSBundle mainBundle] loadNibNamed:@"PinTableViewCell" owner:self options:nil];
    _pinTableViewCell = [nib objectAtIndex:0];
    
    _arrayNo = [[NSMutableArray alloc] initWithObjects:@"Male", @"Female", nil];
    
    NSLog(@"frame: %f", self.view.frame.size.height);
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"AccountBase.png"]]];
}

- (void)viewDidUnload {
#ifdef __DISPLAY_BANNER__
    [bannerView_ release];
#endif /* __DISPLAY_BANNER__ */
    [super viewDidUnload];
}

- (void) dealloc {
    [_headerImageView release];
    [_menuTableView release];
    [_labelTermsOfService release];
    [_labelPrivacyPolicy release];
    [_tapGestureRecognizerTerms release];
    [_tapGestureRecognizerPrivacy release];
    [_emailTableCell release];
    [_birthdayTableCell release];
    [_keepBirthPrivateCell release];
    [_genderTableViewCell release];
    [_pinTableViewCell release];
    [_arrayNo release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Validation Dialogs

- (void) dialogMissingFields:(NSString*) missingFieldsList {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Missing Required Fields" message:[NSString stringWithFormat:@"You must fill in the following fields:\n%@", missingFieldsList] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

- (void) dialogInvalidEmail {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid Email" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

- (void) dialogInvalidPIN {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Pin" message:@"Pin must be 4 digits long." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

#pragma mark UI Control Callbacks

- (IBAction)skipClicked:(UIButton*)skipButton {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are You Sure?" message:@"Without an account your friends may not be able to add your birthdate to their calendars and your data may not be recoverable after device resets." delegate:self cancelButtonTitle:@"Skip" otherButtonTitles:@"Create", nil];
    [alert show];
    alert.tag=1;
    [alert release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"menuCellIdentifier";
    
    NSUInteger row = [indexPath row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        //NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CardTableCell" owner:self options:nil];
        switch (row) {
            case 0:
                cell = _emailTableCell;
                break;
            case 1:
                cell = _birthdayTableCell;
                break;
            case 2:
                cell = _keepBirthPrivateCell;
                break;
            case 3:
                cell = _genderTableViewCell;
                break;
            case 4:
                cell = _pinTableViewCell;
                break;
            default:
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
                cell.textLabel.text = @"row";
                break;
        }
    }
    
    //NSUInteger row = [indexPath row];
    
    return cell;
}

-(BOOL) validateEmail:(NSString *)email
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL )validateFields {
    BOOL result = YES;
    if (![_emailTableCell.emailTextField.text length]) {
        [self dialogMissingFields:@"Email"];
        result = NO;
    } else if (![self validateEmail:_emailTableCell.emailTextField.text]) {
        [self dialogInvalidEmail];
        result = NO;
    } else if (![_birthdayTableCell.birthdayDateField.text length]) {
        [self dialogMissingFields:@"Birthday"];
        result = NO;
    } else if (![_genderTableViewCell.genderTextField.text length]) {
        [self dialogMissingFields:@"Gender"];
        result = NO;
    } else if ([_pinTableViewCell.pinTextField.text length] != 4) {
        [self dialogInvalidPIN];
        result = NO;
    }
    
    return result;
};

- (IBAction)buttonCreateClicked:(UIButton*)buttonCreate {
    NSLog(@"buttonCreateClicked");
    
    HolidayAppDelegate *appDelegate = (HolidayAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([self validateFields]) {
        NSLog(@"Fields are Valid");
        if ([Utils createAccount:_emailTableCell.emailTextField.text account_birthday:_birthdayTableCell.birthdayDateField.text account_birthday_private:_keepBirthPrivateCell.keepPrivateCheckbox.checked account_gender:_genderTableViewCell.genderTextField.text account_pin:_pinTableViewCell.pinTextField.text device_apn_token:appDelegate.token]) {
            [Utils messageDisplay:@"Success!" :@"Your account has been successfully created!" :-1];
            
            // Persist E-mail account.
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:_emailTableCell.emailTextField.text forKey:@"defaultUserEmail"];
            [userDefaults synchronize];
        } else {
            [Utils messageDisplay:@"Failed!" :@"Unable to create account!" :-1];
        }
    } else {
        NSLog(@"Fields are Invalid");
    }
}

- (IBAction)buttonLoginClicked:(UIButton*)buttonLogin {
    NSLog(@"buttonLoginClicked");
    
    HolidayAppDelegate *appDelegate = (HolidayAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = appDelegate.loginViewController;
}

- (void)handleTapTerms:(UITapGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] != UIGestureRecognizerStateEnded) {
        return;
    }
    
    //NSLog(@"Terms");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.daviacalendar.com/TermsOfUse.html"]];
    
}

- (void)handleTapPrivacy:(UITapGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] != UIGestureRecognizerStateEnded) {
        return;
    }
    
    //NSLog(@"Privacy");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.daviacalendar.com/PrivacyPolicy.html"]];
}

- (IBAction)closeKeyboard:(UITextField*)sender {
    NSLog(@"sender: %@", sender);
    [sender resignFirstResponder];
    if (sender == _emailTableCell.emailTextField) {
        if (![_birthdayTableCell.birthdayDateField.text length]) {
            [_birthdayTableCell.birthdayDateField becomeFirstResponder];
            return;
        }
        if (![_genderTableViewCell.genderTextField.text length]) {
            [_genderTableViewCell.genderTextField becomeFirstResponder];
            return;
        }
        if (![_pinTableViewCell.pinTextField.text length]) {
            [_pinTableViewCell.pinTextField becomeFirstResponder];
            return;
        }
    }
}

- (IBAction)closeAllKeyboards:(UIControl*)sender {
    NSLog(@"sender: %@", sender);
    [_emailTableCell.emailTextField resignFirstResponder];
    [_birthdayTableCell.birthdayDateField resignFirstResponder];
    [_genderTableViewCell.genderTextField resignFirstResponder];
    [_pinTableViewCell.pinTextField resignFirstResponder];
}

- (IBAction)pinCodeValueChanged:(UITextField*)sender {
    //NSLog(@"sender: %@", sender.text);
    if ([sender.text length] >= 4) {
        sender.text = [sender.text substringToIndex:4];
        //NSLog(@"sender: %@", sender.text);
        [sender performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0.5];
        //[sender resignFirstResponder];
    }
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
    
    //if(self.addBirthday == EDIT)
    //{
    //    NSDate* uDate=[NSDate dateFromString:self.userDate withFormat:@"yyyy-MM-dd"];
    //    birthdayPicker.date = uDate;
    //}
    
    NSDate* uDate;
    NSString* date = _birthdayTableCell.birthdayDateField.text;
    if ([date length] == 0) {
        uDate=[NSDate date];
    } else {
        uDate=[NSDate dateFromString:date withFormat:@"MMMM d, YYYY"];
    }
    
    birthdayPicker.date = uDate;
    
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
    
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc] initWithTitle:@"Clear" style:
                                   UIBarButtonItemStyleBordered target:self action:@selector(clearDateSet)];
    
    [controlToolBar setItems:[NSArray arrayWithObjects:cancelButton,spacer,doneButton, nil] animated:NO];
    [spacer release];
    [cancelButton release];
    [doneButton release];
    
    [actionSheet addSubview:controlToolBar];
    [controlToolBar release];
    [actionSheet showInView:self.view];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    [actionSheet release];
}

-(void) setGender{
    
    UIColor *toolBarColor=  [UIColor colorWithRed:86.0/255 green:66.0/255 blue:16.0/255 alpha:1.0];
    actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    CGRect pickerFrame=CGRectMake(0,44,0,0);
    UIPickerView *pickerView=[[UIPickerView alloc]  initWithFrame:pickerFrame];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    [pickerView selectRow:0 inComponent:0 animated:NO];
    [pickerView setShowsSelectionIndicator:YES];
    
    _genderTableViewCell.genderTextField.text= [_arrayNo objectAtIndex:[pickerView selectedRowInComponent:0]];
    
    //NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]] autorelease];
    
    //[pickerView setDatePickerMode: UIDatePickerModeDate];
    //[pickerView setLocale:locale];
    
    //if(self.addBirthday == EDIT)
    //{
    //    NSDate* uDate=[NSDate dateFromString:self.userDate withFormat:@"yyyy-MM-dd"];
    //    birthdayPicker.date = uDate;
    //}
    
    //NSDate* uDate;
    //NSString* date = _birthdayTableCell.birthdayDateField.text;
    //if ([date length] == 0) {
    //    uDate=[[NSDate alloc] init];
    //} else {
    //    uDate=[NSDate dateFromString:date withFormat:@"MMMM d, YYYY"];
    //}
    
    //pickerView.date = uDate;
    
    [actionSheet addSubview:pickerView];
    [pickerView release];
    UIToolbar *controlToolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, actionSheet.bounds.size.width, 44)];
    
    [controlToolBar setTintColor:toolBarColor];
    [controlToolBar setBarStyle:UIBarStyleDefault];
    [controlToolBar sizeToFit];
    UIBarButtonItem *spacer=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:
                             UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:
                                 UIBarButtonItemStyleBordered target:self action:@selector(dismissGenderSet)];
    
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc] initWithTitle:@"Clear" style:
                                   UIBarButtonItemStyleBordered target:self action:@selector(clearGenderSet)];
    
    [controlToolBar setItems:[NSArray arrayWithObjects:cancelButton,spacer,doneButton, nil] animated:NO];
    [spacer release];
    [cancelButton release];
    [doneButton release];
    
    [actionSheet addSubview:controlToolBar];
    [controlToolBar release];
    [actionSheet showInView:self.view];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    [actionSheet release];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _genderTableViewCell.genderTextField.text =  [_arrayNo objectAtIndex:row];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    if (![_pinTableViewCell.pinTextField.text length]) {
        [_pinTableViewCell.pinTextField becomeFirstResponder];
        return;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [_arrayNo count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [_arrayNo objectAtIndex:row];
}


-(void)cancelDateSet{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)clearDateSet{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [_birthdayTableCell.birthdayDateField setText:@""];
    if (![_genderTableViewCell.genderTextField.text length]) {
        [_genderTableViewCell.genderTextField becomeFirstResponder];
        return;
    }
    if (![_pinTableViewCell.pinTextField.text length]) {
        [_pinTableViewCell.pinTextField becomeFirstResponder];
        return;
    }
}

-(void) dismissDateSet{
    NSDate* birthDate = nil;
    
    NSArray *listOfViews=[actionSheet subviews];
    for(UIView *subView in listOfViews){
        if([subView isKindOfClass:[UIDatePicker class]]){
            birthDate=[(UIDatePicker*)subView date];
        }
        //NSLog(@"The read date is:%@",self.birthDate);
    }
    
    //[birthdayTextField setText:[NSDate stringFromDate:birthDate withFormat:@"MMMM d YYYY"]];
    if (birthDate != nil) {
        [_birthdayTableCell.birthdayDateField setText:[NSDate stringFromDate:birthDate withFormat:@"MMMM d, YYYY"]];
    }
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    if (![_genderTableViewCell.genderTextField.text length]) {
        [_genderTableViewCell.genderTextField becomeFirstResponder];
        return;
    }
    if (![_pinTableViewCell.pinTextField.text length]) {
        [_pinTableViewCell.pinTextField becomeFirstResponder];
        return;
    }
}

-(void)cancelGenderSet{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)clearGenderSet{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [_genderTableViewCell.genderTextField setText:@""];
    if (![_pinTableViewCell.pinTextField.text length]) {
        [_pinTableViewCell.pinTextField becomeFirstResponder];
        return;
    }
}

-(void) dismissGenderSet{
    NSString* gender = nil;
    
    NSArray *listOfViews=[actionSheet subviews];
    for(UIView *subView in listOfViews){
        if([subView isKindOfClass:[UIPickerView class]]){
            gender=[_arrayNo objectAtIndex:[(UIPickerView*)subView selectedRowInComponent:0]];
        }
        //NSLog(@"The read date is:%@",self.birthDate);
    }
    
    //[birthdayTextField setText:[NSDate stringFromDate:birthDate withFormat:@"MMMM d YYYY"]];
    if (gender != nil) {
        [_genderTableViewCell.genderTextField setText:gender];
    }
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    if (![_pinTableViewCell.pinTextField.text length]) {
        [_pinTableViewCell.pinTextField becomeFirstResponder];
        return;
    }
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField == _birthdayTableCell.birthdayDateField){
        
        [self setBirth];
        
        [_emailTableCell.emailTextField resignFirstResponder];
        //[_birthdayTableCell.birthdayDateField resignFirstResponder];
        [_genderTableViewCell.genderTextField resignFirstResponder];
        [_pinTableViewCell.pinTextField resignFirstResponder];
        
        return NO;
    } else if (textField == _genderTableViewCell.genderTextField) {
        [self setGender];
        
        [_emailTableCell.emailTextField resignFirstResponder];
        [_birthdayTableCell.birthdayDateField resignFirstResponder];
        //[_genderTableViewCell.genderTextField resignFirstResponder];
        [_pinTableViewCell.pinTextField resignFirstResponder];
        
        return NO;
    }
    else{
        return YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            NSLog(@"Skip Button Clicked");
            HolidayAppDelegate *appDelegate = (HolidayAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            //MainViewController *mBirthdayVC=[[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
            // Pop this controller and replace with another
            //[self.navigationController  popViewControllerAnimated:YES];
            //[self.navigationController pushViewController:mBirthdayVC animated:YES];
            //[mBirthdayVC release];
            
            //appDelegate.tabBarController.selectedIndex=0;
            //appDelegate.window.rootViewController = appDelegate.navController;
            
            appDelegate.tabBarController.selectedIndex=0;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:appDelegate.tabBarController];
            appDelegate.window.rootViewController = navController;
            [appDelegate.window makeKeyAndVisible];
            [navController release];
            
            //tabBarController.selectedIndex = 1;
            //window.rootViewController = navController;
            //[window makeKeyAndVisible];
            //[navController release];
            
            //appDelegate.window.rootViewController = appDelegate.tabBarController;
            
            //[self.navigationController popViewControllerAnimated:YES];
            
            //MainViewController *mainVC =
            //[[MainViewController alloc]initWithContacts:ff];
            //appDelegate.window.rootViewController = appDelegate.tabBarController;
            //[appDelegate.window.rootViewController.navigationController pushViewController:(UIViewController*)(appDelegate.mainViewController) animated:YES];
            //[MainViewController release];
        }
    }
}

@end
