//
//  ConfDay.h
//  ConfComp
//
//  Created by Antoan Tateosian on 01.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfDay : NSObject

@property (nonatomic, assign) NSInteger dayId;
@property (nonatomic, retain) NSString *dateStr;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *descr;
//@property (nonatomic, retain) NSArray *timeFrames;
@property (nonatomic, retain) NSArray *sessions;
@property (nonatomic, retain) NSArray *gridElements;

@end
