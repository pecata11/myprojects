//
//  SponsorsViewController.h
//  ConfComp
//
//  Created by Antoan Tateosian on 05.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConferenceController;
//Model of Sponsors View controller class.
@interface SponsorsViewController : UITableViewController {
@private
    NSArray *sponsors;
    ConferenceController *confController;
}

- (id) initWithSponsors:(NSArray *)sponsors conferenceController:(ConferenceController *)conferenceController;

@end
