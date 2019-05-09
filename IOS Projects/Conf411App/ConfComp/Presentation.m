//
//  Presentation.m
//  ConfComp
//
//  Created by Antoan Tateosian on 30.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "Presentation.h"

#import "Author.h"
#import "ConfSession.h"
#import "ConfTimeFrame.h"
#import "ConfDay.h"
#import "Constants.h"
#import "Topic.h"

@implementation Presentation

@synthesize presentationId = _presentationId;
@synthesize title = _title;
@synthesize time = _time;
@synthesize sessionId = _sessionId;
@synthesize firstAuthorId = _firstAuthorId;
@synthesize score = _score;
@synthesize descr = _descr;
@synthesize comment = _comment;
@synthesize firstAuthor = _firstAuthor;
@synthesize authors = _authors;
@synthesize session = _session;
@synthesize topics = _topics;
@synthesize marked = _marked;
@synthesize sessions=_sessions;
@synthesize sessionPaper=_sessionPaper;

- (UIColor *) markColor
{
    if (self.isMarked)
    {
        return MARK_COLOR;
    }
    
    if (self.hasMarkedTopic)
    {
        return SECONDARY_MARK_COLOR;
    }
    
    return [UIColor clearColor];
}

- (BOOL) hasMarkedTopic
{
    for (Topic *currTopic in self.topics)
    {
        if (currTopic.isMarked)
        {
            return YES;
        }
    }
    
    return NO;
}

-(NSString *) dateDayValue
{
    return[NSString stringWithFormat:@"%@",self.session.day.dateStr];
    
}

- (NSString *) dayTimeValue
{
    return [NSString stringWithFormat:@"%@", self.time];
}

- (void) dealloc
{
    [_title release];
    [_time release];
    [_descr release];
    [_comment release];
    [_firstAuthor release];
    [_authors release];
    [_session release];
    [_topics release];
    [_sessions release];
    [_sessionPaper release];
    [super dealloc];
}

@end
