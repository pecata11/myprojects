//
//  TopicsViewController.h
//  ConfComp
//
//  Created by Antoan Tateosian on 05.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConferenceController;

//Model of basic conference topic view controller logic.
@interface TopicsViewController : UITableViewController {
@private
    NSArray *topics; 
    ConferenceController *confController;
}

- (id) initWithTopics:(NSArray *)topics conferenceController:(ConferenceController *)conferenceController;

@end
