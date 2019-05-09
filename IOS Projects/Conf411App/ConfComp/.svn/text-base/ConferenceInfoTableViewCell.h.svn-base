//
//  ConferenceInfoTableViewCell.h
//  ConfComp
//
//  Created by Petko Yanakiev on 1/12/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServerShortConferenceInfo;

extern NSString * const ConferenceInfoTableViewCellIdentifier;
extern const CGFloat ConferenceInfoTableViewCellHeight;

@interface ConferenceInfoTableViewCell : UITableViewCell{

    UILabel *infolbl;
    UITextView *txtDescription;
}
@property(nonatomic,retain)IBOutlet  UILabel *infolbl;
@property(nonatomic,retain)IBOutlet  UITextView *txtDescription;
- (void) loadServerInfoConferenceInfo:(ServerShortConferenceInfo *)conferenceInfo;
@end
