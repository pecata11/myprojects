//
//  SessionViewController.h
//  ConfComp
//
//  Created by Antoan Tateosian on 03.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConfSession;
@class ConferenceController;

@interface SessionViewController : UIViewController {

    ConfSession *session;
    ConferenceController *confController;
    UITableView *tableViewSession;
    
    UILabel *titleLabel;
    UITextView *titleText;
    
    UILabel *chairLabelStatic;
    UILabel *chairLabel;
    UILabel *chairText;
    
    UILabel *dateText;
    UILabel *timeText;
    UILabel *placeText;
    
    UILabel *trackLabel;
    UILabel *trackText;
    UILabel *sessDescripionLabel;
    UITextView *sessDescriptionText;   
    UIView *sessionView;
    UIScrollView *scrollView;
}
@property(nonatomic,retain) IBOutlet UILabel *titleLabel;
@property(nonatomic,retain) IBOutlet UITextView *titleText;
@property(nonatomic,retain) IBOutlet UILabel *chairLabelStatic;
@property(nonatomic,retain) IBOutlet UILabel *chairLabel;
@property(nonatomic,retain) IBOutlet UILabel *chairText;
@property(nonatomic,retain) IBOutlet UILabel *dateText;
@property(nonatomic,retain) IBOutlet UILabel*timeText;
@property(nonatomic,retain) IBOutlet UILabel *placeText;
@property(nonatomic,retain) IBOutlet UILabel *trackLabel;
@property(nonatomic,retain) IBOutlet UILabel *trackText;
@property(nonatomic,retain) IBOutlet UILabel *sessDescripionLabel;
@property(nonatomic,retain) IBOutlet UITextView *sessDescriptionText;
@property(nonatomic,retain) IBOutlet UIView *sessionView;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet UITableView *tableViewSession;

- (id) initWithSession:(ConfSession *)session conferenceController:(ConferenceController *)conferenceController;
- (void)initModeratorsAndTracks; 
-(void)initSessionView;
@end