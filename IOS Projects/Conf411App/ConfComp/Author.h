//
//  Author.h
//  ConfComp
//
//  Created by Antoan Tateosian on 30.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Institution;

@interface Author : NSObject

@property (nonatomic, assign) NSInteger authorId;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *title; 
@property (nonatomic, retain) NSString *name;   //full name?
@property (nonatomic, assign) NSInteger instituteId;
@property (nonatomic, retain) NSArray *presentations;
@property (nonatomic, retain) NSURL *image;
@property (nonatomic, retain) Institution *institution;
@property (nonatomic, retain) NSArray *institutions;

@end