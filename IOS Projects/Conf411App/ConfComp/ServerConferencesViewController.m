//
//  ServerConferencesViewController.m
//  ConfComp
//
//  Created by Antoan Tateosian on 17.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "ServerConferencesViewController.h"

#import "Constants.h"
#import "Reachability.h"
#import "ConferenceTableViewCell.h"
#import "ServerShortConferenceInfo.h"
#import "ExtendedServerShortConferenceInfo.h"
#import "DownloadConferenceViewController.h"
#import "SBJson.h"
#import "UIAlertView-Helpers.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "MiraPageViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface ServerConferencesViewController ()

@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, retain) NSMutableArray *conferences;

- (void) loadConferences;

@property (nonatomic, retain) UIActivityIndicatorView *actLoadingList;
@property (nonatomic, retain) IBOutlet UILabel *textLabel;

- (void) loadImagesForVisibleCells;
- (void) btnRefreshPressed:(id)sender;

@end

@implementation ServerConferencesViewController

@synthesize queue;
@synthesize conferences;
@synthesize actLoadingList;
@synthesize viewHeader = _viewHeader;
@synthesize textLabel=_textLabel;
@synthesize tableView=_tableView;
@synthesize confServer;
@synthesize confPort;

- (id) init
{
    if ((self = [super initWithNibName:@"ServerConferencesViewController" bundle:[NSBundle mainBundle]]))
    {
        loadConferencesCalled = NO;
    }
    
    return self;
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

    //self.title = @"Conferences";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];

    self.textLabel.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.actLoadingList = actView;
    [actView release];
    
    self.actLoadingList.hidesWhenStopped = YES;
    
    CGRect actFrame = self.actLoadingList.frame;
    actFrame.origin = CGPointMake((self.view.bounds.size.width - actFrame.size.width) / 2.0,
    (self.view.bounds.size.height - actFrame.size.height) / 2.0);
    self.actLoadingList.frame = actFrame;
    
    [self.view addSubview:self.actLoadingList];
    
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    self.queue = q;
    [q release];
    
    UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(btnRefreshPressed:)];
    //add a refresh buton here on the right of the navigation bar.
    self.navigationItem.rightBarButtonItem = btnRefresh;
    [btnRefresh release];
    tableView.backgroundColor=[UIColor clearColor];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(IBAction)miraButtonClicked:(id)sender{
    
    MiraPageViewController *infoVc = [[MiraPageViewController alloc] init];
    [self.navigationController pushViewController:infoVc animated:YES];
    [infoVc release];
    
}

- (void) btnRefreshPressed:(id)sender
{
    loadConferencesCalled = NO;
    
    //NSLog(@"In method btnRefreshPressed:");
    
    [self loadConferences];
}

-(void) viewWillAppear:(BOOL)animated {
    
    UIImage *backgroundImage = nil;
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
      {
          backgroundImage = [UIImage imageNamed:@"background_navbar_conflist_ipad"];
      }
      else
      {
        backgroundImage = [UIImage imageNamed:@"background_navbar_conflist"]; 
      }
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675326];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[self.navigationController navigationBar] resetBackground:8675326];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    if (!loadConferencesCalled)
    {
        [self loadConferences];
    }
}

- (void) viewDidUnload
{
    [self.queue cancelAllOperations];
    self.queue = nil;
    
    self.conferences = nil;
    
    self.actLoadingList = nil;
    self.viewHeader = nil;
    
    [super viewDidUnload];
}

- (void) dealloc
{
    [self.queue cancelAllOperations];
    self.queue = nil;      
    self.conferences = nil;
    
    [actLoadingList release];
    [_viewHeader release];
    [_textLabel release];
    
    [super dealloc];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) loadConferences
{
      Reachability *reachability = [Reachability reachabilityForInternetConnection:self.confServer:self.confPort];    
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
   
    if (internetStatus != NotReachable) {
        //my web-dependent code
          [queue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    }
    else {
        NSString *msg = @"Conferences are not reachable! This requires Internet connectivity.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Problem" 
                                                        message:msg 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;

        //there-is-no-connection warning
    }
      [self.actLoadingList startAnimating];
    
    NSString *serverConfList=[self.confServer stringByAppendingString:SERVER_CONFERENCES_LIST_URL];
   
    NSLog(@"The serverGetList URL is:%@",serverConfList);
    DownloadOperation *oper = [[DownloadOperation alloc] initWithUrl:[NSURL URLWithString:serverConfList]];
    
    listConferencesOperation = oper;
    oper.delegate = self;
    [queue addOperation:oper];
    [oper release];
    loadConferencesCalled = YES;
}

-(void) fillConferenceList:(DownloadOperation*)operation{
    
    NSData *theData = [operation downloadedData];
    NSString *str = [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];
    
    listConferencesOperation = nil;
    
    [self.actLoadingList stopAnimating];
    
    NSError *err = nil;
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    id obj = [parser objectWithString:str error:&err];
    if (!obj)
    {
        [UIAlertView showAlertViewWithTitle:@"Error" message:[err localizedDescription]];
        return;
    }
    else
    {
        if (![obj isKindOfClass:[NSArray class]])
        {
            [UIAlertView showAlertViewWithTitle:@"Error" message:[NSString stringWithFormat:@"Not the type which the client expects, expected %@, but got %@", 
                NSStringFromClass([NSArray class]), NSStringFromClass([obj class])]];
            return;
        }
        
        NSLog(@"successfully parser: %@ of type: %@", obj, [obj class]);
    }
    
    NSArray *confs = (NSArray *)obj;
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:[confs count]];
    self.conferences = arr;
    [arr release];
    NSString *serverGetConference=[self.confServer stringByAppendingString:SERVER_GET_CONFERENCE_URL];
    for (NSDictionary *currServerInfo in confs)
    {
        ExtendedServerShortConferenceInfo *confInfo = [[ExtendedServerShortConferenceInfo alloc] init];
        confInfo.confId = [currServerInfo objectForKey:@"id"];
        confInfo.name = [currServerInfo objectForKey:@"name"];
        confInfo.venue = [currServerInfo objectForKey:@"venue"];
        confInfo.version = [[currServerInfo objectForKey:@"version"] intValue];
        confInfo.date = [currServerInfo objectForKey:@"dates"];
        confInfo.confDescription = [currServerInfo objectForKey:@"description"];
        // TODO: this must be removed later
        NSString *smallUrl = [currServerInfo objectForKey:@"smallLogo"];
        smallUrl = [smallUrl stringByReplacingOccurrencesOfString:@"100.png" withString:@"50.png" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [smallUrl length])];
        
        confInfo.smallImageUrl = [NSURL URLWithString:smallUrl];
        confInfo.bigImageUrl = [NSURL URLWithString:[currServerInfo objectForKey:@"largeLogo"]];
        confInfo.mapImageUrl = [NSURL URLWithString:[currServerInfo objectForKey:@"map"]];
        confInfo.confDataUrl = [NSURL URLWithString:[NSString stringWithFormat:serverGetConference, confInfo.confId]];
        
        [self.conferences addObject:confInfo];
        
        [confInfo release];
    }        
}


- (void) loadImagesForVisibleCells
{
   NSArray *cells = [self.tableView  visibleCells];
    
    [cells retain];
    
    for (int i = 0, cnt = [conferences count]; i < cnt; i++)
    {   
        UITableViewCell *cell = [cells objectAtIndex:i];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ExtendedServerShortConferenceInfo *confInfo = [conferences objectAtIndex:indexPath.section];
        
        if (![confInfo hasImage])
        {
            DownloadOperation *oper = [[DownloadOperation alloc] initWithUrl:confInfo.smallImageUrl];
            oper.delegate = self;
            oper.tag = [NSString stringWithFormat:@"%d", indexPath.section];
            [queue addOperation:oper];
            [oper release];
        }
    }
    
    [cells release];
    
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.conferences count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;//[self.conferences count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 10.0;
    return 10.0;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vv=[[UIView alloc]initWithFrame:CGRectMake(10,0,320,10.0)]; 
       vv.backgroundColor=[UIColor lightGrayColor];
      return vv;
}
*/


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConferenceTableViewCell *cell = (ConferenceTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:ConferenceTableViewCellIdentifier];
    if (cell == nil)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"ConferenceTableViewCell" owner:nil options:nil];
        
        for (id currObj in objects)
        {
            if ([currObj isKindOfClass:[ConferenceTableViewCell class]])
            {
                cell = currObj;
                break;
            }
        }
    }
    
    ExtendedServerShortConferenceInfo *confInfo = [conferences objectAtIndex:indexPath.section];
    [cell loadServerConferenceInfo:confInfo];
    //[self loadImagesForVisibleCells];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return ConferenceTableViewCellHeightIPad;
    }else{
        return ConferenceTableViewCellHeight;
    }

    return ConferenceTableViewCellHeight;
}
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //[self loadImagesForVisibleCells]; 
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) 
    {
       // [self loadImagesForVisibleCells]; 
    }
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ExtendedServerShortConferenceInfo *confInfo = [conferences objectAtIndex:indexPath.section];
    
    DownloadConferenceViewController *downloadVc = [[DownloadConferenceViewController alloc] initWithConferenceInfo:confInfo];
    [self.navigationController pushViewController:downloadVc animated:YES];
    [downloadVc release];
}

#pragma mark -
#pragma mark DownloadOperationDelegate methods

- (void) downloadOperationFailed:(DownloadOperation *)downloadOperation
{
    if (downloadOperation == listConferencesOperation)
    {
        NSLog(@"unable to get list conferences");
        [self.actLoadingList stopAnimating];
    }
    else // loading images
    {
        
    }
}

- (void) downloadOperationFinished:(DownloadOperation *)downloadOperation
{
    [self fillConferenceList:downloadOperation];
    [self.tableView reloadData];
    
}

@end