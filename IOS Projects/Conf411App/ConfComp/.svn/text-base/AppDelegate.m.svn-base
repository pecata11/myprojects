//
//  AppDelegate.m
//  ConfComp
//
//  Created by Anto  XX on 10/17/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "AllConfsController.h"
#import "Constants.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navContr=_navContr;

- (void)dealloc
{
    [_window release];
    [_navContr release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //TODO Write default bundle code.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *confServerDefaultValue = [NSDictionary dictionaryWithObject:REACHABILITY_CHECK_HOST forKey:@"confServer"];
    NSDictionary *confPortDefaultValue = [NSDictionary dictionaryWithObject:@"8080" forKey:@"confPort"];
    [defaults registerDefaults:confServerDefaultValue];
    [defaults registerDefaults:confPortDefaultValue];

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    MainViewController *mainVc = [[MainViewController alloc] init];
    //construct a navigation controller here and push the main view.
    navContr = [[UINavigationController alloc] initWithRootViewController:mainVc];
    self.window.rootViewController = navContr;
    
    [mainVc release];
    [navContr release];
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(UINavigationController*) getNavContr{
    return navContr;
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void) applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[AllConfsController sharedConferencesController] removeCachedConferenceControllers];
}

@end
