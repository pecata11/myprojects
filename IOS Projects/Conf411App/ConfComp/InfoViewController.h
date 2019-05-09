//
//  InfoViewController.h
//  ConfComp
//
//  Created by Antoan Tateosian on 17.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConferenceController;
@interface InfoViewController : UIViewController <UIWebViewDelegate> {
@private
    NSURL *url;
    NSInteger localCopyOfFile;
    ConferenceController *confController;
}

- (id) initWithUrl:(NSURL *)url:(NSInteger)local:(ConferenceController*) conferenceController;

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic) NSInteger localCopyOfFile;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *actView;


- (IBAction) btnLinkPressed:(id)sender;

@end
