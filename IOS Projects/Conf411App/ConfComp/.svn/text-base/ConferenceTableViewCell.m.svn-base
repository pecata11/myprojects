//
//  ConferenceTableViewCell.m
//  ConfComp
//
//  Created by Antoan Tateosian on 17.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "ConferenceTableViewCell.h"

#import "ServerShortConferenceInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "UACellBackgroundView.h"
#import "ExtendedServerShortConferenceInfo.h"
NSString * const ConferenceTableViewCellIdentifier = @"ConferenceCellIdentifier";

const CGFloat ConferenceTableViewCellHeight = 65.0;
const CGFloat ConferenceTableViewCellHeightIPad=75.0;

@implementation ConferenceTableViewCell

@synthesize lblConferenceName = _lblConferenceName;
@synthesize lblConferenceDate = _lblConferenceDate;
@synthesize lblConferenceVenue = _lblConferenceVenue;
@synthesize imgViewConferenceLogo = _imgViewConferenceLogo;
@synthesize actLoadingImage = _actLoadingImage;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.backgroundColor=[UIColor whiteColor];
        
    }
    return self;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) loadServerConferenceInfo:(ExtendedServerShortConferenceInfo *)conferenceInfo
{
    self.lblConferenceName.text = conferenceInfo.name;
    self.lblConferenceName.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    self.lblConferenceDate.text = conferenceInfo.date;
    self.lblConferenceVenue.text = conferenceInfo.venue;
    NSData *imData=[[NSData alloc] initWithContentsOfURL:conferenceInfo.smallImageUrl];
    UIImage *image=[[UIImage alloc]initWithData:imData];
    self.imgViewConferenceLogo.image = image; 
    // TODO: show activity indicator here if image is nil
    [imData release];
    [image release];
    CALayer * l = [self.imgViewConferenceLogo layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
   
    /*if (self.imgViewConferenceLogo.image == nil)
    {
        [self.actLoadingImage startAnimating];
    }
    else
    {
        [self.actLoadingImage stopAnimating];
    }*/
}

- (void) dealloc
{
    [_lblConferenceName release];
    [_lblConferenceDate release];
    [_lblConferenceVenue release];
    [_imgViewConferenceLogo release];
    [_actLoadingImage release];
    
    [super dealloc];
}

@end
