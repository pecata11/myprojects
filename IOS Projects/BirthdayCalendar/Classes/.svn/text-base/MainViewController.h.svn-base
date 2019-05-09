//
//  MainViewController.h
//  BirthdayCalendar
//
//  Created by ; Yanakiev on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import <Facebook.h>

#import "GAITrackedViewController.h"

#import "config.h"

#ifdef __DISPLAY_BANNER__
#import "GADBannerView.h"
#endif /* __DISPLAY_BANNER__ */

@class FacebookManager;
@class DataModelManager;

@interface MainViewController : GAITrackedViewController <FBRequestDelegate,FBDialogDelegate,MFMailComposeViewControllerDelegate> {
    UITableView *tableViewMain;
    NSManagedObjectContext *managedObjectContext;
    NSMutableArray *friendsList;
    NSMutableArray *markedMemorize;
    int tapCount;
    NSMutableDictionary *mapOfUsers;
#ifdef __DISPLAY_BANNER__
    GADBannerView *bannerView_;
#endif /* __DISPLAY_BANNER__ */
}

@property (nonatomic,retain) IBOutlet UITableView *tableViewMain;
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,retain) DataModelManager *dataModel;
@property(nonatomic,retain) NSMutableArray *markedMemorize;
@property(nonatomic,retain) NSMutableDictionary* mapOfUsers;
@property (nonatomic,retain) NSString* activeUser;

-(void)getUserFriends;
- (void)saveFriendsToDataModel:(id)result;
- (void)deleteUserIfPresentInModel:(id)result;


@end