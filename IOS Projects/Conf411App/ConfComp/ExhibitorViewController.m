//
//  ExhibitorViewController.m
//  ConfComp
//
//  Created by Antoan Tateosian on 29.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "ExhibitorViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "Exhibitor.h"
#import "Place.h"
#import "ConferenceController.h"
#import "ConferenceMapViewController.h"
#import "ServerShortConferenceInfo.h"
#import "Sponsor.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "UIViewController+CommonClass.h"

@implementation ExhibitorViewController

@synthesize companyLabel=_companyLabel;
@synthesize companyText=_companyText;
@synthesize descriptionLabel=_descriptionLabel;
@synthesize descriptionText=_descriptionText;
@synthesize websiteLabel=_websiteLabel;
@synthesize websiteText=_websiteText;
@synthesize locationLabel=_locationLabel;
@synthesize locationText=_locationText;
@synthesize view1;
@synthesize view2;
@synthesize view3;
@synthesize view4;
@synthesize scrollView;

- (id) initWithExhibitor:(Exhibitor *)inExhibitor conferenceController:(ConferenceController *)conferenceController
{
    if ((self = [super initWithNibName:@"Exhibitor" bundle:[NSBundle mainBundle]]))
    {
        exhibitor = [inExhibitor retain];
        confController = conferenceController;
    }
    
    return self;
}

- (id) initWithSponsor:(Sponsor *)inSponsor conferenceController:(ConferenceController *)conferenceController
{
    if ((self = [super initWithNibName:@"Exhibitor" bundle:[NSBundle mainBundle]]))
    {
        sponsor = [inSponsor retain];
        confController = conferenceController;
    }
    
    return self;
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
    [self importCommonView:confController];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [scrollView setContentSize:CGSizeMake(768, 900)];

    }else{
        [scrollView setContentSize:CGSizeMake(320, 416)];
    }

    CALayer *l = [view1 layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    
    CALayer *l2 = [view2 layer];
    [l2 setMasksToBounds:YES];
    [l2 setCornerRadius:10.0];
    
    CALayer *l3 = [view3 layer];
    [l3 setMasksToBounds:YES];
    [l3 setCornerRadius:10.0];
    
    CALayer *l4 = [view4 layer];
    [l4 setMasksToBounds:YES];
    [l4 setCornerRadius:10.0];
    
     self.companyLabel.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.companyLabel.font=[UIFont boldSystemFontOfSize:18.0];
        self.locationLabel.font=[UIFont boldSystemFontOfSize:18.0];
        self.descriptionLabel.font = [UIFont boldSystemFontOfSize:16.0];
        self.descriptionText.font = [UIFont systemFontOfSize:14.0];
        self.websiteLabel.font = [UIFont boldSystemFontOfSize:18.0];
        self.websiteText.titleLabel.font =[UIFont boldSystemFontOfSize:16.0];
    }else{
         self.companyLabel.font=[UIFont boldSystemFontOfSize:15.0];
        self.locationLabel.font=[UIFont boldSystemFontOfSize:15.0];
        self.descriptionLabel.font = [UIFont boldSystemFontOfSize:15.0];
        self.descriptionText.font = [UIFont systemFontOfSize:12.0];
        self.websiteLabel.font = [UIFont boldSystemFontOfSize:15.0];
        self.websiteText.titleLabel.font =[UIFont boldSystemFontOfSize:13.0];
    }
     self.companyText.text = exhibitor.name;
     self.locationLabel.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
     self.locationText.text = exhibitor.place.name;
     self.descriptionLabel.textColor = [UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
     self.descriptionText.text = exhibitor.descr;
     self.websiteLabel.textColor = [UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
         self.websiteText.titleLabel.textColor = [UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
     [self.websiteText setTitle:exhibitor.urlAddress forState:UIControlStateNormal];
   }


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    
    UIImage *backgroundImage = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        backgroundImage = [UIImage imageNamed:@"background_navbar_expoinfo_ipad"];
    }else{ backgroundImage = [UIImage imageNamed:@"background_navbar_expoinfo"]; 
    }

    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675343];
    }
    
    //[self.tableView reloadData];
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self.navigationController navigationBar] resetBackground:8675343];
}

- (void) btnShowOnMapPressed:(id)sender
{
    ServerShortConferenceInfo *confInfo = [confController conference];
    ConferenceMapViewController *mapVc = [[ConferenceMapViewController alloc] initWithMapImage:confInfo.mapImage:confController];
    [mapVc view];
    [mapVc markPlace:exhibitor.place];
    [self.navigationController pushViewController:mapVc animated:YES];
    [mapVc release];
}

- (void) btnUrlPressed:(id)sender
{
    NSString *url = exhibitor.urlAddress;
    
    if (![url hasPrefix:@"http://"])
    {
        url = [NSString stringWithFormat:@"http://%@", url];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void) viewDidUnload
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

- (void) dealloc
{
    [exhibitor release];
    [sponsor release];
    [_companyLabel release];
    [_companyText release];
    [_descriptionLabel release];
    [_descriptionText release];
    [_websiteLabel release];
    [_websiteText release];
    [_locationLabel release];
    [_locationText release];
    [view1 release];
    [view2 release];
    [view3 release];
    [view4 release];
    [scrollView release];
    [super dealloc];
}

@end
