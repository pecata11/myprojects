//
//  ContactsViewController.h
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>

#import "GAITrackedViewController.h"

#import "config.h"

#ifdef  __DISPLAY_BANNER__
#import "GADBannerView.h"
#endif /* __DISPLAY_BANNER__ */

@class DataModelManager;
@interface ContactsViewController : GAITrackedViewController <MFMessageComposeViewControllerDelegate,
    UIAlertViewDelegate,
    UISearchBarDelegate>
{

    NSMutableArray *phoneList;
    UITableView *contactsTable;
    UIToolbar *toolBar;
    UIBarButtonItem *selectButton;
    UIBarButtonItem *continueButton;
    BOOL myBoolean;
    NSInteger countOfSended;
    NSMutableArray *markedUsers;
    NSMutableArray *markedMemorize;
    BOOL searchPerformed;
#ifdef __DISPLAY_BANNER__
    GADBannerView *bannerView_;
#endif /* __DISPLAY_BANNER__ */
}

@property(nonatomic,retain) NSMutableArray *phoneList;
@property(nonatomic,retain) NSMutableArray *markedUsers;
@property(nonatomic,retain) NSMutableArray *markedMemorize;

@property(nonatomic,retain) IBOutlet UITableView* contactsTable;
@property(nonatomic,retain) IBOutlet UIToolbar *toolBar;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *selectButton;
@property(nonatomic,retain)IBOutlet UIBarButtonItem *continueButton;
@property(nonatomic) BOOL myBoolean;
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,retain) DataModelManager *dataModel;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

-(id) initWithContacts:(NSMutableArray*)contacts;
-(IBAction)buttonPressed:(id)sender;
-(IBAction)buttonContinuePressed:(id)sender;
@end