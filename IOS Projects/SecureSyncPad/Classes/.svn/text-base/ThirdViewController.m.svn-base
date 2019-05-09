//
//  ThirdViewController.m
//  SecureSync
//
//  Created by Petko Yanakiev on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThirdViewController.h"
#import "DirectoryManager.h"
#import "MBProgressHUD.h"
#import "Constants.h"
#import "RootViewController.h"

@implementation ThirdViewController

@synthesize navigationBar;
@synthesize loadFiles;
@synthesize clearCashe;

#pragma mark -
#pragma mark View lifecycle


-(void) viewDidLoad{
    [super viewDidLoad];
}

-(void) viewDidUnload {
	[super viewDidUnload];
	self.navigationBar = nil;
}



#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Add the popover button to the left navigation item.
    [navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:NO];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Remove the popover button.
    [navigationBar.topItem setLeftBarButtonItem:nil animated:NO];
}


#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [navigationBar release];
    [super dealloc];
}	
@end
