//
//  CalendarBirthdaysViewController.h
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Facebook.h>
#import <MessageUI/MFMessageComposeViewController.h>

#import "GAITrackedViewController.h"

#import "config.h"

#ifdef __DISPLAY_BANNER__
#import "GADBannerView.h"
#endif /* __DISPLAY_BANNER__ */

@class  DataModelManager;
@class  Birthday;


@interface CalendarBirthdaysViewController : GAITrackedViewController <FBDialogDelegate,FBRequestDelegate,UIAlertViewDelegate,UITabBarDelegate,MFMessageComposeViewControllerDelegate>{
    
    UITableView *birthdaysTableView;
    NSMutableArray *friendsList;
    NSManagedObjectContext *managedObjectContext;
    DataModelManager *dataModel;
    NSInteger rowIndex;
    UILabel *titleLabel;
    int year;
    int month;
    int day;
#ifdef __DISPLAY_BANNER__
    GADBannerView *bannerView_;
#endif /* __DISPLAY_BANNER__ */
}
@property(nonatomic,retain) IBOutlet UITableView *birthdaysTableView;
@property(nonatomic,retain) NSMutableArray *friendsList;
@property(nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,retain) DataModelManager *dataModel;
@property(nonatomic,retain) UILabel *titleLabel;



- (id) initWithUserData: (int)year :(int)month :(int)day :(NSString*)navBarLabelText;
- (void)publishStream:(Birthday*) birthday;
- (void)sendSMS:(NSString*)name;
- (IBAction) handleButton:(id)sender;

@end
