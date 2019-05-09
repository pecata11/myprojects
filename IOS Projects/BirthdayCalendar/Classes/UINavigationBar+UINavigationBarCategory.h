//
//  UINavigationBar+UINavigationBarCategory.h
//  ConfComp
//
//  Created by Petko Yanakiev on 1/18/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (UINavigationBarCategory)
-(void)setBackgroundImage:(UIImage*)image withTag:(NSInteger)bgTag;
-(void)setRightButton:(UIButton*)image withTag:(NSInteger)bgTag;
-(void)resetBackground:(NSInteger)bgTag; 
@end
