//
//  UINavigationBar+UINavigationBarCategory.m
//  ConfComp
//
//  Created by Petko Yanakiev on 1/18/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import "UINavigationBar+UINavigationBarCategory.h"

@implementation UINavigationBar (UINavigationBarCategory)

-(void)setBackgroundImage:(UIImage*)image withTag:(NSInteger)bgTag{
    if(image == NULL){ //might be called with NULL argument
        return;
    }
    UIImageView *aTabBarBackground = [[UIImageView alloc]initWithImage:image];
    aTabBarBackground.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    aTabBarBackground.tag = bgTag;
    [self addSubview:aTabBarBackground];
    [aTabBarBackground release];
}

-(void)setRightButton:(UIButton*)button withTag:(NSInteger)bgTag{
    if(button == NULL){ 
        return;
    }
        [self addSubview:button];
    }

/* input: The tag you chose to identify the view */
-(void)resetBackground:(NSInteger)bgTag {
    //UIView *removeView = [[UIView alloc] autorelease];
    //removeView = [self viewWithTag:bgTag];
    [[self viewWithTag:bgTag] removeFromSuperview];
    }
@end
