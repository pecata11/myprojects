//
//  InfoViewController.m
//  ConfComp
//
//  Created by Antoan Tateosian on 17.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "InfoViewController.h"
#import "MiraPageViewController.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "Utils.h"

@implementation InfoViewController

@synthesize webView = _webView;
@synthesize actView = _actView;
@synthesize localCopyOfFile;

- (id) initWithUrl:(NSURL *)inUrl:(NSInteger)local:(ConferenceController*) conferenceController
{
    if ((self = [super initWithNibName:@"InfoViewController" bundle:[NSBundle mainBundle]]))
    {
        url = [inUrl retain];
        localCopyOfFile=local;
        confController=conferenceController;
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
    
    [self.actView startAnimating];
    self.webView.backgroundColor=[UIColor whiteColor];
    [self.webView setOpaque:NO];
    //webView.showsVerticalScrollIndicator=NO;
    //webView.showsHorizontalScrollIndicator=NO;
    self.webView.delegate=self;
    
    [(UIScrollView*)[self.webView.subviews objectAtIndex:0] setShowsHorizontalScrollIndicator:NO];
    [(UIScrollView*)[self.webView.subviews objectAtIndex:0] setShowsVerticalScrollIndicator:NO];
    
        NSString *dirPath= [Utils documentsDirectory];
        NSString * foofile = [dirPath stringByAppendingPathComponent:@"GettingStared.pdf"];
        NSURL *urlF = [NSURL fileURLWithPath:foofile];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlF];
        [self.webView loadRequest:requestObj];
    [Utils addSkipBackupAttributeToItemAtURL:urlF];

    
}

-(void) viewWillAppear:(BOOL)animated {
       
    UIImage *backgroundImage = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        backgroundImage = [UIImage imageNamed:@"background_getstarted_navbar_ipad"];
    }
    else{
        backgroundImage = [UIImage imageNamed:@"background_getstarted_navbar"];
    }

    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675328];
    }

}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self.navigationController navigationBar] resetBackground:8675328];
}

- (void) btnLinkPressed:(id)sender
{
    MiraPageViewController *infoVc = [[MiraPageViewController alloc]initWithMiraPageController:confController];
    [self.navigationController pushViewController:infoVc animated:YES];
    [infoVc release];
}

- (void) viewDidUnload
{
    self.webView = nil;
    self.actView = nil;
    
    [super viewDidUnload];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc
{
    [url release];
    [_webView release];
    [_actView release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark UIWebViewDelegate methods

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.actView stopAnimating];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self.actView stopAnimating];
}

@end
