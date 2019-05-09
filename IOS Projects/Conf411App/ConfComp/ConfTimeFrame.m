//
//  ConfTimeFrame.m
//  ConfComp
//
//  Created by Antoan Tateosian on 01.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "ConfTimeFrame.h"

@implementation ConfTimeFrame

@synthesize timeFrameId = _timeFrameId;
@synthesize dayId = _dayId;
@synthesize timeStr = _timeStr;
@synthesize type = _type;
@synthesize day = _day;
@synthesize sessions = _sessions;

- (void) dealloc
{
    [_timeStr release];
    [_type release];
    [_day release];
    [_sessions release];
    
    [super dealloc];
}

@end
