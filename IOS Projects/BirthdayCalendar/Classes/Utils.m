//
//  Utils.m
//  BirthdayCalendar
//  Created by Petko Yanakiev on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import "Birthday.h"
#import <AddressBook/AddressBook.h>
#import "ContactInfo.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "NSDate+Helper.h"
#import <StoreKit/StoreKit.h>

#import "config.h"
#import "ASIFormDataRequest.h"

#define fullDateLength 10  //we have mm/dd/yyyy date format

const int DAY_IN_SECONDS = 24*60*60; // 24h in seconds

@implementation Utils

+(void)messageDisplay :(NSString*)title :(NSString*)message :(int)alertTag
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title
                                                  message:message 
                                                 delegate:self 
                                        cancelButtonTitle:nil 
                                        otherButtonTitles:@"Ok", nil];
    [alert show];
    alert.tag=alertTag;
    [alert release];
}

+(NSString*) formatDateStringWithYearMonthDay:(NSString*) stringDate{
    
    NSString* stringDatee=[@"2000 " stringByAppendingString:stringDate];
    NSDate *date = [NSDate dateFromString:stringDatee withFormat:@"yyyy MMMM d"];
    NSString *dateText = [NSDate stringFromDate:date withFormat:@"yyyy-MM-dd"];
    return dateText;
}

+ (NSString *)returnCurrentYear {
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents* dateComponents = [gregorian components:unitFlags fromDate:[NSDate date]];
    NSInteger inth=[dateComponents year];

    NSString *stringYear = [NSString stringWithFormat:@"%d", inth];
    [gregorian release];
    return stringYear;
}

+(NSString*)changeYearToPassed :(NSString*)currentDate :(NSString*)passedYear{
    if (currentDate == nil) return nil;
    
    NSArray* stringComponents = [currentDate componentsSeparatedByString:@"-"];
    
    NSMutableString *newDate=[[[NSMutableString alloc ]init] autorelease];
    [newDate appendString: passedYear];
    [newDate appendString:@"-"];
    //[newDate appendString:[currentDate substringFromIndex:[currentDate length] - 5]];
    [newDate appendString:[stringComponents objectAtIndex:1]];
    [newDate appendString:@"-"];
    [newDate appendString:[stringComponents objectAtIndex:2]];
    
    return newDate;
}

+(NSString*)changeYearToCurrent:(NSString*)currentDate{
    if (currentDate == nil) return nil;
    
    NSArray* stringComponents = [currentDate componentsSeparatedByString:@"-"];
    NSString *stringYear;
    stringYear = [self returnCurrentYear];
    
    NSMutableString *newDate=[[[NSMutableString alloc ]init]autorelease];
    [newDate appendString: stringYear];
    [newDate appendString:@"-"];
    [newDate appendString:[stringComponents objectAtIndex:1]];
    [newDate appendString:@"-"];
     [newDate appendString:[stringComponents objectAtIndex:2]];
    return newDate;
  }

+(NSString*) formatDateStringWithMonthAndDay:(NSString*) stringDate{
    
    NSDate *date = [NSDate dateFromString:stringDate withFormat:@"yyyy-MM-dd"];
    NSString *dateText = [NSDate stringFromDate:date withFormat:@"MMMM d"];
    return dateText;
}

+ (NSString*)formatFaceBookDateString:(NSString *)birthday
{
    NSInteger dateLength = [birthday length];
    NSDate *date;
    if(dateLength == fullDateLength)
    {
       date = [NSDate dateFromString:birthday
                          withFormat:@"MM/dd/yyyy"];
    }
    else 
    {
       date = [NSDate dateFromString:birthday
                          withFormat:@"MM/dd"];
    }
    NSString *dateText = [NSDate stringFromDate:date
                                 withFormat:@"yyyy-MM-dd"];
    return dateText;
}


+(void)calculateActualTimeZone{
    //NSDate* sourceDate = [NSDate date];
    //NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    //NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    //NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    //NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    //NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    //NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] autorelease];
    //NSLog(@"The actual time is:%@",destinationDate);

}

+(int) getDaysBetween2Dates :(NSDate*)date :(NSDate *)currentDate
{
    long long ti = [date timeIntervalSinceDate:currentDate];
    int offset = ti % DAY_IN_SECONDS;
    
    if (offset >= 0) {
        offset = offset - DAY_IN_SECONDS;
    }
    
    int days = (ti - offset) / DAY_IN_SECONDS;
    
    return days;
}

+(NSString*)formatDateForTableCell:(NSDate*)date{

    NSString* stringfromDate= [NSDate stringFromDate:date withFormat:@"yyyy-MM-dd"];
    NSString* dateText=[Utils formatDateStringWithMonthAndDay:stringfromDate];
    return dateText;
}

+ (void)sortBirthdays:(NSMutableArray *)birthdays
{
    //NSLog(@"time took in filter method: %f", -[start timeIntervalSinceNow]);
    [birthdays sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Birthday *birth1 = (Birthday *)obj1;
        Birthday *birth2 = (Birthday *)obj2;
        if (birth1.days > birth2.days) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (birth1.days < birth2.days) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;   
    }];
}

+(NSMutableArray*)filterSameDayCelebritiesBirthdays:(NSDate*) thisDate
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CelebBirthdays" ofType:@"strings"                                                     inDirectory:nil forLocalization:nil];
    
    // compiled .strings file becomes a "binary property list"
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];       
    NSArray *allKeys = [dict allKeys];
    NSMutableArray *birthdays = [NSMutableArray arrayWithCapacity:[allKeys count]];
    
    for(id key in allKeys)
    {  
        NSString *objectForKey=[dict objectForKey:key];
        
        //only keys with values.
        if(![objectForKey isEqualToString:@""])
        {
            NSArray *splitedKey = [key componentsSeparatedByString:@"-"];
            NSInteger celebDay=[[splitedKey objectAtIndex:0] intValue];
            NSInteger celebMonth=[[splitedKey objectAtIndex:1] intValue];        
            
            NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit fromDate:thisDate];
            int thisMonth = [components2 month];
            int thisDay = [components2 day];
        
            if(thisDay == celebDay && thisMonth == celebMonth)
            {
                [birthdays addObject:[dict objectForKey:key]];
            }
        }
    }
    return birthdays;
}

+ (NSMutableString *)constructFriendWishMessage:(NSString*)friendName
{
    //NSArray *sepString =[friendName componentsSeparatedByString:@" "];
    NSMutableString* ms = [[[NSMutableString alloc] initWithString:@"Wish "] autorelease];  
    [ms appendString:friendName];
    //[ms appendString:@"\nWish "];
    //[ms appendString:[sepString objectAtIndex:0]];
    [ms appendString:@" a Happy Birthday!"];
    return ms;
}

//Local notification methods.
/* TODO: REMOVE IN NEXT VERSION
+(void) addLocalNotification:(NSDate*) fireDate:(NSInteger)badgeNumber
{
    UILocalNotification *aNotification = [[UILocalNotification alloc] init];
    aNotification.fireDate = fireDate;
    aNotification.timeZone = [NSTimeZone localTimeZone];
    //aNotification.alertBody = @"%d has birthdays.";
    aNotification.alertAction = @"Details";
    aNotification.applicationIconBadgeNumber=badgeNumber;
    [[UIApplication sharedApplication] scheduleLocalNotification:aNotification];
    [aNotification release];
}
*/

+(void) addLocalNotification:(NSDate*) fireDate
{
    UILocalNotification *aNotification = [[UILocalNotification alloc] init];
    
    aNotification.fireDate = fireDate;
    aNotification.timeZone = [NSTimeZone localTimeZone];
    //aNotification.repeatInterval = NSWeekdayCalendarUnit;
    aNotification.repeatInterval = NSWeekCalendarUnit;
    
    //aNotification.alertBody = @"%d has birthdays.";
    aNotification.alertAction = @"Details";
    aNotification.alertBody = @"You have friends with upcoming birthdays.";
    aNotification.applicationIconBadgeNumber=1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:aNotification];
    //NSLog(@"%@", aNotification);
    [aNotification release];
}

+ (int)getUserNumberWithTodayBirthday:(NSMutableArray *)friendsRecords
{
    int counter = 0;
    NSDate *today = [NSDate date];
    NSString *currentYear = [Utils returnCurrentYear];
    for(UserData *um in friendsRecords)
    {
        NSString *newDate=[Utils changeYearToPassed:um.birthday:currentYear];
        NSDate *userDate=[NSDate dateFromString:newDate
                                    withFormat:@"yyyy-MM-dd"];
        int days= [Utils getDaysBetween2Dates:userDate:today];
        if(days == 0)
        {
            counter++;
        }
    }
    return counter;
}

+ (int)getUserNumberDaysAhead :(NSInteger)daysAhead :(NSMutableArray *)friendsRecords
{
    int counter = 0;
    NSDate *today = [NSDate date];
    NSString *currentYear = [Utils returnCurrentYear];
    for(UserData *um in friendsRecords)
    {
        NSString *newDate=[Utils changeYearToPassed:um.birthday:currentYear];
        NSDate *userDate=[NSDate dateFromString:newDate
                                     withFormat:@"yyyy-MM-dd"];
        int days= [Utils getDaysBetween2Dates:userDate:today];
        if(days >= 0 && days < daysAhead)
        {
            counter++;
        }
    }
    return counter;
}

+ (void)setLocalNotification :(NSInteger)fireHour :(BOOL)remindDayOf :(NSInteger)daysAhead
{
    //NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    //[gregorian setFirstWeekday:2]; // Sunday == 1, Saturday == 7
    //NSUInteger adjustedWeekdayOrdinal = [gregorian ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:[NSDate date]];
    //NSLog(@"Adjusted weekday ordinal: %d", adjustedWeekdayOrdinal);

    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // Monday
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setYear:1979];
    [comps setMonth:1];
    [comps setDay:1];
    [comps setHour:fireHour];
    [comps setMinute:0];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate *triggerDate = [cal dateFromComponents:comps];
    [Utils addLocalNotification:triggerDate];
    
    [comps setDay:3];
    triggerDate = [cal dateFromComponents:comps];
    [Utils addLocalNotification:triggerDate];
    
    [comps setDay:5];
    triggerDate = [cal dateFromComponents:comps];
    [Utils addLocalNotification:triggerDate];
    
    [comps release];
    [cal release];
    
    return;
    
    //NSDate *triggerDate = [Utils getTriggerDate:fireHour];
    
    // TODO: REMOVE IN NEXT VERSION.
    /*
    if(remindDayOf)
    {
        int counter;
        counter = [Utils getUserNumberWithTodayBirthday:friendsRecords];
        [Utils addLocalNotification:triggerDate:counter];
    }
    else
    {
        int counter;
        counter = [Utils getUserNumberDaysAhead:daysAhead:friendsRecords];
        [Utils addLocalNotification:triggerDate:counter];
    }
    */
}
+ (void)resizeImage:(UIImage **)image_p
{
    CGSize size = (*image_p).size;
    CGFloat ratio = 0;
    if (size.width > size.height) {
        ratio = 47.0 / size.width;
    } else {
        ratio = 47.0 / size.height;
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
    UIGraphicsBeginImageContext(rect.size);
    [*image_p drawInRect:rect];
    *image_p = UIGraphicsGetImageFromCurrentImageContext();
}

+ (NSString *)mapTimeValues:(int)sliderValue
{
    NSArray *arrayTimes=[[[NSArray alloc] initWithObjects: @"12 AM", @"1 AM", @"2 AM", @"3 AM", @"4 AM", @"5 AM", @"6 AM", @"7 AM", @"8 AM", @"9 AM", @"10 AM", @"11AM", @"12 PM", @"1 PM", @"2 PM", @"3 PM", @"4 PM", @"5 PM", @"6 PM", @"7 PM", @"8 PM", @"9 PM", @"10 PM", @"11 PM",nil]autorelease];
    
    NSString *result = nil;
    
    if (sliderValue >= 0 && sliderValue <= 23) {
        result = [arrayTimes objectAtIndex: sliderValue];
    }
    
    return result;
}

+ (NSString *)trimWhitespace:(NSString*) str {
    NSMutableString *mStr = [str mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)mStr);
    
    NSString *result = [mStr copy];
    
    [mStr release];
    return [result autorelease];
}

+ (UIDeviceResolution)resolution
{
    UIDeviceResolution resolution = UIDeviceResolution_Unknown;
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if (scale == 2.0f) {
            if (pixelHeight == 960.0f)
                resolution = UIDeviceResolution_iPhoneRetina35;
            else if (pixelHeight == 1136.0f)
                resolution = UIDeviceResolution_iPhoneRetina4;
            
        } else if (scale == 1.0f && pixelHeight == 480.0f)
            resolution = UIDeviceResolution_iPhoneStandard;
        
    } else {
        if (scale == 2.0f && pixelHeight == 2048.0f) {
            resolution = UIDeviceResolution_iPadRetina;
            
        } else if (scale == 1.0f && pixelHeight == 1024.0f) {
            resolution = UIDeviceResolution_iPadStandard;
        }
    }
    
    return resolution;
}

+ (float)retina4correction {
    return ([Utils resolution] == UIDeviceResolution_iPhoneRetina4)?(568.0f-480.0f):0.0f;
}

+ (float)nonRetina4correction {
    return ([Utils resolution] != UIDeviceResolution_iPhoneRetina4)?(568.0f-480.0f):0.0f;
}

+ (BOOL)inAppPurchasesAllowed
{
    if ([SKPaymentQueue canMakePayments]) {
        // Display a store to the user.
        NSLog(@"In-Apps purchases enabled.");
        //[self requestProductData];
        return YES;
    } else {
        // Warn the user that purchases are disabled.
        NSLog(@"In-Apps purchases disabled.");
        return NO;
    }
}

+ (void) requestProductData:(UIViewController<SKProductsRequestDelegate>*)delegate
{
    SKProductsRequest *request= [[[SKProductsRequest alloc] initWithProductIdentifiers:
                                 [NSSet setWithObject: INAPP_PRODUCT_NAME]] autorelease];
    request.delegate = delegate;
    [request start];
}

+ (NSNumber*) createAccount:(NSString *)account_email
           account_birthday:(NSString*)account_birthday
   account_birthday_private:(BOOL)account_birthday_private
             account_gender:(NSString*)account_gender
                account_pin:(NSString*)account_pin
           device_apn_token:(NSString*)device_apn_token
{
    NSNumber *accountID = nil;
    
    //account_email (required, string) - Account Email
    //account_birthday (required, date) - Account Birthday
    // Date Format: yyyy-MM-dd
    //account_birthday_private (required, bool) - Account Birthday Private Flag
    //account_gender (required, enum) - Account Gender
    //Values: enum { male=0, female=1 }
    //account_pin (required, string) - Account PIN Code (PIN Code should be exact 4 digits).
    //Values: string 0000-9999
    //device_apn_token (required, string) - Apn device token
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:CREATE_ACCOUNT_URL]];
    
    [request setValidatesSecureCertificate:NO];
    
    [request addPostValue:PROTO_VERSION forKey:@"proto_version"];
    [request addPostValue:PROTO_API_KEY forKey:@"api_key"];
    [request addPostValue:account_email forKey:@"account_email"];
    //NSDate* birthdayDate = [NSDate dateFromString:account_birthday withFormat:@"MMMM dd, YYYY"];
    //[request addPostValue:[NSDate stringFromDate:birthdayDate withFormat:@"yyyy-MM-dd"] forKey:@"account_birthday"];
    [request addPostValue:account_birthday forKey:@"account_birthday"];
    [request addPostValue:account_birthday_private?@"1":@"0" forKey:@"account_birthday_private"];
    [request addPostValue:([account_gender compare:@"Female"] == NSOrderedSame)?@"1":@"0" forKey:@"account_gender"];
    [request addPostValue:account_pin forKey:@"account_pin"];
    [request addPostValue:device_apn_token forKey:@"device_apn_token"];
    
    //[request addPostValue:activeUser.userID forKey:@"facebook_id"];
    //NSString *tokenString = [[NSString alloc] initWithData:appDelegate.token encoding:NSUTF8StringEncoding];
    //NSString *tokenString = [NSString stringWithUTF8String:[appDelegate.token bytes]];
    //[request addPostValue:appDelegate.token forKey:@"device_token"];
    
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"Response: %@", response);
        if ([response rangeOfString:@"SUCCESS"].location != NSNotFound) {
            NSLog(@"Account Successfully Created");
            NSArray* components = [response componentsSeparatedByString:@":"];
            //long card_id = -1;
            if ([components count] > 1) {
                accountID = [NSNumber numberWithLongLong:[[[[components objectAtIndex:1] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""] longLongValue] ];
                //accountID = [NSNumber numberWithLongLong:[[[[components objectAtIndex:1] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""] longLongValue] ];
                NSLog(@"Account ID: %@", accountID);
            } else {
                // No Card Found
            }
        } else {
            NSLog(@"Error Creating User");
        }
    } else {
        NSLog(@"Error Creating User");
    }
    
    return accountID;
}

+ (NSString*) loginAccount:(NSString*)account_email
               account_pin:(NSString*)account_pin
{
    NSString *sessionID = nil;
    
    //account_email (required, string) - Account Email
    //account_birthday (required, date) - Account Birthday
    // Date Format: yyyy-MM-dd
    //account_birthday_private (required, bool) - Account Birthday Private Flag
    //account_gender (required, enum) - Account Gender
    //Values: enum { male=0, female=1 }
    //account_pin (required, string) - Account PIN Code (PIN Code should be exact 4 digits).
    //Values: string 0000-9999
    //device_apn_token (required, string) - Apn device token
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:LOGIN_ACCOUNT_URL]];
    
    [request setValidatesSecureCertificate:NO];
    
    [request addPostValue:PROTO_VERSION forKey:@"proto_version"];
    [request addPostValue:PROTO_API_KEY forKey:@"api_key"];
    [request addPostValue:account_email forKey:@"account_email"];
    //NSDate* birthdayDate = [NSDate dateFromString:account_birthday withFormat:@"MMMM dd, YYYY"];
    //[request addPostValue:[NSDate stringFromDate:birthdayDate withFormat:@"yyyy-MM-dd"] forKey:@"account_birthday"];
    [request addPostValue:account_pin forKey:@"account_pin"];
    
    //[request addPostValue:activeUser.userID forKey:@"facebook_id"];
    //NSString *tokenString = [[NSString alloc] initWithData:appDelegate.token encoding:NSUTF8StringEncoding];
    //NSString *tokenString = [NSString stringWithUTF8String:[appDelegate.token bytes]];
    //[request addPostValue:appDelegate.token forKey:@"device_token"];
    
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"Response: %@", response);
        if ([response rangeOfString:@"SUCCESS"].location != NSNotFound) {
            NSLog(@"Logon Successful");
            NSArray* components = [response componentsSeparatedByString:@": "];
            //long card_id = -1;
            if ([components count] > 1) {
                sessionID = [[[[components objectAtIndex:1]stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""]stringByReplacingOccurrencesOfString:@"}" withString:@""];
                //sessionID = [NSNumber numberWithLongLong:[[[[components objectAtIndex:1] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""] longLongValue] ];
                NSLog(@"Login Session ID: '%@'", sessionID);
            } else {
                // Login Failed
            }
        } else {
            NSLog(@"Error Login User");
        }
    } else {
        NSLog(@"Error Login User");
    }
    
    return sessionID;
}

+ (BOOL) logoutAccount:(NSString*)session_id
{
    BOOL result = NO;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:LOGOUT_ACCOUNT_URL]];
    
    [request setValidatesSecureCertificate:NO];
    
    [request addPostValue:PROTO_VERSION forKey:@"proto_version"];
    [request addPostValue:PROTO_API_KEY forKey:@"api_key"];
    [request addPostValue:session_id forKey:@"session_id"];
    
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"Response: %@", response);
        if ([response rangeOfString:@"SUCCESS"].location != NSNotFound) {
            NSLog(@"Logout Successful");
            //NSArray* components = [response componentsSeparatedByString:@":"];
            ////long card_id = -1;
            //if ([components count] > 1) {
            //    //sessionID = [[[[components objectAtIndex:1]stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""]stringByReplacingOccurrencesOfString:@"}" withString:@""];
            //    //sessionID = [NSNumber numberWithLongLong:[[[[components objectAtIndex:1] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""] longLongValue] ];
            //    //NSLog(@"Session ID: %@", sessionID);
            //} else {
            //    // Logout Failed
            //}
            result = YES;
        } else {
            NSLog(@"Error Logout User");
        }
    } else {
        NSLog(@"Error Logout User");
    }
    
    return result;
}

+ (BOOL) resetAccount:(NSString*)account_email
{
    BOOL result = NO;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:RESET_ACCOUNT_URL]];
    
    [request setValidatesSecureCertificate:NO];
    
    [request addPostValue:PROTO_VERSION forKey:@"proto_version"];
    [request addPostValue:PROTO_API_KEY forKey:@"api_key"];
    [request addPostValue:account_email forKey:@"account_email"];
    
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"Response: %@", response);
        if ([response rangeOfString:@"SUCCESS"].location != NSNotFound) {
            NSLog(@"Reset Successful");
            //NSArray* components = [response componentsSeparatedByString:@":"];
            ////long card_id = -1;
            //if ([components count] > 1) {
            //    //sessionID = [[[[components objectAtIndex:1]stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""]stringByReplacingOccurrencesOfString:@"}" withString:@""];
            //    //sessionID = [NSNumber numberWithLongLong:[[[[components objectAtIndex:1] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""] longLongValue] ];
            //    //NSLog(@"Session ID: %@", sessionID);
            //} else {
            //    // Reset Failed
            //}
            result = YES;
        } else {
            NSLog(@"Error Reset User");
        }
    } else {
        NSLog(@"Error Reset User");
    }
    
    return result;
}

+ (BOOL) resendEmail:(NSString *)account_email
{
    BOOL result = NO;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:RESEND_EMAIL_URL]];
    
    [request setValidatesSecureCertificate:NO];
    
    [request addPostValue:PROTO_VERSION forKey:@"proto_version"];
    [request addPostValue:PROTO_API_KEY forKey:@"api_key"];
    [request addPostValue:account_email forKey:@"account_email"];
    
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"Response: %@", response);
        if ([response rangeOfString:@"SUCCESS"].location != NSNotFound) {
            NSLog(@"Resend Successful");
            //NSArray* components = [response componentsSeparatedByString:@":"];
            ////long card_id = -1;
            //if ([components count] > 1) {
            //    //sessionID = [[[[components objectAtIndex:1]stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""]stringByReplacingOccurrencesOfString:@"}" withString:@""];
            //    //sessionID = [NSNumber numberWithLongLong:[[[[components objectAtIndex:1] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""] longLongValue] ];
            //    //NSLog(@"Session ID: %@", sessionID);
            //} else {
            //    // Resend Failed
            //}
            result = YES;
        } else {
            NSLog(@"Error Resend User");
        }
    } else {
        NSLog(@"Error Resend User");
    }
    
    return result;
}

#pragma mark Session Persistant Routines

+ (void) setSessionID:(NSString*)sessionID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:sessionID forKey:@"sessionID"];
    [userDefaults synchronize];
}

+ (NSString*) getSessionID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:@"sessionID"];
}

+ (NSArray*) spinnerImages
{
    NSArray * imageArray  = [[NSArray alloc] initWithObjects:
                                    [UIImage imageNamed:@"Loading_Move_1.png"],
                                    [UIImage imageNamed:@"Loading_Move_2.png"],
                                    [UIImage imageNamed:@"Loading_Move_3.png"],
                                    [UIImage imageNamed:@"Loading_Move_4.png"],
                                    [UIImage imageNamed:@"Loading_Move_5.png"],
                                    [UIImage imageNamed:@"Loading_Move_6.png"],
                                    [UIImage imageNamed:@"Loading_Move_7.png"],
                                    [UIImage imageNamed:@"Loading_Move_8.png"],
                                    [UIImage imageNamed:@"Loading_Move_9.png"],
                                    [UIImage imageNamed:@"Loading_Move_10.png"],
                                    [UIImage imageNamed:@"Loading_Move_11.png"],
                                    [UIImage imageNamed:@"Loading_Move_12.png"],
                                    nil];
    return [imageArray autorelease];
}

@end