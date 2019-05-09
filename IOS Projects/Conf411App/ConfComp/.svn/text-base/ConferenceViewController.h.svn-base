//
//  ConferenceViewController.h
//  ConfComp
//
//  Created by Anto  XX on 10/20/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadOperation.h"
@class ConferenceController;
@class ServerShortConferenceInfo;
@class ExtendedServerShortConferenceInfo;
@class ConferenceListViewController;

@interface ConferenceViewController : UIViewController <DownloadOperationDelegate,UIAlertViewDelegate>  {
    UIButton *exibitorsButton;
    UIButton *labelExpo;

@private
    ExtendedServerShortConferenceInfo *confInfo;
    ConferenceController *confController;
    BOOL confLoaded;
    BOOL observersAdded;
    NSString *confServer;
    NSInteger confPort;
}

@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *actLoading;
@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property(nonatomic,retain)IBOutlet UIButton *exibitorsButton;
@property(nonatomic,retain)IBOutlet UILabel *labelExpo;
@property(nonatomic,retain) NSString *confServer;
@property(nonatomic) NSInteger confPort;

- (id) initWithConference:(ExtendedServerShortConferenceInfo *)confInfo;
-(IBAction)authorsButtonPressed:(id)sender;
-(IBAction)calendarButtonPressed:(id)sender;
-(IBAction)miraButtonClicked:(id)sender;
-(IBAction)mapButtonClicked:(id)sender;
-(IBAction)searchButtonClicked:(id)sender;
-(IBAction)expoButtonClicked:(id)sender;
-(IBAction)infoButtonClicked:(id)sender;
-(IBAction)agendaButtonClicked:(id)sender;
-(IBAction)programButtonClicked:(id)sender;
-(IBAction)updateButtonClicked:(id)sender;
@end
