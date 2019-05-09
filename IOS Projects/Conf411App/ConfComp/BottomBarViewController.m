//
//  BottomBarViewController.m
//  Conference411
//
//  Created by Petko Yanakiev on 3/5/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import "BottomBarViewController.h"
#import "MainViewController.h"
#import "ConfSearchViewController.h"
#import "ConferenceGridViewController.h"
#import "ConferenceController.h"
#import "ProgramViewController.h"
#import "ConfDay.h"
#import "AppDelegate.h"
#import "ConfSession.h"

@implementation BottomBarViewController


- (id) initWithConferenceController:(ConferenceController *)conferenceController{
    
    if ((self = [super initWithNibName:@"BottomBarViewController" bundle:[NSBundle mainBundle]]))
    {
        confController = conferenceController;
    }
    return self;
    
}

-(IBAction)agendaButtonClicked:(id)sender{
    
    UIButton *theButton = (UIButton*)sender;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if([appDelegate.getNavContr.topViewController isKindOfClass:[ConferenceGridViewController class]])
    {
         [theButton setUserInteractionEnabled:NO];
         //[theButton setBackgroundImage:[UIImage imageNamed:@"agenda_clicked"] forState:UIControlStateNormal];
    }
    else
    {
        //ConfDay *day = [[ConfDay alloc]init];
        ConferenceGridViewController *listVc = [[ConferenceGridViewController alloc] initWithDay:nil conferenceController:confController:confController.days];
        [appDelegate.getNavContr pushViewController:listVc animated:YES];
        [listVc release];    
        
    }
}

-(IBAction)searchButtonClicked:(id)sender{
    
    UIButton *theButton = (UIButton*)sender;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if([appDelegate.getNavContr.topViewController isKindOfClass:[ConfSearchViewController class]])
    {
//        UIImage *image=[[UIImage alloc]initWithContentsOfFile:@"search_clicked"];
//        [theButton setImage:image forState:UIControlStateNormal];
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

    if([appDelegate.getNavContr.topViewController  isKindOfClass:[ProgramViewController class]])
    {
//        UIImage *image=[[UIImage alloc]initWithContentsOfFile:@"search_clicked"];
//        [theButton setImage:image forState:UIControlStateNormal];
        [theButton setUserInteractionEnabled:NO];
    }
    else
    {
        ProgramViewController *programVc = [[ProgramViewController alloc] initWithConferenceController:confController];
        [appDelegate.getNavContr pushViewController:programVc animated:YES];
        [programVc release];
    }
}

-(IBAction)homeButtonPressed:(id)sender
{
    MainViewController *mainVc = [[MainViewController alloc] init]; 
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.getNavContr pushViewController:mainVc animated:YES];
    [mainVc release];}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
