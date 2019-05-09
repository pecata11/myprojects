//
//  UIBottomBarView.m
//  Conference411
//
//  Created by Petko Yanakiev on 1/30/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import "UIBottomBarView.h"
#import "MainViewController.h"
#import "ConfSearchViewController.h"
#import "ConferenceGridViewController.h"
#import "ConferenceController.h"
#import "ProgramViewController.h"
#import "ConfDay.h"
#import "AppDelegate.h"
#import "ConfSession.h"

@implementation UIBottomBarView
@synthesize isChecked,navigationController,searchButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    //[super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    //[super viewDidLoad];
    confController = [[ConferenceController alloc]init];
    NSLog(@"After initialization");
    
}

- (void)viewDidUnload
{
    //[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(IBAction)agendaButtonClicked:(id)sender{
    
    UIButton *theButton = (UIButton*)sender;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIViewController* topController = appDelegate.getNavContr.topViewController;
    
    if([topController isKindOfClass:[ConferenceGridViewController class]])
    {
        [theButton setUserInteractionEnabled:NO];
    }
    else
    {
            ConferenceGridViewController *listVc = [[ConferenceGridViewController alloc] initWithDay:nil conferenceController:confController:confController.days];
        [self.navigationController pushViewController:listVc animated:YES];
        [listVc release];    

    }
}


-(IBAction)searchButtonClicked:(id)sender{
    
   UIButton *theButton = (UIButton*)sender;
    
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIViewController* topController = appDelegate.getNavContr.topViewController;
    
    if([topController isKindOfClass:[ConfSearchViewController class]])
    {
        [theButton setUserInteractionEnabled:NO];
    }
    else
    {
        ConfSearchViewController *searchVc = [[ConfSearchViewController alloc] initWithConferenceController:confController];
        [appDelegate.getNavContr pushViewController:searchVc animated:YES];
        [searchVc release];
    }
}

-(IBAction)programButtonClicked:(id)sender{
    UIButton *theButton = (UIButton*)sender;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIViewController* topController = appDelegate.getNavContr.topViewController;
    
    if([topController isKindOfClass:[ProgramViewController class]])
    {
        [theButton setUserInteractionEnabled:NO];
    }
    else
    {
        ProgramViewController *programVc = [[ProgramViewController alloc] initWithConferenceController:confController];
        if(confController == nil){
            NSLog(@"Here is nil");
        }
                for(ConfSession *session in confController.sessions){
            //NSLog(@"The name is:%@",session.name);
        }
        [appDelegate.getNavContr pushViewController:programVc animated:YES];
        [programVc release];
    }

}

-(IBAction)homeButtonPressed:(id)sender
{
    MainViewController *mainVc = [[MainViewController alloc] init]; 
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.getNavContr pushViewController:mainVc animated:YES];
    [mainVc release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
