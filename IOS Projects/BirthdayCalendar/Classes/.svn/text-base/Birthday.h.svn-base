//
//  Birthday.h
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Birthday : NSObject{
    NSDate *date;
    NSString *dateAsString;
    NSString *userID;
    NSString *name;
    NSString *photo;
    NSInteger days;
    NSData *thumbimage;
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *dateAsString;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *photo;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSData *thumbimage;
@property (nonatomic) NSInteger days;

+ (Birthday*) birthdayNamed :(NSString*)aName :(NSDate*)aDate :(NSString*)aDateAsString :(NSString *)aPhoto :(NSString*)auserID :(NSInteger)adays :(NSData*)aThumb;
- (id)initWithName :(NSString *)aName :(NSDate *)aDate :(NSString*)aDateAsString :(NSString *)aPhoto :(NSString*)auserID :(NSInteger)adays :(NSData*)aThumb;
- (NSComparisonResult)compare :(Birthday *)otherHoliday;
@end