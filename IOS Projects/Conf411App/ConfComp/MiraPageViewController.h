//
//  MiraPageViewController.h
//  ConfComp
//
//  Created by Petko Yanakiev on 1/13/12.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConferenceController;
@interface MiraPageViewController : UIViewController<UIScrollViewDelegate,UIWebViewDelegate>{
    
@private
    UIView *view1;
    UIView *view2;
    UIView *view3;
    UILabel *labelWho;
    UILabel *labelTitle;
    UITextView *textViewWho;
    UILabel *labelWhat;
    UITextView *textViewWhat;
    UILabel *labelConf;
    UITextView *textViewConf;
    BOOL isChecked;
    UIWebView *webView;
    UIScrollView *scrollView;
    ConferenceController* confController;
}

@property(nonatomic,retain) IBOutlet UIView *view1;
@property(nonatomic,retain) IBOutlet UIView *view2;
@property(nonatomic,retain) IBOutlet UIView *view3;
@property(nonatomic,retain) IBOutlet UILabel *labelWho;
@property(nonatomic,retain) IBOutlet UILabel *labelTitle;
@property(nonatomic,retain) IBOutlet UITextView *textViewWho;
@property(nonatomic,retain) IBOutlet UILabel *labelWhat;
@property(nonatomic,retain) IBOutlet UITextView *textViewWhat;
@property(nonatomic,retain) IBOutlet UILabel *labelConf;
@property(nonatomic,retain) IBOutlet UITextView *textViewConf;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet UIWebView *webView;
@property (nonatomic) BOOL isChecked;
- (id) initWithMiraPageController:(ConferenceController *)conferenceController;

@end