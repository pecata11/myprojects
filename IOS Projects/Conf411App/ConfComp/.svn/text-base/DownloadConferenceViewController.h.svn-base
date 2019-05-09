//
//  DownloadConferenceViewController.h
//  ConfComp
//
//  Created by Anto  XX on 10/19/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadOperation.h"

@class ExtendedServerShortConferenceInfo;
@class ServerShortConferenceInfo;
//Main controller class for downloading conference via a download operation delegate.
@interface DownloadConferenceViewController : UIViewController <DownloadOperationDelegate> {
@private
    ExtendedServerShortConferenceInfo *conferenceInfo;
    
    BOOL observationsAdded;
}

@property (nonatomic, retain) IBOutlet UIButton *btnDownload;
@property (nonatomic, retain) IBOutlet UIImageView *imgViewLogo;
@property (nonatomic, retain) IBOutlet UILabel *lblConferenceName;
@property (nonatomic, retain) IBOutlet UITextView *txtConferenceDescription;
@property (nonatomic, retain) IBOutlet UILabel *lblDownloadStatus;
@property (nonatomic, retain) IBOutlet UILabel *lblGoBackDescr;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *actDownloading;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *actImageDownloading;
@property(nonatomic,retain) IBOutlet UITableView *tableView;


- (IBAction) btnDownloadPressed:(id)sender;

- (id) initWithConferenceInfo:(ExtendedServerShortConferenceInfo *)conferenceInfo;

@end
