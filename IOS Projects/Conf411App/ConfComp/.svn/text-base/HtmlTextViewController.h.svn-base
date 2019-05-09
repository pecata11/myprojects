//
//  HtmlTextViewController.h
//  ConfComp
//
//  Created by Antoan Tateosian on 29.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConferenceController;
@interface HtmlTextViewController : UIViewController <UIWebViewDelegate> {
@private
    NSString *htmlString;
    NSString *confName;
    ConferenceController* confController;
}

- (id) initWithHtmlString:(NSString *)string:(NSString *)name:(ConferenceController*)conferenceController;

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *actView;
@property (nonatomic,retain)  IBOutlet UILabel *lblStaticText;
@property (nonatomic,retain)  IBOutlet UILabel *lblConfName;
@property (nonatomic,retain)  IBOutlet UIView *view1;
@property (nonatomic,retain)  IBOutlet NSString *confName;


@end
