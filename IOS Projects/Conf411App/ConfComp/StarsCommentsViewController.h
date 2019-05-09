//
//  StarsCommentsViewController.h
//  ConfComp
//
//  Created by Antoan Tateosian on 05.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConferenceController;

@interface StarsCommentsViewController : UITableViewController {
@private
    
    ConferenceController *confController;
    NSArray *origPresentations;
}

- (id) initWithPresentations:(NSArray *)presentations conferenceController:(ConferenceController *)conferenceController;

@end
