//
//  MiraPageViewController.m
//  ConfComp
//
//  Created by Petko Yanakiev on 1/13/12.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.

#import "MiraPageViewController.h"
#import "MainViewController.h"
#import "ConfSearchViewController.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "ConfSession.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+CommonClass.h"
#import "ConferenceController.h"

#import "Utils.h"

@implementation MiraPageViewController

@synthesize view1;
@synthesize view2;
@synthesize view3;
@synthesize labelWho;
@synthesize labelTitle;
@synthesize textViewWho;
@synthesize labelWhat;
@synthesize textViewWhat;
@synthesize labelConf;
@synthesize textViewConf,isChecked,scrollView,webView;

- (id) initWithMiraPageController:(ConferenceController *)conferenceController{
    
    if ((self = [super initWithNibName:@"MiraPageViewController" bundle:[NSBundle mainBundle]]))
    {
        confController = conferenceController;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[[self.navigationController navigationBar] resetBackground:8765309];
}

-(void) viewWillAppear:(BOOL)animated {
    
  // [[self.navigationController navigationBar] resetBackground:8765309];
    
    UIImage *backgroundImage = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        backgroundImage = [UIImage imageNamed:@"background_mira_navbar_ipad"];
    }else{ backgroundImage = [UIImage imageNamed:@"background_mira_navbar"]; 
    }
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675308];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    
       [[self.navigationController navigationBar] resetBackground:8765308];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    //[self importCommonView:confController];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [scrollView setContentSize:CGSizeMake(768, 1300)];
    }else{
        [scrollView setContentSize:CGSizeMake(320, 600)];
    }
    self.webView.delegate=self;
    CALayer *l = [view1 layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    
    CALayer *l2 = [view2 layer];
    [l2 setMasksToBounds:YES];
    [l2 setCornerRadius:10.0];
    
    CALayer *l3 = [view3 layer];
    [l3 setMasksToBounds:YES];
    [l3 setCornerRadius:10.0];
    
    labelWho.text=@"Who We Are:";
    labelWho.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        labelWho.font=[UIFont boldSystemFontOfSize:18.0];
    }else{
        labelWho.font=[UIFont boldSystemFontOfSize:14.0];
    }

    //labelTitle.text=@"Mira Digital Publishing";
    labelTitle.textColor=[UIColor blackColor];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        labelTitle.font=[UIFont boldSystemFontOfSize:16.0];
    }else{
        labelTitle.font=[UIFont boldSystemFontOfSize:14.0];
    }
    
    //second section here.
    labelWhat.text=@"What We Do:";
    labelWhat.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        labelWhat.font=[UIFont boldSystemFontOfSize:16.0];
    }else{
        labelWhat.font=[UIFont boldSystemFontOfSize:14.0];
    }
    
    labelConf.text=@"Conference 411:";
    labelConf.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
         labelConf.font=[UIFont boldSystemFontOfSize:16.0];
     }else{
          labelConf.font=[UIFont boldSystemFontOfSize:14.0];
     }
    
    textViewWho.text=@"1010 Hanley Industrial Court\nBrentwood,MO 63144\nP:866 341 9588\nW: mirasmart.com";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        textViewWho.font=[UIFont boldSystemFontOfSize:18.0];
    }else{
        textViewWho.font=[UIFont boldSystemFontOfSize:12.0];
    }
    textViewWhat.text=@"Mira has worked with the conference industry ever since 1990, providing our clients with conference CDs/DVDs, flash drives, books, posters and website hosting,along with supplemental or stand-alone journals. From concept to finished product, printing and graphic design, we are your one stop shop.";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        textViewWhat.font=[UIFont systemFontOfSize:18.0];   
    }else{
        textViewWhat.font=[UIFont systemFontOfSize:12.0];    
    }
    
    // VERIFY
    NSURL *fileUrl = nil;
    fileUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
    [self.webView loadRequest:request];
    [Utils addSkipBackupAttributeToItemAtURL:fileUrl];
    
    textViewConf.font=[UIFont systemFontOfSize:11.0];
    [webView setOpaque:NO];
    webView.backgroundColor=[UIColor clearColor];
    
    [(UIScrollView*)[webView.subviews objectAtIndex:0] setShowsHorizontalScrollIndicator:NO];
    [(UIScrollView*)[webView.subviews objectAtIndex:0] setShowsVerticalScrollIndicator:NO];
    [(UIScrollView*)[webView.subviews objectAtIndex:0] 
     setScrollEnabled:NO];
    webView.delegate=self;
    
}

- (void) viewDidUnload
{
       [super viewDidUnload];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
-(IBAction)searchButtonClicked:(id)sender{
    
    ConfSearchViewController *searchVc = [[ConfSearchViewController alloc] initWithConferenceController:confController];
    [self.navigationController pushViewController:searchVc animated:YES];
    [searchVc release];
}*/

-(BOOL)webView:(UIWebView *)descriptionTextView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (UIWebViewNavigationTypeLinkClicked == navigationType) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

- (void) dealloc
{
    [view1 release];
    [view2 release];
    [view3 release];
    [labelWho release];
    [labelTitle release];
    [textViewWho release];
    [labelWhat release];
    [textViewWhat release];
    [labelConf release];
    [textViewConf release];
    [super dealloc];
}

@end
