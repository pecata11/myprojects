//
//  InstituteViewController.h
//  ConfComp
//
//  Created by Antoan Tateosian on 30.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Institution;
@class ConferenceController;

@interface InstituteViewController : UITableViewController {
@private
    Institution *institute;
    ConferenceController *confController;
}

- (id) initWithInstitute:(Institution *)institute conferenceController:(ConferenceController *)confController;

@end
