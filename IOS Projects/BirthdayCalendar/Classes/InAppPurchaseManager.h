//
//  InAppPurchaseManager.h
//  BirthdayCalendar
//
//  Created by Dimitar Kamenov on 2/6/13.
//
//

#import <Foundation/Foundation.h>

#import "Utils.h"

@interface InAppPurchaseManager : NSObject

+ (InAppPurchaseManager*) sharedManager;

- (BOOL) inAppPurchasesAllowed;
- (void) requestProductData:(UIViewController<SKProductsRequestDelegate>*)delegate;

@end
