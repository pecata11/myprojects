//
//  MainViewController.m
//  ConfComp
//
//  Created by Anto  XX on 10/17/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "MainViewController.h"
#import "AllConfsController.h"
#import "InfoViewController.h"
#import "ServerConferencesViewController.h"
#import "ConferenceViewController.h"
#import "MiraPageViewController.h"
#import "ServerShortConferenceInfo.h"
#import "ExtendedServerShortConferenceInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+Property.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "Reachability.h"
#import "Constants.h"
#import "SBJson.h"
#import "Utils.h"
#import "UIAlertView-Helpers.h"

#define kXOffsetIPad 160
#define kYOffsetIPad 160
#define kXOffset 70
#define kYOffset 70
#define imViewWidth 55
#define imViewHeight 55
#define imViewHeightiPad 95
#define imViewWidthiPad 95


@interface MainViewController ()

- (void) addObservers;
- (void) removeObservers;
- (void)makeUpdate:(ExtendedServerShortConferenceInfo*)conferenceInfo:(int)version;
- (void) arrangeConferencesImages;

- (void)constructDeleteButton:(UIView *)bView button:(UIButton *)button;
- (UIButton *)constructConferenceButton:(UIImage *)thumb 
                            confInfo:(ExtendedServerShortConferenceInfo *)confInfo 
                            i:(int)i bView:(UIView *)bView;

-(NSURL*) getPDFFromServer:(NSString *)serverGetStartedPDF dirPath:(NSString *)dirPath;
-(NSURL*) getPDFFromLocalStore:(NSString *)dirPath;
-(NSURL*) getPDFDocument:(InetStatus)inetStatus;
-(NSURL*) loadGettingStartedPDF;

@property (nonatomic, retain) NSOperationQueue *queue;
@end

@implementation MainViewController

@synthesize scrollView=_scrollView;
@synthesize globalObject;
@synthesize tempView;
@synthesize deleted;
@synthesize delTags;
@synthesize queue;
@synthesize PDFURL;
@synthesize localURL;
@synthesize confServer;
@synthesize confPort;

- (void) didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)longPressGestureRecognizerStateChanged:(UIGestureRecognizer *)gestureRecognizer {
    
    switch (gestureRecognizer.state) {
            
        case UIGestureRecognizerStateEnded: {
            
            deleted = TRUE;
            [self arrangeConferencesImages];
            break;
        }
        default:
            break;
    }
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *server = [defaults stringForKey:@"confServer"];
    NSString *port=[defaults stringForKey:@"confPort"];
    self.confServer=server;
    self.confPort=[port intValue];
    //NSLog(@"The read server value is:%@",self.confServer);
    //NSLog(@"The read port value is:%d",self.confPort);
    observationsAdded = NO;
    self.navigationItem.hidesBackButton=YES;
    [self addObservers]; 
    delTags = [[NSMutableArray alloc] init];
    deleted = FALSE;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSUInteger numTaps = [[touches anyObject] tapCount];
    if (numTaps == 2) 
    {
        deleted = FALSE;
        [self arrangeConferencesImages];
    }
}

- (void)constructDeleteButton:(UIView *)bView button:(UIButton *)button 
{
    UIButton *del=nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        del = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    }
    else{
        del = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)]; 
    }
    [del setBackgroundImage:[UIImage imageNamed:@"closedRed"] forState:UIControlStateNormal];
    [del addTarget:self action:@selector(deleteConf:) forControlEvents:UIControlEventTouchUpInside];
    //del.tag=0;
    del.tag=bView.tag;
    del.property=button.property;
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [anim setToValue:[NSNumber numberWithFloat:0.0f]];
    [anim setFromValue:[NSNumber numberWithDouble:M_PI/64]];
    [anim setDuration:0.1];
    [anim setRepeatCount:NSUIntegerMax];
    [anim setAutoreverses:YES];
    [button.layer addAnimation:anim forKey:@"SpringboardShake"];
    [button addSubview:del];
    [bView bringSubviewToFront:del];
    [del release];
}

- (UIButton *)constructConferenceButton:(UIImage *)thumb confInfo:(ExtendedServerShortConferenceInfo *)confInfo i:(int)i bView:(UIView *)bView
{
    //set the button with the image of conference here.
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        button.frame = CGRectMake(3, 3, imViewWidthiPad-5, imViewHeightiPad-5);
    }
    else{
        button.frame = CGRectMake(3, 3, imViewWidth-5, imViewHeight-5);
    }
    CALayer * l = [button layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:8.0];
    [button setImage:thumb forState:UIControlStateNormal];
    
    button.property = confInfo;
    [button addTarget:self 
               action:@selector(buttonClicked:) 
     forControlEvents:UIControlEventTouchUpInside];
    button.tag = i; 
    bView.tag = i+1;
    
    //Add gesture recognizer to be used for deletion of conference.
    UILongPressGestureRecognizer *pahGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerStateChanged:)];
    
    pahGestureRecognizer.minimumPressDuration = 1.0;
    //[bView addGestureRecognizer:pahGestureRecognizer];
    [button addGestureRecognizer:pahGestureRecognizer];
    [pahGestureRecognizer release];
    return button;
}

-(void) arrangeConferencesImages{
    
    AllConfsController *confsController = [AllConfsController sharedConferencesController];
    NSInteger numCached = [[AllConfsController sharedConferencesController] numberOfCachedConferences];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(80,20,768,740)];   
    }
    else{
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20,20,320,243)];  
    }
    int row = 0;
	int column = 0;

	for(int i = 0; i < numCached; ++i) 
    {
		ExtendedServerShortConferenceInfo *confInfo = [[confsController downloadedConferences] objectAtIndex:i];
		UIImage *thumb = confInfo.image;
        UIView *bView=nil;
         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
             bView = [[UIView alloc]initWithFrame:(CGRectMake(column*kXOffsetIPad, row*kYOffsetIPad,imViewWidthiPad,imViewHeightiPad))];
         }
         else{
              bView = [[UIView alloc]initWithFrame:(CGRectMake(column*kXOffset, row*kYOffset,imViewWidth,imViewHeight))];
         }
        bView.backgroundColor = [UIColor whiteColor];
       
        UIButton *button;
        button = [self constructConferenceButton:thumb confInfo:confInfo i:i bView:bView];
        
        if(deleted){
            [self constructDeleteButton:bView button:button];
        }
        [bView addSubview:button];
        [scrollView addSubview:bView];
        [bView release];

		if (column == 3){
			column = 0;
			row++;
		} 
        else {
			column++;
		}
	}
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [scrollView setContentSize:CGSizeMake(768, (row+1) * 150)];
    }
    else{
        [scrollView setContentSize:CGSizeMake(320, (row+1) * 70)];
    }
    [self.view addSubview:scrollView];
    [scrollView setNeedsDisplay];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        AllConfsController *confsController = [AllConfsController sharedConferencesController];
        ExtendedServerShortConferenceInfo *cInfo = (ExtendedServerShortConferenceInfo*)self.globalObject;
        [confsController deleteConference:cInfo];

       for(UIView *subview in [self.view subviews]) {
            if([subview isKindOfClass:[UIScrollView class]]){
               [subview removeFromSuperview]; 
            }
        }
        [self arrangeConferencesImages];
        
        //[confsController release];
        //[cInfo release];
    }        
    else
    {
       
    }
}

-(IBAction)deleteConf:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    self.globalObject=nil;
    self.globalObject=(ExtendedServerShortConferenceInfo*)button.property;
    // create a simple alert with an OK and cancel button
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Do you really want to delete this conference?"
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"Delete"
                          otherButtonTitles:@"Cancel", nil];
    [alert show];
    [alert release];
}

- (IBAction)buttonClicked:(id)sender {
    
	UIButton *button = (UIButton *)sender;
    ExtendedServerShortConferenceInfo *cInfo=(ExtendedServerShortConferenceInfo*)button.property;
    ConferenceViewController *confVc = [[ConferenceViewController alloc] initWithConference:cInfo];
    [self.navigationController pushViewController:confVc animated:YES];
    //[cInfo release];
    [confVc release];
}

- (void) addObservers
{
    if (!observationsAdded)
    {        
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

-(void) viewWillAppear:(BOOL)animated {

    UIImage *backgroundImage = nil;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        backgroundImage = [UIImage imageNamed:@"background_confernce_import_logo_ipad"];
    }
    else{
        backgroundImage = [UIImage imageNamed:@"background_confernce_import_logo"]; 
    }

    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
        UIButton *dButton=[UIButton buttonWithType:UIButtonTypeCustom];
        dButton.frame=CGRectMake(10,0,40,25);
        [dButton addTarget:self  action:@selector(miraButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        [dButton setImage:[UIImage imageNamed:@"mira_small.png"]
                 forState:UIControlStateNormal];  
        UIBarButtonItem *rightButton=[[UIBarButtonItem alloc] initWithCustomView:dButton];
        self.navigationItem.rightBarButtonItem = rightButton;
        [rightButton release];
    }
    else{
        
      [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675325];
        
        UIButton *dButton=[UIButton buttonWithType:UIButtonTypeCustom];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            dButton.frame=CGRectMake(700,10,40,25);

        }
        else{
            dButton.frame=CGRectMake(270,10,40,25);
        }
        
        [dButton addTarget:self action:@selector(miraButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        [dButton setImage:[UIImage imageNamed:@"mira_small.png"]
                 forState:UIControlStateNormal];  
        
        [[self.navigationController navigationBar] 
            setRightButton:dButton withTag:8675380];
    }
    //[backgroundImage release];
    deleted=FALSE;
    [self arrangeConferencesImages];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[self.navigationController navigationBar] resetBackground:8765325];
    [[self.navigationController navigationBar] resetBackground:8675380];
}

- (void) viewDidUnload
{
    [self removeObservers];
    [super viewDidUnload];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc
{
    [self removeObservers];
    [scrollView release];
    [delTags release];
    [tempView release];
    [PDFURL release];
    [queue release];
    [super dealloc];
}

-(IBAction)miraButtonClicked:(id)sender{
      
    MiraPageViewController *infoVc = [[MiraPageViewController alloc] initWithMiraPageController:confController];
    [self.navigationController pushViewController:infoVc animated:YES];
    [infoVc release];

}
-(IBAction)importButtonClicked:(id)sender{
    
    ServerConferencesViewController *confVc = [[ServerConferencesViewController alloc] init];
    [self.navigationController pushViewController:confVc animated:YES];
    [confVc release];
    
}

-(IBAction)getstartedButtonClicked:(id)sender{
      
    InfoViewController *infoVc = nil;
    self.PDFURL = [self loadGettingStartedPDF];
    [Utils addSkipBackupAttributeToItemAtURL:self.PDFURL];
    infoVc = [[InfoViewController alloc]initWithUrl:self.PDFURL:0:confController];
    
    [self.navigationController pushViewController:infoVc animated:YES];
    [infoVc release];
}

-(void)makeUpdate:(ExtendedServerShortConferenceInfo*)conferenceInfo:(int)version{
       
    int serverVersion=[Utils getServerVersion:self.confServer:conferenceInfo];
    AllConfsController *confsController = [AllConfsController sharedConferencesController];
    if (serverVersion > version)
    {
        //NSLog(@"There is new version of %@ conference. Update is required", conferenceInfo.confId);
        [confsController deleteConference:conferenceInfo];
        //NSLog(@"Deleted");
        [confsController downloadConference:conferenceInfo];
    }
    else{
        //NSLog(@"Conference %@ is up-to-date", conferenceInfo.confId);
    }
}

-(IBAction)updateButonClicked:(id)sender
{    
    AllConfsController *confsController = [AllConfsController sharedConferencesController];
    
    for (int i = 0; i < [confsController numberOfCachedConferences]; i++)
    {
        ExtendedServerShortConferenceInfo *confInfo = [[confsController 
                                                    downloadedConferences] objectAtIndex:i];
          [Utils enrichConferenceObject:self.confServer:confInfo];  
          [self makeUpdate:confInfo:confInfo.version];
    }
    [UIAlertView showAlertViewWithTitle:@"Info" message:[NSString stringWithFormat:@"Conferences succesfully updated"]];
}


- (NSURL*) loadGettingStartedPDF
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection:self.confServer:self.confPort];    
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSURL* pdfURL=nil;
    InetStatus status;
    if (internetStatus != NotReachable) {
        //my web-dependent code
        [queue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
        status = online;
        pdfURL = [self getPDFDocument:status];
    }
    else 
    {   
        status = offline;
        pdfURL = [self getPDFDocument:status];
    }
    [Utils addSkipBackupAttributeToItemAtURL:PDFURL];
    return pdfURL;
}

- (NSURL *)getPDFFromServer:(NSString *)serverGetStartedPDF dirPath:(NSString *)dirPath
{
    NSURL *url=[[NSURL alloc]initWithString:serverGetStartedPDF];
    NSData *theData=[[NSData alloc]initWithContentsOfURL:url];
    NSString *str = [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];
    [url release];
    [theData release];
    NSError *err = nil;
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    id obj = [parser objectWithString:str error:&err];
    
    NSString *path = (NSString *)obj;
    NSString *PDFPath = [path valueForKey:@"gettingStarted"];
    if(PDFPath != nil)
    {
        NSURL *urlp = [[[NSURL alloc] initWithString:PDFPath]autorelease];
        [Utils addSkipBackupAttributeToItemAtURL:urlp];
        NSData* PDFData=[[NSData alloc] initWithContentsOfURL:urlp];
        if(PDFData)
        {
            // VERIFY
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", dirPath,@"GettingStared.pdf"];
            [PDFData writeToFile:filePath atomically:YES];
            [Utils addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:filePath]];
        }
        [PDFData release];
        return urlp;
    }else{
        return nil;
    }
}

- (NSURL *)getPDFFromLocalStore:(NSString *)dirPath
{
    NSString *filePath = [dirPath 
                          stringByAppendingPathComponent:@"GettingStarted.pdf"];    
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath]; 
    return fileUrl;
}

-(NSURL *) getPDFDocument:(InetStatus)inetStatus
{
    NSString *dirPath= [Utils documentsDirectory];
    NSString *serverGetStartedPDF = [self.confServer stringByAppendingString:GETTING_STARTED_PDF_URL];
    NSURL *pdfURL=nil;
    if(inetStatus == online)
    {
        pdfURL = [self getPDFFromServer:serverGetStartedPDF dirPath:dirPath];
    }
    else if(inetStatus == offline)
    {
       pdfURL = [self getPDFFromLocalStore:dirPath];
    }
    return pdfURL;
}

@end