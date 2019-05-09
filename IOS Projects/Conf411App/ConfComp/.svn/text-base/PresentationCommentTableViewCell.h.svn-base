//
//  PresentationCommentTableViewCell.h
//  ConfComp
//
//  Created by Antoan Tateosian on 05.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Presentation;

@interface PresentationCommentTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *lblPresName;
@property (nonatomic, retain) IBOutlet UILabel *lblAuthorName;
@property (nonatomic, retain) IBOutlet UILabel *lblInstitution;
@property (nonatomic, retain) IBOutlet UILabel *lblComment;

+ (PresentationCommentTableViewCell *) cellWithPresentation:(Presentation *)presentation 
                                                      table:(UITableView *)tableView;
+ (CGFloat) heightWithPresentation:(Presentation *)presentation;

@end
