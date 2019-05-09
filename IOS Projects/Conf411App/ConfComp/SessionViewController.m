//
//  SessionViewController.m
//  ConfComp
//
//  Created by Petko Yanakiev on 03.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "SessionViewController.h"
#import "ConfSession.h"
#import "ConferenceController.h"
#import "ConfDay.h"
#import "Place.h"
#import "Author.h"
#import "PresentationTableViewCell.h"
#import "PresentationViewController.h"
#import "Constants.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "UIViewController+CommonClass.h"
#import "SessionPaper.h"
#import <QuartzCore/QuartzCore.h>
#import "ConfTrack.h"

@implementation SessionViewController

@synthesize titleLabel=_titleLabel;
@synthesize titleText=_titleText;
@synthesize chairLabel=_chairLabel;
@synthesize chairLabelStatic=_chairLabelStatic;
@synthesize chairText=_chairText;
@synthesize dateText=_dateText;
@synthesize timeText=_timeText;
@synthesize placeText=_placeText;
@synthesize trackLabel=_trackLabel;
@synthesize trackText=_trackText;
@synthesize sessDescripionLabel=_sessDescripionLabel;
@synthesize sessDescriptionText=_sessDescriptionText;  
@synthesize sessionView=_sessionView;
@synthesize scrollView=_scrollView;
@synthesize tableViewSession=_tableViewSession;

- (id) initWithSession:(ConfSession *)inSession conferenceController:(ConferenceController *)conferenceController
{
    if ((self = [super initWithNibName:@"Session" bundle:[NSBundle mainBundle]]))
    {
        session = [inSession retain];
        confController = conferenceController;
        //NSLog(@"The conference track name is:%@",[conferenceController conferenceTrackName]);
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) dealloc
{
    [_titleLabel release];
    [_titleText release];
    [_chairLabel release];
    [_chairLabelStatic release];
    [_chairText release];
    [_dateText release];
    [_timeText release];
    [_placeText release];
    [_trackLabel release];
    [_trackText release];
    [_sessDescripionLabel release];
    [_sessDescriptionText release];   
    [_sessionView release];
    [_scrollView release];
    [session release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.tableViewSession respondsToSelector:@selector(setBackgroundView:)]) {
        [self.tableViewSession setBackgroundView:nil];
    }
    self.tableViewSession.backgroundColor = [UIColor clearColor];
    [self importCommonView:confController];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        //[self.scrollView setContentSize:CGSizeMake(768, 1000)];
    }else{
        [self.scrollView setContentSize:CGSizeMake(320, 600)];
    }
    [self initSessionView];
}

- (void)initModeratorsAndTracks 
{
    NSString *trackLabelName=[confController conferenceTrackName];
    NSString *moderatorLabelName=
    [confController conferenceModeratorName];
    
    if(trackLabelName !=nil){
        self.trackLabel.text=trackLabelName;
    }else{
        self.trackLabel.text=@"";
    }
    if(moderatorLabelName !=nil){
        self.chairLabel.text=moderatorLabelName;
    }else{
        self.chairLabel.text=@"";
    }

    if(session.chair != nil)
    {
        NSMutableString *chairNames=[[NSMutableString alloc]init];
        [chairNames appendString:session.chair.name];
        if(session.coChair!=nil)
        {
            [chairNames appendString:@","];
            [chairNames appendString:session.coChair.name];
        }
        self.chairText.text= [NSString stringWithFormat:@"%@", chairNames];
        self.chairLabelStatic.hidden = NO;
        [chairNames release];
    }
    else
    {
        self.chairText.text = @"";
        self.chairLabelStatic.hidden = YES;
    }
}

-(void)initSessionView{
    
    CALayer *l = [self.sessionView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    
    self.titleLabel.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    self.chairLabel.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    self.trackLabel.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    self.sessDescripionLabel.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];

    self.titleText.text=session.name;
    self.dateText.text=session.day.dateStr;
    self.timeText.text=session.timeStr;
    self.placeText.text=session.place.name;
    
    [self initModeratorsAndTracks];
    
    if(session.trackId != 0){
        self.trackText.text = session.track.description;
    }
    else{ self.trackText.text = @""; }
    
    if(session.description != nil)
    {
        self.sessDescriptionText.text=session.description;
    }else{
        self.sessDescriptionText.text=@"";
    }
}


-(void) viewWillAppear:(BOOL)animated {
    
    
    UIImage *backgroundImage = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        backgroundImage = [UIImage imageNamed:@"background_navbar_session_ipad"];
    }
    else
    {
        backgroundImage = [UIImage imageNamed:@"background_navbar_session"];
    }
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675332];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [[self.navigationController navigationBar] resetBackground:8765332];
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

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger presCount = [session.presentations count];
    return presCount;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;    
    SessionPaper *presentation = [session.presentations objectAtIndex:indexPath.section];
    cell = [PresentationTableViewCell cellWithPresentation:presentation table:tableView:indexPath.section];
   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableViewSession deselectRowAtIndexPath:indexPath animated:YES];
        SessionPaper *pres = [session.presentations objectAtIndex:indexPath.section];
        PresentationViewController *presVc = [[PresentationViewController alloc] initWithPresentation:pres conferenceController:confController];
            [self.navigationController pushViewController:presVc animated:YES];
            [presVc release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 10.0;
    
    return 1.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 3.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105.0; 
}

@end
