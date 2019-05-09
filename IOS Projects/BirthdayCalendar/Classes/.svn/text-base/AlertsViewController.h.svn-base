//
//  AlertsViewController.h
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import "GAITrackedViewController.h"

#import "config.h"

#ifdef __DISPLAY_BANNER__
#import "GADBannerView.h"
#endif /* __DISPLAY_BANNER__ */


@interface AlertsViewController : GAITrackedViewController<SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    
    UITableView *alertsTable;
    NSArray *alerts;
#ifdef __DISPLAY_BANNER__
    GADBannerView *bannerView_;
#endif /* __DISPLAY_BANNER__ */
}

@property(nonatomic,retain) IBOutlet UITableView *alertsTable;
@property(nonatomic,retain) NSArray *alerts;
@property (assign, nonatomic) NSInteger sendLoveInteger;
@property (assign, nonatomic) BOOL displayPopup;

@end
