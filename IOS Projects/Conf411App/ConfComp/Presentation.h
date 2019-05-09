//
//  Presentation.h
//  ConfComp
//
//  Created by Antoan Tateosian on 30.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Author;
@class ConfSession;
@class SessionPaper;
@interface Presentation : NSObject

@property (nonatomic, assign) NSInteger presentationId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, assign) NSInteger sessionId;
@property (nonatomic, assign) NSInteger firstAuthorId;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, retain) NSString *descr;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, retain) Author *firstAuthor;
@property (nonatomic, retain) NSArray *authors;
@property (nonatomic, retain) ConfSession *session;
@property (nonatomic, retain) NSArray *sessions;
@property (nonatomic, retain) NSArray *topics;
@property (nonatomic, assign, getter = isMarked) BOOL marked;
@property (nonatomic,retain) SessionPaper *sessionPaper;
// TODO: add topics
// returns something like Monday - 10:30-14:00
@property (nonatomic, readonly) NSString *dayTimeValue;
@property (nonatomic, readonly) NSString *dateDayValue;
@property (nonatomic, readonly) UIColor *markColor;
@property (nonatomic, readonly) BOOL hasMarkedTopic;

@end
