//
//  ConferenceGridViewController.h
//  ConfComp
//
//  Created by Antoan Tateosian on 03.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConfDay;
@class ConferenceController;

@interface ConferenceGridViewController : UIViewController <UIScrollViewDelegate> {
@private
    ConferenceController *confController;
    NSArray *days;
    UISegmentedControl *daysControl;
   // NSMutableDictionary *hourCoordinateMap;
    //UIBarButtonItem *btnMark;
}
@property (nonatomic,retain)  IBOutlet UIScrollView *gridView;
@property (nonatomic,retain)  IBOutlet UIScrollView *labelView;
@property (nonatomic,retain)  IBOutlet UISegmentedControl *daysControl;
@property (nonatomic,retain)  NSMutableDictionary *hourCoordinateMap;
@property (nonatomic, retain) UIBarButtonItem *btnMark;
- (id) initWithDay:(ConfDay *)day conferenceController:(ConferenceController *)conferenceController:(NSArray*)daysSess;

@end
