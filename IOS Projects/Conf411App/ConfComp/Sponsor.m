//
//  Sponsor.m
//  ConfComp
//
//  Created by Antoan Tateosian on 05.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "Sponsor.h"

@implementation Sponsor

@synthesize sponsorId = _sponsorId;
@synthesize name = _name;
@synthesize descr = _descr;
@synthesize urlAddress = _urlAddress;
@synthesize logoUrlAddress = _logoUrlAddress;
@synthesize ranking = _ranking;

- (void) dealloc
{
    [_name release];
    [_descr release];
    [_urlAddress release];
    [_logoUrlAddress release];
    
    [super dealloc];
}

@end
