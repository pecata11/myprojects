//
//  UIMySearchBar.m
//  Conference411
//
//  Created by Petko Yanakiev on 2/3/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import "UIMySearchBar.h"

@implementation UISearchBar(Custom)
    
-(void) setCloseButtonTitle: (NSString *) title forState: (UIControlState)state
{
    [self setTitle: title forState: state forView:self];
}

-(void) setTitle: (NSString *) title forState: (UIControlState)state forView: (UIView *)view
{
    UIButton *cancelButton = nil;
    for(UIView *subView in view.subviews){
        if([subView isKindOfClass:UIButton.class])
        {
            cancelButton = (UIButton*)subView;
        }
        else
        {
            [self setTitle:title forState:state forView:subView];
        }
    }
    
    if (cancelButton)
        [cancelButton setTitle:title forState:state];    
}

-(void) setCancelButtonImage: (UIImage *) image forState: (UIControlState)state
{
    [self setImage: image forState: state forView:self];
}


-(void)setImage:(UIImage *) image forState: (UIControlState)state forView: (UIView *)view{
    
    UIButton *cancelButton = nil;
    for(UIView *subView in view.subviews)
    {
        if([subView isKindOfClass:UIButton.class])
        {
            cancelButton = (UIButton*)subView;
            
        }
        else
        {
            cancelButton.tintColor = [UIColor blueColor];
             [self setImage:image forState: state forView:subView];
        }
    }
    
    if (cancelButton)
        [cancelButton setImage:image forState:state];
}
@end