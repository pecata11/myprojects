//
//  Utils.h
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "UserData.h"

@class Birthday;

@interface Utils : NSObject
+(NSString*)formatFaceBookDateString:(NSString *)birthDay;
+(NSString*)formatDateStringWithMonthAndDay:(NSString*) stringDate;
+(NSString*)formatDateStringWithYearMonthDay:(NSString*) stringDate;
+(NSString*)changeYearToCurrent:(NSString*)currentDate;
+(NSString*)formatDateForTableCell:(NSDate*)date;
+(int)getDaysBetween2Dates :(NSDate*)date :(NSDate*)currentDate;
+(NSMutableArray*)filterSameDayCelebritiesBirthdays:(NSDate*) thisDate;

+ (NSMutableString *)constructFriendWishMessage:(NSString*)friendName;
+(void)calculateActualTimeZone;
+(void)messageDisplay :(NSString*)title :(NSString*)message :(int)alertTag;
+ (NSString *)returnCurrentYear;

+(NSString*)changeYearToPassed :(NSString*)currentDate :(NSString*)passedYear;
//Notification methods.
+ (int)getUserNumberWithTodayBirthday :(NSMutableArray *)friendsRecords;
+ (int)getUserNumberDaysAhead :(NSInteger)daysAhead :(NSMutableArray *)friendsRecords;
+ (void)setLocalNotification :(NSInteger)fireHour :(BOOL)remindDayOf :(NSInteger)daysAhead;
+ (NSString *)mapTimeValues :(int)sliderValue;
+ (void)resizeImage:(UIImage **)image_p;
+ (void)sortBirthdays:(NSMutableArray *)birthdays;

+ (NSString *)trimWhitespace:(NSString*) str;

enum {
    UIDeviceResolution_Unknown          = 0,
    UIDeviceResolution_iPhoneStandard   = 1,    // iPhone 1,3,3GS Standard Display  (320x480px)
    UIDeviceResolution_iPhoneRetina35   = 2,    // iPhone 4,4S Retina Display 3.5"  (640x960px)
    UIDeviceResolution_iPhoneRetina4    = 3,    // iPhone 5 Retina Display 4"       (640x1136px)
    UIDeviceResolution_iPadStandard     = 4,    // iPad 1,2 Standard Display        (1024x768px)
    UIDeviceResolution_iPadRetina       = 5     // iPad 3 Retina Display            (2048x1536px)
}; typedef NSUInteger UIDeviceResolution;

+ (UIDeviceResolution)resolution;
+ (float)retina4correction;
+ (float)nonRetina4correction;
+ (BOOL)inAppPurchasesAllowed;
+ (void) requestProductData:(UIViewController<SKProductsRequestDelegate>*)delegate;

+ (NSNumber*) createAccount:(NSString*)account_email
           account_birthday:(NSString*)account_birthday
   account_birthday_private:(BOOL)account_birthday_private
             account_gender:(NSString*)account_gender
                account_pin:(NSString*)account_pin
           device_apn_token:(NSString*)device_apn_token;

+ (NSString*) loginAccount:(NSString*)account_email
               account_pin:(NSString*)account_pin;

+ (BOOL) logoutAccount:(NSString*)session_id;
+ (BOOL) resetAccount:(NSString*)account_email;
+ (BOOL) resendEmail:(NSString*)account_email;

+ (void) setSessionID:(NSString*)sessionID;
+ (NSString*) getSessionID;

+ (NSArray*) spinnerImages;

@end
