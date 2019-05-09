//
//  InAppPurchaseManager.m
//  BirthdayCalendar
//
//  Created by Dimitar Kamenov on 2/6/13.
//
//

#import "InAppPurchaseManager.h"

@implementation InAppPurchaseManager

#pragma mark InAppPurchaseManager Singleton

+ (InAppPurchaseManager*) sharedManager {
    static InAppPurchaseManager *sharedInAppManager = nil;
    
    @synchronized(self) {
        if (sharedInAppManager == nil) {
            sharedInAppManager = [[self alloc] init];
        }
    }
    return sharedInAppManager;
}

#pragma mark User Functions

- (BOOL) inAppPurchasesAllowed;
{
    return [Utils inAppPurchasesAllowed];
}

- (void) requestProductData:(UIViewController<SKProductsRequestDelegate>*)delegate
{
    if ([self inAppPurchasesAllowed]) {
        [Utils requestProductData:delegate];
    }
}

@end
