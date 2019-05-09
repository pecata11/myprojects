//
//  Topic.m
//  ConfComp
//
//  Created by Antoan Tateosian on 02.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "Topic.h"

#import "Constants.h"

@implementation Topic

@synthesize topicId = _topicId;
@synthesize name = _name;
@synthesize presentations = _presentations;
@synthesize marked = _marked;

- (UIColor *) markColor
{
    if (self.isMarked)
    {
        return MARK_COLOR;
    }
    else
    {
        return [UIColor clearColor];
    }
}

- (void) dealloc
{
    [_name release];
    [_presentations release];
    
    [super dealloc];
}

@end
