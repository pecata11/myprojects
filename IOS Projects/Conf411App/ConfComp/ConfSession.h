//
//  ConfSession.h
//  ConfComp
//
//  Created by Antoan Tateosian on 01.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ConfTimeFrame;
@class Place;
@class Author;
@class ConfDay;
@class ConfTrack;

@interface ConfSession : NSObject

@property (nonatomic, assign) NSInteger sessionId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) NSInteger placeId;
@property (nonatomic, assign) NSInteger trackId;
@property (nonatomic, assign) NSInteger dayId;
@property (nonatomic, retain) NSString *sessionType;
@property (nonatomic, retain) Place *place;
@property (nonatomic, retain) NSArray *presentations;
@property (nonatomic, retain) Author *chair;
@property (nonatomic, retain) Author *coChair;
@property (nonatomic, retain) ConfDay *day;
@property (nonatomic, retain) ConfTrack *track;
@property (nonatomic, retain) NSString *timeStr;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *sessionNumber;
-(NSComparisonResult)compare:(ConfSession *)session;


@end