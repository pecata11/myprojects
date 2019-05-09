//
//  ConfSession.m
//  ConfComp
//
//  Created by Antoan Tateosian on 01.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "ConfSession.h"
#import "ConfDay.h"

@implementation ConfSession

@synthesize sessionId = _sessionId;
@synthesize name = _name;
@synthesize placeId = _placeId;
//@synthesize timeFrameId = _timeFrameId;
//@synthesize timeFrame = _timeFrame;
@synthesize place = _place;
@synthesize presentations = _presentations;
@synthesize chair = _chair;
@synthesize coChair = _coChair;
@synthesize trackId=_trackId;
@synthesize sessionType=_sessionType;
@synthesize day=_day;
@synthesize timeStr=_timeStr;
@synthesize type=_type;
@synthesize dayId=_dayId;
@synthesize description=_description;
@synthesize  sessionNumber=_sessionNumber;
@synthesize track=_track;


-(NSComparisonResult)compare:(ConfSession *)session 
{
    int dateComp = [self.day.dateStr compare:session.day.dateStr];
    int timeComp = [self.timeStr compare:session.timeStr];
    int nameComp = [self.name compare:session.name];
    
    //sort by date.
    if (dateComp != NSOrderedSame)
    {
        return dateComp;   
    }
    else if(timeComp != NSOrderedSame)//sort by time
    {
       return timeComp; 
    }
    else    //sort by number
    {
        NSInteger number1 = [self.sessionNumber intValue];
        NSInteger number2 = [session.sessionNumber intValue];
        if (number1 < number2)
        {
            return NSOrderedAscending;
        }
        else if (number1 == number2) 
        {
            //sort by name if numbers are equal.
            if(nameComp != NSOrderedSame)
            { 
                return nameComp; 
            }
            return NSOrderedSame;
        }
        else
        {
            return NSOrderedDescending;
        }
    }
}

- (void) dealloc
{
    [_name release];
    [_place release];
    [_presentations release];
    [_chair release];
    [_sessionType release];
    [_day release];
    [_timeStr release];
    [_type release];
    [_coChair release];
    [_description release];
    [_sessionNumber release];
    [_track release];
    [super dealloc];
}

@end