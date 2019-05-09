//
//  GridElement.m
//  ConfComp
//
//  Created by Antoan Tateosian on 11/4/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "GridElement.h"

@implementation GridElement

@synthesize day = _day;
@synthesize session = _session;
@synthesize text = _text;
@synthesize presentation = _presentation;
@synthesize time = _time;
@synthesize rowStart = _rowStart;
@synthesize rowEnd = _rowEnd;
@synthesize colStart = _colStart;
@synthesize colEnd = _colEnd;

- (GridElementType) gridElementType
{
    if (_text != nil)
    {
        return GridElementTypeText;
    }
    else if (_session != nil)
    {
        return GridElementTypeSession;
    }
    else if (_presentation != nil)
    {
        return GridElementTypePresentation;
    }
    else if (_time != nil)
    {
        return GridElementTypeTime;
    }
    else
    {
        NSAssert(nil, @"Invalid grid type");
        return 0;
    }
}

- (void) dealloc
{
    [_session release];
    [_text release];
    [_presentation release];
    [_time release];
    
    [super dealloc];
}

@end
