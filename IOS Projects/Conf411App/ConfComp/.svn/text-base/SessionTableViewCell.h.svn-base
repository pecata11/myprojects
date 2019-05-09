//
//  SessionTableViewCell.h
//  Conference411
//
//  Created by Petko Yanakiev on 2/2/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConfSession;
extern NSString * const CalendarTableViewCellIdentifier;
extern CGFloat const CalendarTableViewCellHeight;

@interface SessionTableViewCell : UITableViewCell {
    
    UILabel *titleLabel;
    UITextView *titleText;
    UILabel *chairLabel;
    UILabel *chairText;
    UILabel *dateLabel;
    UILabel *timeLabel;
    UILabel *placeLabel;
    UILabel *trackLabel;
    UILabel *trackText;
    UILabel *sessDescripionLabel;
    UITextView *sessDescriptionText;    
}
@property(nonatomic,retain) IBOutlet UILabel *titleLabel;
@property(nonatomic,retain) IBOutlet UITextView *titleText;
@property(nonatomic,retain) IBOutlet UILabel *chairLabel;
@property(nonatomic,retain) IBOutlet UILabel *chairText;
@property(nonatomic,retain) IBOutlet UILabel *dateLabel;
@property(nonatomic,retain) IBOutlet UILabel*timeLabel;
@property(nonatomic,retain) IBOutlet UILabel *placeLabel;
@property(nonatomic,retain) IBOutlet UILabel *trackLabel;
@property(nonatomic,retain) IBOutlet UILabel *trackText;
@property(nonatomic,retain) IBOutlet UILabel *sessDescripionLabel;
@property(nonatomic,retain) IBOutlet UITextView *sessDescriptionText; 
+ (SessionTableViewCell *) cellWithSession:(ConfSession *)session table: (UITableView *)tableView:(NSInteger)row:(NSString*)trackLabelName:(NSString*)moderatorLabelName;
@end
