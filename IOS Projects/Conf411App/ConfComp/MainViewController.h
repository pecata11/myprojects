//
//  MainViewController.h
//  ConfComp
//
//  Created by Anto  XX on 10/17/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+event.h"
#import "DownloadOperation.h"


typedef enum InternetStatus{
    online = 1,
    offline = 0
}InetStatus;

@class ConferenceController;
@interface MainViewController : UIViewController<UIScrollViewDelegate,UIAlertViewDelegate> {
@private
    BOOL observationsAdded;
    NSOperationQueue *queue;
    UIScrollView *scrollView;
    NSObject *globalObject;
    UIView *tempView;
    NSMutableArray *delTags;
    BOOL deleted;
    ConferenceController* confController;
    NSString *confServer;
    NSInteger confPort;
    
}
@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet UIView *tempView;
@property(nonatomic, retain) NSObject *globalObject;
@property(nonatomic,retain)  NSURL *PDFURL;
@property(nonatomic,retain)  NSURL *localURL;
@property(nonatomic,retain)NSMutableArray *delTags;
@property(nonatomic) BOOL deleted;
@property(nonatomic,retain) NSString *confServer;
@property(nonatomic) NSInteger confPort;

-(IBAction)importButtonClicked:(id)sender;
-(IBAction)getstartedButtonClicked:(id)sender;
-(IBAction)updateButonClicked:(id)sender;
-(IBAction)miraButtonClicked:(id)sender;
-(IBAction)deleteConf:(id)sender;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end