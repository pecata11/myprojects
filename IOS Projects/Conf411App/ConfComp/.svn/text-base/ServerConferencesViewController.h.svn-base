//
//  ServerConferencesViewController.h
//  ConfComp
//
//  Created by Antoan Tateosian on 17.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DownloadOperation.h"
//Main class for servers conference view.
@interface ServerConferencesViewController : UIViewController <DownloadOperationDelegate> {
@private
    NSOperationQueue *queue;
    
    NSMutableArray *conferences;
    
    DownloadOperation *listConferencesOperation;
    
    UIActivityIndicatorView *actLoadingList;
    
    BOOL loadConferencesCalled;
    NSString *confServer;
    NSInteger confPort;
    UITableView *tableView;
    
}

@property (nonatomic, retain) IBOutlet UIView *viewHeader;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) NSString *confServer;
@property(nonatomic) NSInteger confPort;
-(IBAction)miraButtonClicked:(id)sender;
-(void) fillConferenceList:(DownloadOperation*)operation;
@end
