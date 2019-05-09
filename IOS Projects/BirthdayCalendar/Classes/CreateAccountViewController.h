//
//  CreateAccountViewController.h
//  BirthdayCalendar
//
//  Created by Dimitar Kamenov on 1/21/13.
//
//

#import <UIKit/UIKit.h>

#import "config.h"

#ifdef __DISPLAY_BANNER__
#import <GADBannerView.h>
#endif /* __DISPLAY_BANNER__ */

#import "EmailTableCell.h"
#import "BirthdayTableCell.h"
#import "KeepBirthPrivateCell.h"
#import "GenderTableViewCell.h"
#import "PinTableViewCell.h"

@interface CreateAccountViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate,UITextViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource> {
#ifdef __DISPLAY_BANNER__
    GADBannerView *bannerView_;
#endif /* __DISPLAY_BANNER__ */
    UIActionSheet *actionSheet;
}

@property (nonatomic, retain) IBOutlet UIImageView* headerImageView;
@property (nonatomic, retain) IBOutlet UITableView* menuTableView;
@property (nonatomic, retain) IBOutlet UILabel* labelTermsOfService;
@property (nonatomic, retain) IBOutlet UILabel* labelPrivacyPolicy;
@property (nonatomic, retain) UITapGestureRecognizer* tapGestureRecognizerTerms;
@property (nonatomic, retain) UITapGestureRecognizer* tapGestureRecognizerPrivacy;

@property (nonatomic, retain) EmailTableCell* emailTableCell;
@property (nonatomic, retain) BirthdayTableCell* birthdayTableCell;
@property (nonatomic, retain) KeepBirthPrivateCell* keepBirthPrivateCell;
@property (nonatomic, retain) GenderTableViewCell* genderTableViewCell;
@property (nonatomic, retain) PinTableViewCell* pinTableViewCell;

@property (nonatomic, retain) NSArray* arrayNo;


- (IBAction)skipClicked:(UIButton*)skipButton;
- (IBAction)buttonCreateClicked:(UIButton*)buttonCreate;
- (IBAction)buttonLoginClicked:(UIButton*)buttonLogin;

- (IBAction)closeKeyboard:(UITextField*)sender;
- (IBAction)closeAllKeyboards:(UIControl*)sender;
- (IBAction)pinCodeValueChanged:(UITextField*)sender;

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField;

@end
