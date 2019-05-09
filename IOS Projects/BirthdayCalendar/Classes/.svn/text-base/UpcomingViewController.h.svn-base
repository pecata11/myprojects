//
//  UpcomingViewController.h
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import <MessageUI/MFMessageComposeViewController.h>

#import "GAITrackedViewController.h"

#import "config.h"

#ifdef __DISPLAY_BANNER__
#import "GADBannerView.h"
#endif /* __DISPLAY_BANNER__ */

@class  DataModelManager;
@class  Birthday;

@interface UpcomingViewController : GAITrackedViewController <FBDialogDelegate,FBRequestDelegate,UIAlertViewDelegate,UITabBarDelegate,MFMessageComposeViewControllerDelegate>{
    
    UITableView *upcomingTableView;
    NSMutableArray *friendsList;
    NSManagedObjectContext *managedObjectContext;
    DataModelManager *dataModel;
    NSInteger rowIndex;
    Birthday *birthday;
#ifdef __DISPLAY_BANNER__
    GADBannerView *bannerView_;
#endif /* __DISPLAY_BANNER__ */
}
@property(nonatomic,retain) IBOutlet UITableView *upcomingTableView;
@property(nonatomic,retain) NSMutableArray *friendsList;
@property(nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,retain) DataModelManager *dataModel;
@property(nonatomic,retain) Birthday *birthday;

- (void)publishStream;
- (void)sendSMS:(NSString*)name;
- (IBAction)sendClicked:(id)sender;

@end
