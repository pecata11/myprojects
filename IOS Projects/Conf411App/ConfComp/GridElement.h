//
//  GridElement.h
//  ConfComp
//
//  Created by Antoan Tateosian on 11/4/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ConfDay;
@class ConfSession;
@class Presentation;

typedef enum {
    GridElementTypeText,
    GridElementTypeSession,
    GridElementTypePresentation,
    GridElementTypeTime
} GridElementType;

@interface GridElement : NSObject

@property (nonatomic, assign) ConfDay *day;
@property (nonatomic, retain) ConfSession *session;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) Presentation *presentation;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, assign) NSInteger rowStart, rowEnd;
@property (nonatomic, assign) NSInteger colStart, colEnd;

@property (nonatomic, readonly) GridElementType gridElementType;

@end
