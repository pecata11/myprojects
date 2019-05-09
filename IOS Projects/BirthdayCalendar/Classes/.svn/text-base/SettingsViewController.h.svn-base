//
//  SettingsViewController.h
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.



#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import "GAITrackedViewController.h"

#import "config.h"

#ifdef __DISPLAY_BANNER__
#import "GADBannerView.h"
#endif /* __DISPLAY_BANNER__ */

@class DataModelManager;
@class Birthday;
@interface SettingsViewController : GAITrackedViewController<SKProductsRequestDelegate,SKPaymentTransactionObserver> {
    
    UITableView *settingsTable;
    UIView *viewReminders;
    UIView *viewTimeOfDay;
    UIView *viewDaysBefore;
    UIView *viewRemindDayOf;
    UISwitch *enabledSwitch;
    UISwitch *remindDayOfSwitch;
    UISlider *timeOfDaySlider;
    UISlider *daysBeforeSlider;
    UILabel *timeOfDayLabel;
    UILabel *daysBeforeLabel;
    NSManagedObjectContext *managedObjectContext;
    DataModelManager *dataModel;
#ifdef __DISPLAY_BANNER__
    GADBannerView *bannerView_;
#endif /* __DISPLAY_BANNER__ */
}
@property(nonatomic,retain) IBOutlet UITableView *settingsTable;

@property(nonatomic,retain) IBOutlet UIView *viewRemindersAccountSettings;
@property(nonatomic,retain) IBOutlet UIView *viewReminders;
@property(nonatomic,retain) IBOutlet UIView *viewTimeOfDayAccountSettings;
@property(nonatomic,retain) IBOutlet UIView *viewTimeOfDay;
@property(nonatomic,retain) IBOutlet UIView *viewDaysBeforeAccountSettings;
@property(nonatomic,retain) IBOutlet UIView *viewDaysBefore;
@property(nonatomic,retain) IBOutlet UIView *viewRemindDayOfAccountSettings;
@property(nonatomic,retain) IBOutlet UIView *viewRemindDayOf;

@property(nonatomic,retain) IBOutlet UISwitch *enabledSwitch;
@property(nonatomic,retain) IBOutlet UISwitch *remindDayOfSwitch;
@property(nonatomic,retain) IBOutlet UISlider *timeOfDaySlider;
@property(nonatomic,retain) IBOutlet UISlider *daysBeforeSlider;
@property(nonatomic,retain) IBOutlet UILabel *timeOfDayLabel;
@property(nonatomic,retain) IBOutlet UILabel *daysBeforeLabel;
@property(nonatomic,retain) DataModelManager *dataModel;
@property(nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,retain) Birthday *birthday;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollViewAccountSettings;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollViewAccountCreate;

- (IBAction) timeOfDaySliderVC:(UISlider *)sender;
- (IBAction) timeOfDaySliderMove:(UISlider *)sender;
- (IBAction) daysBeforeSliderVC:(UISlider *)sender;
- (IBAction) daysBeforeSliderMove:(UISlider *)sender;
- (IBAction) reminderSwitch:(UISwitch *)sender;
- (IBAction) remindDayOfSwitch:(UISwitch *)sender;
- (IBAction) resetCalendar:(UIButton *)sender;

- (IBAction) buttonLogoutClicked:(UIButton*)sender;
- (IBAction) buttonSendConfirmMailClicked:(UIButton*)sender;
- (IBAction) buttonUpgradeClicked:(UIButton*)sender;
- (IBAction) buttonRestorePurchasesClicked:(UIButton*)sender;
- (IBAction) buttonCreateAccountClicked:(UIButton*)sender;

@end
