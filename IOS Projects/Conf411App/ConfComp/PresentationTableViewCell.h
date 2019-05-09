//
//  PresentationTableViewCell.h
//  ConfComp
//
//  Created by Antoan Tateosian on 30.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UACellBackgroundView.h"
//#import "UACellBackgroundView.h"
extern NSString * const PresentationTableViewCellIdentifier;
extern CGFloat const PresentationTableViewCellHeight;
@class Presentation;
@class SessionPaper;


@interface PresentationTableViewCell : UITableViewCell


@property (nonatomic, retain) IBOutlet UILabel *lblDate;
@property (nonatomic,retain)  IBOutlet UILabel *lblDateStr;
@property (nonatomic, retain) IBOutlet UILabel *lblPresentationName;
@property (nonatomic, retain) IBOutlet UILabel *lblFirstAuthorName;
@property (nonatomic, retain) IBOutlet UILabel *lblInstitutionName;

@property (nonatomic, retain) IBOutlet UILabel *lblCountPres;
@property (nonatomic, retain) IBOutlet UITextView *lblStaticText;

+ (PresentationTableViewCell *) cellWithPresentation:(SessionPaper *)presentation table:(UITableView *)tableView:(NSInteger)row;
+ (CGFloat) heightWithPresentation:(SessionPaper *)presentation;

@end
