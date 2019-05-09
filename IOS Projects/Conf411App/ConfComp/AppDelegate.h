//
//  AppDelegate.h
//  ConfComp
//
//  Created by Anto  XX on 10/17/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UINavigationController *navContr;
}
@property(nonatomic,retain) UINavigationController *navContr;
@property (strong, nonatomic) UIWindow *window;
-(UINavigationController*) getNavContr;
@end
