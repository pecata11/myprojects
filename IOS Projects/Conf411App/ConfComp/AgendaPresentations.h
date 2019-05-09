//
//  AgendaPresentations.h
//  Conference411
//
//  Created by Petko Yanakiev on 2/15/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SessionPaper;
@class Presentation;
@interface AgendaPresentations : NSObject

@property(nonatomic,retain) NSString *presentationName;
@property(nonatomic,retain) NSString *presentationStartTime;
@property(nonatomic,retain) NSString *presentationEndTime;
@property(nonatomic,assign) CGFloat yStartHour;
@property(nonatomic,assign) CGFloat yEndHour;
@property(nonatomic,retain) SessionPaper* presentation;
@property(nonatomic,assign) NSInteger presId;

@end
