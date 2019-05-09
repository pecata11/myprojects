//
//  Utils.m
//  ConfComp
//
//  Created by Petko Yanakiev  XX on 10/17/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "Utils.h"
#import "JSON.h"
#import "ExtendedServerShortConferenceInfo.h"
#import "Constants.h"

#import<sys/xattr.h>

#define startAM 8
#define endAM 12
#define startPM 13
#define endPM 21
#define startMinute 15
#define endMinute 60
#define stepMinute 15

@implementation Utils

+ (NSString *) documentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *) randomIdentifier
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef strUuid = CFUUIDCreateString(NULL, uuid);
	CFRelease(uuid);
	return [(NSString *)strUuid autorelease];
}

+ (NSString *) markedToString:(BOOL)marked
{
    return marked ? @"Unmark" : @"Mark";
}

+(NSArray*) generateTimeWithoutSuffixes{
    
    NSMutableString *time=[[NSMutableString alloc]init];
    NSMutableString *timeAM = [[NSMutableString alloc]init];
    
    for(NSInteger hour = startAM; hour <= endAM; hour++)
    {
        if(hour == 8)
        {
            [timeAM appendString: [NSString stringWithFormat:@"0%d",hour]];
            [timeAM appendString: @":"];
            [timeAM appendString: @"00"];
            [timeAM appendString: @"-"];
        }
        
        for(NSInteger minute = startMinute; minute <= endMinute; minute += stepMinute)
        {   
            NSMutableString *timeZero=[[NSMutableString alloc] init];
            if(minute == 60)
            {
                if(hour == 12 || hour == 11){
                    [timeZero appendString: [NSString stringWithFormat:@"%d",hour+1]];
                    [timeZero appendString: @":"];
                    [timeZero appendString: @"00"];
                    [timeZero appendString: @"-"];
                }                
                else
                {
                    if(hour == 8){
                        [timeZero appendString: [NSString stringWithFormat:@"0%d",hour+1]];
                    }
                    else{
                        [timeZero appendString: [NSString stringWithFormat:@"%d",hour+1]];
                    }
                    [timeZero appendString: @":"];
                    [timeZero appendString: @"00"];
                    [timeZero appendString: @"-"];
                }
                [timeAM appendString: timeZero];
                [timeZero release];
                break;      
            }
            
            if(hour == 8 || hour == 9){
                [timeAM appendString: [NSString stringWithFormat:@"0%d",hour]];
                [timeAM appendString: @":"];
                [timeAM appendString:[NSString stringWithFormat:@"%d", minute]];
                [timeAM appendString: @"-"]; 
            }
            else
            {
                [timeAM appendString:[NSString stringWithFormat:@"%d", hour]];
                [timeAM appendString: @":"];
                [timeAM appendString:[NSString stringWithFormat:@"%d", minute]];
                
                if(hour == 12){
                    [timeAM appendString: @"-"];             
                }else{
                    [timeAM appendString: @"-"];
                }
            }
        }
        continue;
    }
    [time appendString:timeAM];
    [timeAM release];
    [time appendString:[Utils generateTimePMWithoutSuffixes:time]];
    NSArray* foo = [time componentsSeparatedByString: @"-"];
    [time release];
    return foo;
}


+(NSArray*) generateTime{
    
    NSMutableString *time=[[NSMutableString alloc]init];
    NSMutableString *timeAM = [[NSMutableString alloc]init];
    
    for(NSInteger hour = startAM; hour <= endAM; hour++)
    {
        if(hour == 8)
        {
            [timeAM appendString: [NSString stringWithFormat:@"0%d",hour]];
            [timeAM appendString: @":"];
            [timeAM appendString: @"00"];
            [timeAM appendString: @" AM - "];
        }
        
        for(NSInteger minute = startMinute; minute <= endMinute; minute += stepMinute)
        {   
            NSMutableString *timeZero=[[NSMutableString alloc] init];
            
            if(minute == 60)
            {
                if(hour == 12 || hour == 11){
                    [timeZero appendString: [NSString stringWithFormat:@"%d",hour+1]];
                    [timeZero appendString: @":"];
                    [timeZero appendString: @"00"];
                    [timeZero appendString: @" PM - "];
                }                
                else
                {
                    if(hour == 8){
                        [timeZero appendString: [NSString stringWithFormat:@"0%d",hour+1]];
                    }
                    else{
                        [timeZero appendString: [NSString stringWithFormat:@"%d",hour+1]];
                    }
                    [timeZero appendString: @":"];
                    [timeZero appendString: @"00"];
                    [timeZero appendString: @" AM - "];
                }
                [timeAM appendString: timeZero];
                [timeZero release];
                break;      
            }
            
            if(hour == 8 || hour == 9){
                [timeAM appendString: [NSString stringWithFormat:@"0%d",hour]];
                [timeAM appendString: @":"];
                [timeAM appendString:[NSString stringWithFormat:@"%d", minute]];
                [timeAM appendString: @" AM - "]; 
            }
            else
            {
                [timeAM appendString:[NSString stringWithFormat:@"%d", hour]];
                [timeAM appendString: @":"];
                [timeAM appendString:[NSString stringWithFormat:@"%d", minute]];
                
                if(hour == 12){
                     [timeAM appendString: @" PM - "];             
                }else{
                     [timeAM appendString: @" AM - "];
                }
            }
        }
        continue;
    }
    [time appendString:timeAM];
    [timeAM release];
    [time appendString:[Utils generateTimePM:time]];
    NSArray* foo = [time componentsSeparatedByString: @"-"];
    [time release];
    return foo;
}

+(NSMutableString*) generateTimePM:(NSMutableString *) time{
    
    NSMutableString* timePM=[[NSMutableString alloc]init];
    
    for(NSInteger hour = startPM; hour <= endPM; hour++)
    {
        for(NSInteger minute = startMinute; minute <= endMinute; minute += stepMinute)
        {   
            NSMutableString *timeZero = [[NSMutableString alloc]init];
            if(minute == 60)
            {
                [timeZero appendString: [NSString stringWithFormat:@"%d",hour+1]];
                [timeZero appendString: @":"];
                [timeZero appendString: @"00"];
                [timeZero appendString: @" PM - "];
                [timePM appendString: timeZero];
                break;      
            }
            [timePM appendString:[NSString stringWithFormat:@"%d", hour]];
            [timePM appendString: @":"];
            [timePM appendString:[NSString stringWithFormat:@"%d", minute]];
            [timePM appendString: @" PM - "];
        }
        
        continue;
    }
    return timePM;
}

+(NSMutableString*) generateTimePMWithoutSuffixes:(NSMutableString *) time{
    
    NSMutableString* timePM=[[NSMutableString alloc]init];
    
    for(NSInteger i = startPM; i <= endPM; i++)
    {
        for(NSInteger j = startMinute; j <= endMinute; j += stepMinute)
        {   
            NSMutableString *timeZero = [[NSMutableString alloc]init];
            if(j == 60)
            {
                [timeZero appendString: [NSString stringWithFormat:@"%d",i+1]];
                [timeZero appendString: @":"];
                [timeZero appendString: @"00"];
                [timeZero appendString: @"-"];
                [timePM appendString: timeZero];
                break;      
            }
            [timePM appendString:[NSString stringWithFormat:@"%d", i]];
            [timePM appendString: @":"];
            [timePM appendString:[NSString stringWithFormat:@"%d", j]];
            [timePM appendString: @"-"];
        }
        
        continue;
    }
    return timePM;
}



+(void)enrichConferenceObject:(NSString*)server:(ExtendedServerShortConferenceInfo*)confInfo
{
    NSString *serverList = [server stringByAppendingString:SERVER_CONFERENCES_LIST_URL];
    NSString *serverGetConference=[server stringByAppendingString:SERVER_GET_CONFERENCE_URL];
    
    NSURL *confURL = [NSURL URLWithString:
                      [NSString stringWithFormat:serverList]];
    NSLog(@"The getserverURL is:%@",confURL);
    NSData *theConfData=[[NSData alloc]initWithContentsOfURL:confURL];
    NSString *strData = [[[NSString alloc] initWithData:theConfData encoding:NSUTF8StringEncoding] autorelease];
    [theConfData release];
    NSError *err = nil;
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    id obj = [parser objectWithString:strData error:&err];
    
    NSArray *confs = (NSArray *)obj;
    for (NSDictionary *currServerInfo in confs)
    {
        if([confInfo.confId isEqualToString:[currServerInfo objectForKey:@"id"]])
        {
            NSString *smallUrl = [currServerInfo objectForKey:@"smallLogo"];
            smallUrl = [smallUrl stringByReplacingOccurrencesOfString:@"100.png" withString:@"50.png" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [smallUrl length])];
            confInfo.smallImageUrl = [NSURL URLWithString:smallUrl];
            confInfo.bigImageUrl = [NSURL URLWithString:[currServerInfo objectForKey:@"largeLogo"]];
            confInfo.mapImageUrl = [NSURL URLWithString:[currServerInfo objectForKey:@"map"]];
            confInfo.confDataUrl = [NSURL URLWithString:[NSString stringWithFormat:serverGetConference,confInfo.confId]];
            confInfo.version = [[currServerInfo objectForKey:@"version"] intValue];
            break;
        }
    } 
}

+(int) getServerVersion:(NSString*)server:(ExtendedServerShortConferenceInfo*)confInfo
{
    
    NSString *serverGetVersion = [server stringByAppendingString:SERVER_GET_VERSION_URL];
    NSURL *versionURL = [NSURL URLWithString:[NSString stringWithFormat:serverGetVersion, confInfo.confId]];
    // NSLog(@"versionURL:%@",versionURL);
    NSData *theData=[[NSData alloc]initWithContentsOfURL:versionURL];
    NSString *str = [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];
    [theData release];
    NSError *err = nil;
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];  
    int serverVersion = [[[parser objectWithString:str error:&err] valueForKey:@"version"] intValue];
    return serverVersion;
}

+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    if (&NSURLIsExcludedFromBackupKey == nil) { // iOS <= 5.0.1
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    } else { // iOS >= 5.1
        
        
        NSLog(@"%d",[URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil]);
        return [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
    }
}


@end
