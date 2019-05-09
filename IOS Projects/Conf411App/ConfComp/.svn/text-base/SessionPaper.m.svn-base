//
//  SessionPaper.m
//  Conference411
//
//  Created by Petko Yanakiev on 3/9/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import "SessionPaper.h"
#import "ConfSession.h"
#import "ConfTimeFrame.h"
#import "ConfDay.h"

@implementation SessionPaper
@synthesize sessPaperId=_sessPaperId;
@synthesize sessId=_sessId;
@synthesize pressId=_pressId;
@synthesize programNumber=_programNumber;
@synthesize boardNumber=_boardNumber;
@synthesize presTime=_presTime;
@synthesize title=_title;
@synthesize presentation=_presentation;
@synthesize session=_session;
@synthesize description=_description;
@synthesize comment=_comment;
@synthesize sessions=_sessions;
@synthesize authors=_authors;
@synthesize dictOrderAuth=_dictOrderAuth;
@synthesize marked=_marked;
@synthesize presentations=_presentations;

-(NSString *) dateDayValue
{
    //NSLog(@"The session date is%@:",self.session.day.dateStr);
    return[NSString stringWithFormat:@"%@",self.session.day.dateStr];
    
}

- (NSString *) dayTimeValue
{
    return [NSString stringWithFormat:@"%@", self.presTime];
}


-(void) dealloc{
    
    [super dealloc];
    [_programNumber release];
    [_boardNumber release];
    [_presTime release];
    [_title release];
    [_presentation release];
    [_session release];
    [_description release];
    [_comment release];
    //[_marked release];
    [_sessions release];
    [_authors release];
    [_dictOrderAuth release];
    [_presentations release];
}
@end