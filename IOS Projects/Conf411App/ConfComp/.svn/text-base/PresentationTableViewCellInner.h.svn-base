//
//  PresentationTableViewCellInner.h
//  ConfComp
//
//  Created by Petko Yanakiev on 1/25/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Presentation;
@class SessionPaper;
@interface PresentationTableViewCellInner : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *lblStaticText;
@property (nonatomic,retain)  IBOutlet UITextView *lblDynamicText;

+ (PresentationTableViewCellInner *) cellWithPresentation:(SessionPaper *)presentation: (UITableView *)tableView:(NSInteger)row:(NSString*)textStatic:(NSString*)textDynamic; 

@end
