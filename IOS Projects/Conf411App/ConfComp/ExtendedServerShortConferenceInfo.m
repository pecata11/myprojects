//
//  ExtendedServerShortConferenceInfo.m
//  ConfComp
//
//  Created by Antoan Tateosian on 28.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "ExtendedServerShortConferenceInfo.h"

#import "Constants.h"

@implementation ExtendedServerShortConferenceInfo

@synthesize confDescription;
@synthesize smallImageUrl;
@synthesize bigImageUrl;
@synthesize mapImageUrl;
@synthesize confDataUrl;

- (NSArray *) linksToDownload
{
    return [NSArray arrayWithObjects:self.smallImageUrl, self.bigImageUrl, self.mapImageUrl, self.confDataUrl, nil];
}

- (NSArray *) fileNames
{
    return [NSArray arrayWithObjects:SMALL_IMAGE_FILE_NAME, LARGE_IMAGE_FILE_NAME, MAP_IMAGE_FILE_NAME, CONF_DATA_FILE_NAME, nil];
}

- (void) dealloc
{
    [confDescription release];
    [smallImageUrl release];
    [bigImageUrl release];
    [mapImageUrl release];
    [confDataUrl release];
    
    [super dealloc];
}

@end
