//
//  ServerShortConferenceInfo.m
//  ConfComp
//
//  Created by Anto  XX on 10/18/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "ServerShortConferenceInfo.h"

@implementation ServerShortConferenceInfo

@synthesize confId;
@synthesize name;
@synthesize date;
@synthesize venue;
@synthesize version;
@synthesize image;
@synthesize bigImage;
@synthesize mapImage;

- (BOOL) hasImage
{
    return image != nil;
}

- (void) dealloc
{
    [confId release];
    [name release];
    [date release];
    [venue release];
    [image release];
    [bigImage release];
    [mapImage release];
    
    [super dealloc];
}

@end
