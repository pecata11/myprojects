//
//  Place.m
//  ConfComp
//
//  Created by Antoan Tateosian on 29.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "Place.h"

@implementation Place

@synthesize placeId;
@synthesize xPos;
@synthesize yPos;
@synthesize name;

- (void) dealloc
{
    [name release];
    
    [super dealloc];
}

@end
