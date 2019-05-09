//
//  UIMyScrollView.m
//  Conference411
//
//  Created by Petko Yanakiev on 2/2/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import "UIScrollView+event.h"

@implementation UIScrollView(MyScroll)

- (void) touchesBegin: (NSSet *) touches withEvent: (UIEvent *) event 
{	
    // If not dragging, send event to next responder
    if (!self.dragging) 
        [self.nextResponder touchesEnded: touches withEvent:event]; 
    else
        [super touchesEnded: touches withEvent: event];
}


- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event 
{	
    // If not dragging, send event to next responder
    if (!self.dragging) 
        [self.nextResponder touchesEnded: touches withEvent:event]; 
    else
        [super touchesEnded: touches withEvent: event];
}
@end
