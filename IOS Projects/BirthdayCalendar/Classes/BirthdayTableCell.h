//
//  BirthdayTableCell.h
//  BirthdayCalendar
//
//  Created by Dimitar Kamenov on 1/22/13.
//
//

#import <UIKit/UIKit.h>

@interface BirthdayTableCell : UITableViewCell<UITextViewDelegate>

@property (nonatomic, retain) IBOutlet UITextField* birthdayDateField;

@end
