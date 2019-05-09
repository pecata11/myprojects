//
//  ConferenceViewController.m
//  ConfComp
//
//  Created by Anto  XX on 10/20/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "ConferenceViewController.h"

#import "SBJson.h"
#import "ServerShortConferenceInfo.h"
#import "HtmlTextViewController.h"
#import "ConferenceMapViewController.h"
#import "ExhibitorsViewController.h"
#import "InstitutionsViewController.h"
#import "AuthorsViewController.h"
#import "ConfSearchViewController.h"
#import "ConfDay.h"
#import "ConferenceListViewController.h"
#import "ConferenceGridViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIAlertView-Helpers.h"
#import "MiraPageViewController.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "ProgramViewController.h"
#import "AllConfsController.h"
#import "ExtendedServerShortConferenceInfo.h"
#import "Utils.h"

@interface ConferenceViewController ()

- (void) addObservers;
- (void) removeObservers;
- (void) controllerLoaded:(NSNotification *)notification;
- (void) controllerFailedLoading:(NSNotification *)notification;
- (void) confDidDownload:(NSNotification *)notification;
- (void) confDidFailDownloading:(NSNotification *)notification;

- (void)makeUpdate:(ExtendedServerShortConferenceInfo*)conferenceInfo;
@end

@implementation ConferenceViewController

@synthesize loadingView = _loadingView;
@synthesize actLoading = _actLoading;
@synthesize textLabel=_textLabel;
@synthesize exibitorsButton=_exibitorsButton;
@synthesize labelExpo=_labelExpo;
@synthesize confServer;
@synthesize confPort;

- (id) initWithConference:(ExtendedServerShortConferenceInfo *)inConfInfo
{
    if ((self = [super initWithNibName:@"ConferenceViewController" bundle:[NSBundle mainBundle]]))
    {
        confInfo = inConfInfo;
        confLoaded = NO;
    }
    
    return self;
}

- (void) addObservers
{
    if (!observersAdded)
    {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        AllConfsController *confs = [AllConfsController sharedConferencesController];
        
        [center addObserver:self selector:@selector(controllerLoaded:) name:AllConfsControllerDidLoadConferenceController object:confs];
        [center addObserver:self selector:@selector(controllerFailedLoading:) name:AllConfsControllerDidFailLoadingConferenceController object:confs];
        [center addObserver:self 
                   selector:@selector(confDidDownload:) 
                       name:AllConfsControllerDidDownloadConference 
                     object:confs];
        [center addObserver:self 
                   selector:@selector(confDidFailDownloading:) 
                       name:AllConfsControllerDidFailDownloadingConference 
                     object:confs];

    }
    
    observersAdded = YES;
}
- (void) confDidDownload:(NSNotification *)notification
{
    ExtendedServerShortConferenceInfo *downloadedConf = [[notification userInfo] valueForKey:AllConfsControllerDidDownloadConference_ConferenceKey];
    
    if (downloadedConf == confInfo)
    {
        //self.lblGoBackDescr.hidden = NO;
        
        //[self.actDownloading stopAnimating];
    }
}

- (void) confDidFailDownloading:(NSNotification *)notification
{
    ExtendedServerShortConferenceInfo *failedConf = [[notification userInfo] valueForKey:AllConfsControllerDidFailDownloadingConference_ConferenceKey];
    
    if (failedConf == confInfo)
    {
        //[self.actDownloading stopAnimating];
        //self.btnDownload.hidden = NO;
    }
}

- (void) removeObservers
{
    if (observersAdded)
    {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
        [center removeObserver:self];
    }
    
    observersAdded = NO;
}

- (void) didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *server = [defaults stringForKey:@"confServer"];
    NSString *port=[defaults stringForKey:@"confPort"];
    self.confServer=server;
    self.confPort=[port intValue];
    //self.title = @"Conference";
   self.textLabel.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];  
    [self addObservers];
    
    AllConfsController *allConfs = [AllConfsController sharedConferencesController];
        [allConfs requestControllerForConference:confInfo];
     confLoaded = YES;
    
    if([[confController exhibitors] count] ==0){
        [self.exibitorsButton setHidden:YES];
        [self.labelExpo setHidden:YES];
        NSLog(@"There is no exhibitors for this conference");
    }
}

-(void) viewWillAppear:(BOOL)animated {
    self.textLabel.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];

    UIImage *backgroundImage = nil;
    
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
         backgroundImage = [UIImage imageNamed:@"background_switchboard_navbar_ipad"];
     }
     else{
         backgroundImage = [UIImage imageNamed:@"background_switchboard_navbar"];
     }
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675323];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    
  [[self.navigationController navigationBar] resetBackground:8675323];
}


- (void) viewDidUnload
{
    [self removeObservers];
    self.loadingView = nil;
    self.actLoading = nil;
    
    [super viewDidUnload];
}

- (void) dealloc
{
    [self removeObservers];
    
    [confInfo release];
    [confController release];
    [_actLoading release];
    [_loadingView release];
    [super dealloc];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) controllerLoaded:(NSNotification *)notification
{
    ConferenceController *loadedConf = [[notification userInfo] valueForKey:AllConfsControllerDidLoadConferenceController_ConferenceKey];
    if (![loadedConf.conference.confId isEqualToString:confInfo.confId])
    {
        return;
    }
    
    if (confController != nil)
    {
        [confController release];
        confController = nil;
    }
    confController = [loadedConf retain];

    confLoaded=YES;
    
   /// [self.actLoading stopAnimating];
    //[self.loadingView removeFromSuperview];
}

- (void) controllerFailedLoading:(NSNotification *)notification
{
    ConferenceController *loadedConf = [[notification userInfo] valueForKey:AllConfsControllerDidFailDownloadingConference_ConferenceKey];
    if (![loadedConf.conference.confId isEqualToString:confInfo.confId])
    {
        return;
    }
    
    [self.actLoading stopAnimating];
    [self.loadingView removeFromSuperview];
    
    [UIAlertView showAlertViewWithTitle:@"Error loading conference data" message:@""];
}

-(IBAction)miraButtonClicked:(id)sender{
    
    MiraPageViewController *infoVc = [[MiraPageViewController alloc] initWithMiraPageController:confController];
    [self.navigationController pushViewController:infoVc animated:YES];
    [infoVc release];
}

-(IBAction)infoButtonClicked:(id)sender{
    
    if([confController practicalInfoHtml] != nil
        && confController.conference.name != nil 
        && confController != nil)
     {
         HtmlTextViewController *htmlTextVc = 
         [[HtmlTextViewController alloc] initWithHtmlString:
          [confController practicalInfoHtml]:
          confController.conference.name:confController];
    //htmlTextVc.title = @"Practical Info";
         [self.navigationController pushViewController:htmlTextVc animated:YES];
         [htmlTextVc release];
     }

}

-(IBAction)authorsButtonPressed:(id)sender
{
    int count = [[confController authors] count];
    NSLog(@"The authors number are:%d",count);
    AuthorsViewController *authVc = [[AuthorsViewController alloc] initWithAuthors:[confController authors] conferenceController:confController];
    [self.navigationController pushViewController:authVc animated:YES];
    [authVc release];
    
}
-(IBAction)expoButtonClicked:(id)sender{

    ExhibitorsViewController *expoVc = [[ExhibitorsViewController alloc] initWithExhibitors:[confController exhibitors] conferenceController:confController];
    [self.navigationController pushViewController:expoVc animated:YES];
    [expoVc release];

}

-(IBAction)calendarButtonPressed:(id)sender
{
    //ConfDay *day = [[ConfDay alloc]init];
    ConferenceListViewController *listVc = [[ConferenceListViewController alloc] initWithDay:nil conferenceController:confController:confController.days];
    [self.navigationController pushViewController:listVc animated:YES];
    [listVc release];
}

-(IBAction)agendaButtonClicked:(id)sender
{
    //xsConfDay *day = [[ConfDay alloc]init];
    ConferenceGridViewController *listVc = [[ConferenceGridViewController alloc] initWithDay:nil conferenceController:confController:confController.days];
    [self.navigationController pushViewController:listVc animated:YES];
    [listVc release];    
}


-(IBAction)mapButtonClicked:(id)sender
{
    ConferenceMapViewController *mapVc = [[ConferenceMapViewController alloc] initWithMapImage:confInfo.mapImage:confController];
    //mapVc.title = @"Map";
    [self.navigationController pushViewController:mapVc animated:YES];
    [mapVc release];
}
-(IBAction)searchButtonClicked:(id)sender
{
    ConfSearchViewController *searchVc = [[ConfSearchViewController alloc] initWithConferenceController:confController];
    [self.navigationController pushViewController:searchVc animated:YES];
    [searchVc release];
}

-(IBAction)programButtonClicked:(id)sender{
    ProgramViewController *progVc = [[ProgramViewController alloc] initWithConferenceController:confController];
    [self.navigationController pushViewController:progVc animated:YES];
    [progVc release];
}


-(BOOL)checkForUpdate:(ExtendedServerShortConferenceInfo*)conferenceInfo{
    
    NSLog(@"Update %@", conferenceInfo.confId);
    NSLog(@"Version %@", confController.conferenceVersion);
    
    int serverVersion=[Utils getServerVersion:self.confServer:conferenceInfo];
    [Utils enrichConferenceObject:self.confServer:conferenceInfo];  
    if (serverVersion > [confController.conferenceVersion intValue])
    {
        return YES;        
    }
    else
    {
        return NO;
    }

}

-(void)makeUpdate:(ExtendedServerShortConferenceInfo*)conferenceInfo
{
    AllConfsController *confsController = [AllConfsController sharedConferencesController];
        //NSLog(@"There is new version of %@ conference. Update is required", conferenceInfo.confId);
        [confsController deleteConference:conferenceInfo];
        //NSLog(@"Deleted");
        [self addObservers];
        [confsController downloadConference:conferenceInfo];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self makeUpdate:confInfo];
    }        
    else
    {
      //do nothing in this clause.
    }
}

-(IBAction)updateButtonClicked:(id)sender
{
    BOOL answer=[self checkForUpdate:confInfo];
    NSLog(@"The conf version is:%d",confInfo.version);
    if(!answer)
    {
          [UIAlertView showAlertViewWithTitle:@"Info" message:[NSString stringWithFormat:@"Conference %@ is up-to-date", confInfo.confId]];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Do you really want to update this conference?"
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"Update"
                              otherButtonTitles:@"Cancel", nil];
        [alert show];
        [alert release];
    }
}
@end