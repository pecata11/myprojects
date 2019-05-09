//
//  ConferenceInfoTableViewCell.m
//  ConfComp
//
//  Created by Petko Yanakiev on 1/12/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import "ConferenceInfoTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ExtendedServerShortConferenceInfo.h"

NSString * const ConferenceInfoTableViewCellIdentifier = @"ConferenceInfoCellIdentifier";

const CGFloat ConferenceInfoTableViewCellHeight = 165.0;

@implementation ConferenceInfoTableViewCell

@synthesize txtDescription=_txtDescription;
@synthesize infolbl=_infolbl;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) loadServerInfoConferenceInfo:(ExtendedServerShortConferenceInfo *)conferenceInfo
{
    self.txtDescription.text = conferenceInfo.confDescription;
    self.infolbl.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
      
    CALayer * l = [self layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:40.0];
   }

- (void) dealloc
{
    [_infolbl release];
    [_txtDescription release];
    [super dealloc];
}
@end
