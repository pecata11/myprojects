//
//  ExhibitorsViewController.h
//  ConfComp
//
//  Created by Antoan Tateosian on 29.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConferenceController;

@interface ExhibitorsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
@private
    NSArray *exhibitors;
    ConferenceController *confController;
  
    BOOL searchPerformed;
}

@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) IBOutlet UISearchBar *searchBar;
- (id) initWithExhibitors:(NSArray *)exhibitors conferenceController:(ConferenceController *)confController;

@end
