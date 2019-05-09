//
//  Exhibitor.h
//  ConfComp
//
//  Created by Antoan Tateosian on 29.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Place;
@class ServerShortConferenceInfo;

@interface Exhibitor : NSObject

@property (nonatomic, assign) NSInteger exhibitorId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *descr;
@property (nonatomic, retain) NSString *urlAddress;
@property (nonatomic, retain) NSString *logoUrlAddress;
@property (nonatomic, retain) Place *place;

@end
