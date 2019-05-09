//
//  ManageBirthday.h
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAITrackedViewController.h"

#import "config.h"

#ifdef __DISPLAY_BANNER__
#import "GADBannerView.h"
#endif /* __DISPLAY_BANNER__ */

@class DataModelManager;
@class UserData;

@interface ManageBirthdayViewController : GAITrackedViewController <UITableViewDelegate,UIAlertViewDelegate,UISearchBarDelegate>{
    UITableView *manageTableView;
    NSManagedObjectContext *managedObjectContext;
    NSMutableArray *friendsList;
    DataModelManager *dataModel;
   // UserData *uData;
    NSInteger rowIndex;
    BOOL searchPerformed;
    int edit;
#ifdef __DISPLAY_BANNER__
    GADBannerView *bannerView_;
#endif /* __DISPLAY_BANNER__ */
}

@property(nonatomic,retain) IBOutlet UITableView *manageTableView;
@property(nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,retain) NSMutableArray *friendsList;
@property(nonatomic,retain) DataModelManager *dataModel;
@property(nonatomic) int edit;
//@property(nonatomic,retain) UserData *uData;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@end
