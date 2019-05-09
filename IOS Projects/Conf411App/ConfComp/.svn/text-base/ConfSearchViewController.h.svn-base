//
//  ConfSearchViewController.h
//  ConfComp
//
//  Created by Antoan Tateosian on 02.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMySearchBar.h"

@class ConferenceController;

//Module for a search for a conference.
@interface ConfSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
@private
    ConferenceController *confController;
    BOOL searchPerformed;

}

- (id) initWithConferenceController:(ConferenceController *)conferenceController;

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *tblView;

@end
