//
//  ConferenceMapViewController.h
//  ConfComp
//
//  Created by Antoan Tateosian on 29.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Place;
@class ConferenceController;
@interface ConferenceMapViewController : UIViewController <UIScrollViewDelegate> {
@private
    UIImage *mapImage;
    UIImageView *imgView;
    ConferenceController* confController;
}

- (id) initWithMapImage:(UIImage *)mapImage:(ConferenceController*)conferenceController;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UILabel *lblPlaceName;
@property (nonatomic, retain) IBOutlet UIView *topView;

- (void) markPlace:(Place *)place;

@end
