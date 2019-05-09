//
//  Birthday.m
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Birthday.h"

@implementation Birthday
@synthesize date, name, photo,userID,days,thumbimage,dateAsString;

+ (Birthday*)birthdayNamed :(NSString *)aName :(NSDate *)aDate :(NSString*)aDateAsString :(NSString *)aPhoto :(NSString*)auserID :(NSInteger)adays :(NSData*)aThumb;
{
    return [[[Birthday alloc] initWithName:aName:aDate:aDateAsString:aPhoto:auserID:adays:aThumb] autorelease];
}

- (id)initWithName: (NSString *)aName :(NSDate *)aDate :(NSString*)aDateAsString :(NSString *)aPhoto :(NSString*)auserID :(NSInteger)adays :(NSData*)aThumb
{
    if ((self = [super init])) {
        self.name = aName;
        self.date = aDate;
        self.dateAsString=aDateAsString;
        self.photo = aPhoto;
        self.userID=auserID;
        self.days=adays;
        self.thumbimage=aThumb;
    }
    return self;
}

- (NSComparisonResult)compare:(Birthday *)otherBirthday
{
    NSComparisonResult comparison = [self.date compare:otherBirthday.date];
    if (comparison == NSOrderedSame)
        return [self.name compare:otherBirthday.name];
    else
        return comparison;
}

- (void)dealloc
{
    [date release];
    [name release];
    [photo release];
    [thumbimage release];
    [super dealloc];
}


@end
