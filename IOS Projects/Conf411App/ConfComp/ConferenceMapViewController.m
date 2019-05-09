//
//  ConferenceMapViewController.m
//  ConfComp
//
//  Created by Petko Yanakiev.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "ConferenceMapViewController.h"

#import "Place.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "UIViewController+CommonClass.h"

@interface ConferenceMapViewController ()

@property (nonatomic, retain) UIImageView *imgView;

@end

@implementation ConferenceMapViewController

@synthesize scrollView = _scrollView;
@synthesize lblPlaceName = _lblPlaceName;
@synthesize topView = _topView;
@synthesize imgView;

- (id) initWithMapImage:(UIImage *)inMapImage:(ConferenceController*) conferenceController
{
    if ((self = [super initWithNibName:@"ConferenceMap" bundle:[NSBundle mainBundle]]))
    {
        mapImage = [inMapImage retain];
        confController=conferenceController;
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
    [_scrollView release];
    [_lblPlaceName release];
    [_topView release];
    [mapImage release];
    [imgView release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self importCommonView:confController];
    
   // self.title = @"Map";
    
    self.lblPlaceName.text = @"";
    //NSLog(@"the image width is %f",mapImage.size.width);
    //NSLog(@"the image height is %f",mapImage.size.height);
    UIImageView *imgV = [[UIImageView alloc] initWithImage:mapImage];
    self.imgView = imgV;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [imgV release];
    
    [self.scrollView addSubview:self.imgView];
    self.scrollView.contentSize = imgView.bounds.size;
    
    self.scrollView.minimumZoomScale = MIN(self.scrollView.bounds.size.width / self.imgView.bounds.size.width,
                                          self.scrollView.bounds.size.height /self.imgView.bounds.size.height);
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator=NO;
}

-(void) viewWillAppear:(BOOL)animated{
    
    UIImage *backgroundImage = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        backgroundImage = [UIImage imageNamed:@"background_navbar_map_ipad"];
    }
    else{
        backgroundImage = [UIImage imageNamed:@"background_navbar_map"];
    }

    //for IOS = 5
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        //for IOS < 5
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675324];
    }    
}


-(void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[self.navigationController navigationBar] resetBackground:8675324];
}

- (void) markPlace:(Place *)place
{
    CGPoint point = CGPointMake(place.xPos, place.yPos);
    
    UIImage *marker = [UIImage imageNamed:@"marker_map.png"];
    UIImageView *markImgView = [[UIImageView alloc] initWithImage:marker];
    CGRect frame = markImgView.frame;
    frame.origin = CGPointMake(point.x - marker.size.width / 2.0, point.y - marker.size.height);
    markImgView.frame = frame;
    [self.imgView addSubview:markImgView];
    [markImgView release];
    
    [self.scrollView scrollRectToVisible:CGRectInset(markImgView.frame, -markImgView.bounds.size.width, -markImgView.bounds.size.height) animated:YES];
    
    self.lblPlaceName.text = place.name;
}

- (void) viewDidUnload
{
    self.scrollView = nil;
    self.imgView = nil;
    self.lblPlaceName = nil;
    self.topView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imgView;
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    
}

@end
