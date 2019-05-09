//
//  ConfTimeFrame.h
//  ConfComp
//
//  Created by Antoan Tateosian on 01.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ConfDay;

@interface ConfTimeFrame : NSObject

@property (nonatomic, assign) NSInteger timeFrameId;
@property (nonatomic, assign) NSInteger dayId;
@property (nonatomic, retain) NSString *timeStr;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) ConfDay *day;
@property (nonatomic, retain) NSArray *sessions;

@end