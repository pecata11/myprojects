//
//  ExhibitorsTableViewCell.h
//  Conference411
//
//  Created by Petko Yanakiev on 2/6/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const ExhibitorsTableViewCellIdentifier;
extern CGFloat const ExhibitorsTableViewCellHeight;

@class Exhibitor;

@interface ExhibitorsTableViewCell : UITableViewCell{
    UILabel *vendorLabelCount;
    UILabel *vendorCount;
    UILabel *vendorLabelTitle;
    UILabel *vendorTitle;
    UIImageView *vendorImage;
    
}

@property(nonatomic,retain)IBOutlet UILabel *vendorLabelCount;
@property(nonatomic,retain)IBOutlet UILabel *vendorCount;
@property(nonatomic,retain)IBOutlet UILabel *vendorLabelTitle;
@property(nonatomic,retain)IBOutlet UILabel *vendorTitle;
@property(nonatomic,retain)IBOutlet UIImageView *vendorImage;
+ (ExhibitorsTableViewCell *) cellWithExhibitor:(Exhibitor*)expo table: (UITableView *)tableView:(NSInteger)row;
@end
