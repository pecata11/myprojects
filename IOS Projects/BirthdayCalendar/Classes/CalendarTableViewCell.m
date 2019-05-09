//
//  CalendarTableViewCell.m
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarTableViewCell.h"

#import "Utils.h"

NSString * const CalendarTableViewCellIdentifier = @"CalendarCellIdentifer";
#define CAL_CELL_IDENTIFIER @"CalendarCellIdentifer"


@implementation CalendarTableViewCell

@synthesize userNameLabel=_userNameLabel;
@synthesize userBirthdayDateLabel=_userBirthdayDateLabel;
@synthesize userPhotoLabel=_userPhotoLabel;
@synthesize activity;
@synthesize sendButton=_sendButton;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
- (BOOL) isOpaque {
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



- (void) dealloc
{
    [_userNameLabel release];
    [_userBirthdayDateLabel release];
    [_userPhotoLabel release];
    [_sendButton release];
    [activity release];
    
    [super dealloc];
}

@end
