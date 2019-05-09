//
//  Institution.h
//  ConfComp
//
//  Created by Antoan Tateosian on 30.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ServerShortConferenceInfo;

@interface Institution : NSObject

@property (nonatomic, assign) NSInteger instituteId;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *descr;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *people;

@end
