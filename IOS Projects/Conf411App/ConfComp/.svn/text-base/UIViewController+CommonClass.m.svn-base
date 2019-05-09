//
//  UIViewController+CommonClass.m
//  Conference411
//  Created by Petko Yanakiev on 3/5/12.
//  Copyright (c) 2012 EGT. All rights reserved.

#import "UIViewController+CommonClass.h"
#import "BottomBarViewController.h"
@implementation UIViewController (CommonClass)

-(void) importCommonView:(ConferenceController*)confController{
    
    BottomBarViewController *bView=[[BottomBarViewController alloc]initWithConferenceController:confController];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
       bView.view.frame = CGRectMake(0, 865, 768, 90);
    }
    else{
        bView.view.frame = CGRectMake(0, 345, 320, 69);
    }

    [self.view addSubview:bView.view];
}
@end
