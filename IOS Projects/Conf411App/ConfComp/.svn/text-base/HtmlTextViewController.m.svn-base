//
//  HtmlTextViewController.m
//  ConfComp
//
//  Created by Antoan Tateosian on 29.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "HtmlTextViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIAlertView-Helpers.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "ConferenceController.h"
#import "UIViewController+CommonClass.h"

@implementation HtmlTextViewController

@synthesize webView = _webView;
@synthesize actView = _actView;
@synthesize lblStaticText =_lblStaticText;
@synthesize lblConfName =_lblConfName;
@synthesize view1=_view1;
@synthesize confName=_confName;

- (id) initWithHtmlString:(NSString *)string:(NSString*)name:(ConferenceController*)conferenceController
{
    if ((self = [super initWithNibName:@"HtmlText" bundle:[NSBundle mainBundle]]))
    {
        htmlString = [string retain];
        confController=conferenceController;
        self.confName=name;
    }
    //[lblConfName setText:confName];
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [htmlString release];
    [_webView release];
    [_actView release];
    [_lblConfName release];
    [_lblStaticText release];
    [_view1 release];
    [_confName release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self importCommonView:confController];
    [self.lblConfName setText:self.confName];
    [self.actView startAnimating];
    //[self.webView loadHTMLString:htmlString baseURL:nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.lblStaticText.font=
                [UIFont boldSystemFontOfSize:19.0];
        self.lblConfName.font=
                [UIFont boldSystemFontOfSize:18.0];
        
    }
    else
    {
        self.lblStaticText.font=
                [UIFont boldSystemFontOfSize:14.0];
        self.lblConfName.font=
                [UIFont boldSystemFontOfSize:14.0];
    }
    self.lblStaticText.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
     
    CALayer *l1 = [self.view1 layer];
    [l1 setMasksToBounds:YES];
    [l1 setCornerRadius:10.0];
    
    
    NSURL *url= [[NSURL alloc] initWithString:htmlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [url release];
    [self.webView loadRequest:request];
    self.webView.backgroundColor=[UIColor whiteColor];
    [self.webView setOpaque:NO];
    self.webView.delegate=self;

    [(UIScrollView*)[self.webView.subviews objectAtIndex:0] setShowsHorizontalScrollIndicator:NO];
    [(UIScrollView*)[self.webView.subviews objectAtIndex:0] setShowsVerticalScrollIndicator:NO];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidUnload
{
    self.webView = nil;
    self.actView = nil;
    
    [super viewDidUnload];
}
-(void) viewWillAppear:(BOOL)animated {
    
    UIImage *backgroundImage = nil;

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        backgroundImage = [UIImage imageNamed:@"background_navbar_info_ipad"];
    }
    else{
        backgroundImage = [UIImage imageNamed:@"background_navbar_info"]; 
    }
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675350];
    }
    
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [[self.navigationController navigationBar] resetBackground:8765350];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UIWebViewDelegate methods

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self.actView stopAnimating];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.actView stopAnimating];
    
    //[UIAlertView showAlertViewWithTitle:@"Error" message:[error localizedDescription]];
}

@end
