//
//  KeepBirthPrivateCell.h
//  BirthdayCalendar
//
//  Created by Dimitar Kamenov on 1/22/13.
//
//

#import <UIKit/UIKit.h>

#import "UICheckbox.h"

@interface KeepBirthPrivateCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UICheckbox* keepPrivateCheckbox;

- (IBAction)checkClicked:(UICheckbox*)sender;

@end
