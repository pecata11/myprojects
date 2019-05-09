//
//  PostToWallSMSViewController.h
//  BirthdayCalendar
//
//  Created by Dimitar Kamenov on 2/11/13.
//
//

#import <UIKit/UIKit.h>

@class PostToWallSMSViewController;
typedef void(^SelectDoneHandler)(PostToWallSMSViewController* postToWallSMSViewController, int buttonIndex);

@interface PostToWallSMSViewController : UIViewController {
    SelectDoneHandler doneHandler;
}

- (void) setHandler:(SelectDoneHandler) dh;
- (IBAction) closeDialogWithButton:(id)sender;

@property (nonatomic, retain) IBOutlet UIView* alertView;

@end
