//
//  Utils.h
//  ConfComp
//
//  Created by Anto  XX on 10/17/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ExtendedServerShortConferenceInfo;

@interface Utils : NSObject

+ (NSString *) documentsDirectory;
+ (NSString *) randomIdentifier;
+ (NSString *) markedToString:(BOOL)marked;
+(NSMutableString*) generateTimePM:(NSMutableString *) time;
+(NSMutableString*) generateTimePMWithoutSuffixes:(NSMutableString *) time;
+(NSArray*) generateTime;
+(NSArray*) generateTimeWithoutSuffixes;

+(void)enrichConferenceObject:(NSString*)server:(ExtendedServerShortConferenceInfo*)confInfo;
+(int) getServerVersion:(NSString*)server:(ExtendedServerShortConferenceInfo*)confInfo;
+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end
