//
//  SessionPaper.h
//  Conference411
//
//  Created by Petko Yanakiev on 3/9/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Presentation;
@class ConfSession;

@interface SessionPaper : NSObject{
    NSInteger sessPaperId;
    NSInteger pressId;
    NSInteger sessId;
    NSString *presTime;
    NSString *programNumber;
    NSString *boardNumber;
    NSString *title;
    Presentation *presentation;
    ConfSession *session;
    NSString *description;
    NSString *comment;
    NSArray *sessions;
    NSArray *authors;
    NSDictionary *dictOrderAuth;
    NSString* marked;
    NSMutableArray* presentations;
}
@property(nonatomic,assign) NSInteger sessPaperId;
@property(nonatomic,assign) NSInteger pressId;
@property(nonatomic,assign) NSInteger sessId;
@property(nonatomic,retain) NSString *presTime;
@property(nonatomic,retain) NSString *programNumber;
@property(nonatomic,retain) NSString *boardNumber;
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) Presentation *presentation;
@property(nonatomic,retain) ConfSession *session;
@property(nonatomic,readonly) NSString *dayTimeValue;
@property(nonatomic,readonly) NSString *dateDayValue;
@property(nonatomic,retain) NSString *description;
@property(nonatomic,retain) NSString *comment;
@property(nonatomic, retain) NSArray *sessions;
@property(nonatomic, retain) NSArray *authors;
@property(nonatomic, retain) NSDictionary *dictOrderAuth;
@property(nonatomic, retain) NSMutableArray *presentations;
@property (nonatomic, assign, getter = isMarked) BOOL marked;
@end
