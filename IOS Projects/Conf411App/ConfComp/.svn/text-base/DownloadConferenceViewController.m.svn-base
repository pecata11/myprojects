//
//  DownloadConferenceViewController.m
//  ConfComp
//
//  Created by Anto  XX on 10/19/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "DownloadConferenceViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "ServerShortConferenceInfo.h"
#import "ExtendedServerShortConferenceInfo.h"
#import "AllConfsController.h"
#import "ConferenceTableViewCell.h"
#import "ConferenceInfoTableViewCell.h"
#import "UINavigationBar+UINavigationBarCategory.h"

@interface DownloadConferenceViewController ()

@property (nonatomic, retain) NSOperationQueue *queue;

- (void) addObservers;
- (void) removeObservers;

- (void) confDidDownload:(NSNotification *)notification;
- (void) confDidFailDownloading:(NSNotification *)notification;

@end

@implementation DownloadConferenceViewController

@synthesize btnDownload = _btnDownload;
@synthesize imgViewLogo = _imgViewLogo;
@synthesize lblConferenceName = _lblConferenceName;
@synthesize txtConferenceDescription = _txtConferenceDescription;
@synthesize lblDownloadStatus = _lblDownloadStatus;
@synthesize actDownloading = _actDownloading;
@synthesize actImageDownloading = _actImageDownloading;
@synthesize queue = _queue;
@synthesize lblGoBackDescr = _lblGoBackDescr;
@synthesize tableView=_tableView;

- (id) initWithConferenceInfo:(ExtendedServerShortConferenceInfo *)inConferenceInfo
{
    if ((self = [super initWithNibName:@"DownloadConferenceViewController" bundle:[NSBundle mainBundle]]))
    {
        conferenceInfo = [inConferenceInfo retain];
        observationsAdded = NO;
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

- (void) addObservers
{
    if (!observationsAdded)
    {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        AllConfsController *confsController = [AllConfsController sharedConferencesController];
        
        [center addObserver:self 
                   selector:@selector(confDidDownload:) 
                       name:AllConfsControllerDidDownloadConference 
                     object:confsController];
        [center addObserver:self 
                   selector:@selector(confDidFailDownloading:) 
                       name:AllConfsControllerDidFailDownloadingConference 
                     object:confsController];
        
        observationsAdded = YES;
    }
}

- (void) removeObservers
{
    if (observationsAdded)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        observationsAdded = NO;
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.tableView respondsToSelector:@selector(setBackgroundView:)]) {
        [self.tableView setBackgroundView:nil];
    }
    self.tableView.backgroundColor = [UIColor clearColor];
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    self.queue = q;
    [q release];
    
    [self.queue setMaxConcurrentOperationCount:1];
    
    self.lblConferenceName.layer.cornerRadius = 10.0;
    self.lblConferenceName.text = conferenceInfo.name;
    
    self.txtConferenceDescription.text = conferenceInfo.confDescription;
    
    AllConfsController *confsController = [AllConfsController sharedConferencesController];
    self.btnDownload.hidden = [confsController conferenceDownloaded:conferenceInfo];
    self.lblDownloadStatus.hidden = !self.btnDownload.hidden;
    
    DownloadOperation *oper = [[DownloadOperation alloc] initWithUrl:conferenceInfo.smallImageUrl];

    oper.delegate = self;
    [self.queue addOperation:oper];
    [oper release];
    
    [self.actImageDownloading startAnimating];
}

-(void) viewWillAppear:(BOOL)animated {
    
    UIImage *backgroundImage = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        backgroundImage = [UIImage imageNamed:@"background_navbar_confinfo_ipad"];
    }
    else
    {
        backgroundImage = [UIImage imageNamed:@"background_navbar_confinfo"];
    }

    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675327];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self.navigationController navigationBar] resetBackground:8675327];
}

- (void) btnDownloadPressed:(id)sender
{
    [self.actDownloading startAnimating];
    self.lblDownloadStatus.text = @"Downloading...";
    self.lblDownloadStatus.hidden = NO;
    self.btnDownload.hidden = YES;
    
    [self addObservers];
    
    [[AllConfsController sharedConferencesController] downloadConference:conferenceInfo];
}

- (void) confDidDownload:(NSNotification *)notification
{
    ServerShortConferenceInfo *downloadedConf = [[notification userInfo] valueForKey:AllConfsControllerDidDownloadConference_ConferenceKey];
    
    if (downloadedConf == conferenceInfo)
    {
        self.lblDownloadStatus.text = @"Successfully Downloaded!";
        self.lblGoBackDescr.hidden = NO;
        [self.actDownloading stopAnimating];
    }
}

- (void) confDidFailDownloading:(NSNotification *)notification
{
    ServerShortConferenceInfo *failedConf = [[notification userInfo] valueForKey:AllConfsControllerDidFailDownloadingConference_ConferenceKey];
    
    if (failedConf == conferenceInfo)
    {
        self.lblDownloadStatus.text = @"Download failed!";
        [self.actDownloading stopAnimating];
        self.btnDownload.hidden = NO;
    }
}

- (void) viewDidUnload
{
    [self removeObservers];
    
    [self.queue cancelAllOperations];
    self.queue = nil;
    
    self.btnDownload = nil;
    self.imgViewLogo = nil;
    self.lblConferenceName = nil;
    self.txtConferenceDescription = nil;
    self.lblDownloadStatus = nil;
    self.actDownloading = nil;
    self.actImageDownloading = nil;
    self.lblGoBackDescr = nil;

    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;//[self.conferences count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if (section == 0)
            return 20.0;
        else return 10.0;
    }else{
        if (section == 0)
            return 20.0;
        else return 1.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
       return 30.0;
    }else{
        return 3.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell * cell=nil;
  if(indexPath.section == 0)
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
    
        // ExtendedServerShortConferenceInfo *confInfo = [conferences objectAtIndex:indexPath.section];
        //conferenceInfo.
        //NSLog(@"the name is:%@",conferenceInfo.name);
    
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell loadServerConferenceInfo:conferenceInfo];
        return cell;
  }
  else
  {
    
     ConferenceInfoTableViewCell *cell = (ConferenceInfoTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:ConferenceTableViewCellIdentifier];
     if (cell == nil)
     {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"ConferenceInfoTableViewCell" owner:nil options:nil];
        
        for (id currObj in objects)
        {
            if ([currObj isKindOfClass:[ConferenceInfoTableViewCell class]])
            {
                cell = currObj;
                break;
            }
         }
     }
    
    // ExtendedServerShortConferenceInfo *confInfo = [conferences objectAtIndex:indexPath.section];
    //conferenceInfo.
    //NSLog(@"the name is:%@",conferenceInfo.name);
    
    
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.accessoryType = UITableViewCellAccessoryNone;
     [cell loadServerInfoConferenceInfo:conferenceInfo];
     return cell;
  }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            return ConferenceTableViewCellHeightIPad;
        }else{
            return ConferenceTableViewCellHeight;
        }      
    }
    else
    {
        
        return ConferenceInfoTableViewCellHeight;
    }
}
/*
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.viewHeader;
}
*/


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc
{
    [self removeObservers];
    
    [self.queue cancelAllOperations];
    self.queue = nil;
    
    [_btnDownload release];
    [_imgViewLogo release];
    [_lblConferenceName release];
    [_txtConferenceDescription release];
    [_lblDownloadStatus release];
    [_actDownloading release];
    [_actImageDownloading release];
    [_lblGoBackDescr release];
    [_tableView release];
    
    [conferenceInfo release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark DownloadOperationDelegate methods

- (void) downloadOperationFailed:(DownloadOperation *)downloadOperation
{
    [self.actImageDownloading stopAnimating];
}

- (void) downloadOperationFinished:(DownloadOperation *)downloadOperation
{
    [self.actImageDownloading stopAnimating];
    
    UIImage *img = [UIImage imageWithData:downloadOperation.downloadedData];
    self.imgViewLogo.image = img;
    
    CALayer * l = [self.imgViewLogo layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
}

@end
