//
//  ConferenceListViewController.h
//  ConfComp
//
//  Created by Antoan Tateosian on 03.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConferenceController;
@class ConfDay;
//@class ConfTimeFrame;

@interface ConferenceListViewController : UIViewController {
@private
    ConfDay *day;
    NSArray *days;
    UITableView *tableViewCalendar;
    UISegmentedControl *daysControl;
    NSMutableArray *sessArray;
    ConferenceController *confController;
    BOOL isChecked;
}
@property(nonatomic,retain) IBOutlet UITableView *tableViewCalendar;
@property(nonatomic,retain) IBOutlet UISegmentedControl *daysControl;
@property (nonatomic) BOOL isChecked;
- (id) initWithDay:(ConfDay *)day conferenceController:(ConferenceController *)confController:(NSArray*) daysSess;
-(NSInteger) combineSessions:(NSArray*) daySessions;
- (void) pickOne:(id)sender;
-(NSArray*)fillSegmentedControl:(NSArray*) origDays;
- (NSMutableArray*)filterDays:(NSArray *)sessDays:(NSArray *)daysArray;

@end
