//
//  CalendarTableViewCell.m
//  ConfComp
//
//  Created by Petko Yanakiev on 1/8/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import "CalendarTableViewCell.h"
NSString * const CalendarTableViewCellIdentifier = @"AuthorsTableViewCellIdentifier";
//table cell height.
CGFloat const CalendarTableViewCellHeight = 79.0;

@implementation CalendarTableViewCell
@synthesize lblCount= _lblCount;
@synthesize lblStaticText = _lblStaticText;
@synthesize lblPlace = _lblPlace;
@synthesize lblDateStr = _lblDateStr;
@synthesize lblTimeFrame = _lblTimeFrame;
@synthesize lblName=_lblName;
@synthesize  lblSessionNumber=_lblSessionNumber;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
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
    [_lblCount release];
    [_lblStaticText release];
    [_lblPlace release];
    [_lblDateStr release];
    [_lblTimeFrame release];
    [_lblName  release];
    [_lblSessionNumber release];
    [super dealloc];
}
@end
