//
//  ConferenceTableViewCell.h
//  ConfComp
//
//  Created by Antoan Tateosian on 17.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExtendedServerShortConferenceInfo;

extern NSString * const ConferenceTableViewCellIdentifier;

extern const CGFloat ConferenceTableViewCellHeight;
extern const CGFloat ConferenceTableViewCellHeightIPad;
@interface ConferenceTableViewCell : UITableViewCell

- (void) loadServerConferenceInfo:(ExtendedServerShortConferenceInfo *)conferenceInfo;

@property (nonatomic, retain) IBOutlet UILabel *lblConferenceName;
@property (nonatomic, retain) IBOutlet UILabel *lblConferenceDate;
@property (nonatomic, retain) IBOutlet UILabel *lblConferenceVenue;
@property (nonatomic, retain) IBOutlet UIImageView *imgViewConferenceLogo;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *actLoadingImage;

@end
