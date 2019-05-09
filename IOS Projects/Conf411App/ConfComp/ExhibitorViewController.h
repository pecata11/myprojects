//
//  ExhibitorViewController.h
//  ConfComp
//
//  Created by Antoan Tateosian on 29.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Exhibitor;
@class ConferenceController;
@class Sponsor;

@interface ExhibitorViewController : UIViewController<UIScrollViewDelegate> {
@private
    Exhibitor *exhibitor;
    Sponsor *sponsor;
    ConferenceController *confController;
}

- (id) initWithExhibitor:(Exhibitor *)exhibitor conferenceController:(ConferenceController *)conferenceController;
- (id) initWithSponsor:(Sponsor *)sponsor conferenceController:(ConferenceController *)conferenceController;


@property (nonatomic,retain)  IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *view1;
@property (nonatomic, retain) IBOutlet UIView *view2;
@property (nonatomic, retain) IBOutlet UIView *view3;
@property (nonatomic, retain) IBOutlet UIView *view4;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationText;
@property (nonatomic, retain) IBOutlet UILabel *companyLabel;
@property (nonatomic, retain) IBOutlet UILabel *companyText;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UITextView *descriptionText;
@property (nonatomic, retain) IBOutlet UILabel *websiteLabel;
@property (nonatomic, retain) IBOutlet UIButton *websiteText;

- (IBAction) btnShowOnMapPressed:(id)sender;
- (IBAction) btnUrlPressed:(id)sender;

@end
