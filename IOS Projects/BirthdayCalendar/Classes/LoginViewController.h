//
//  LoginViewController.h
//  BirthdayCalendar
//
//  Created by Dimitar Kamenov on 2/1/13.
//
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UIImageView* headerImageView;
@property (nonatomic, retain) IBOutlet UITextField* emailTextView;
@property (nonatomic, retain) IBOutlet UITextField* pinTextView;

- (IBAction)loginButtonClicked:(UIButton*)sender;
- (IBAction)forgotPinButtonClicked:(UIButton*)sender;

- (IBAction)closeKeyboard:(UITextField*)sender;
- (IBAction)closeAllKeyboards:(UIControl*)sender;

@end
