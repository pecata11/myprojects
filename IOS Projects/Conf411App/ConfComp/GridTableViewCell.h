//
//  GridTableViewCell.h
//  ConfComp
//
//  Created by Antoan Tateosian on 04.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const GridTableViewCellIdentifier;
extern CGFloat const GridTableViewCellHeight;

@interface GridTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UILabel *lblAuthor;
@property (nonatomic, retain) IBOutlet UILabel *lblInstitution;

@end
