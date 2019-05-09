//
//  GridTableViewCell.m
//  ConfComp
//
//  Created by Antoan Tateosian on 04.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "GridTableViewCell.h"

NSString * const GridTableViewCellIdentifier = @"GridTableViewCellIdentifier";
CGFloat const GridTableViewCellHeight = 77.0;

@implementation GridTableViewCell

@synthesize lblName = _lblName;
@synthesize lblAuthor = _lblAuthor;
@synthesize lblInstitution = _lblInstitution;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) dealloc
{
    [_lblName release];
    [_lblAuthor release];
    [_lblInstitution release];
    
    [super dealloc];
}

@end
