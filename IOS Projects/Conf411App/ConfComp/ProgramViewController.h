//
//  ProgramViewController.h
//  Conference411
//
//  Created by Petko Yanakiev on 3/1/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConferenceController;

@interface ProgramViewController : UIViewController{
    
    UITableView *programTable;
    NSMutableArray *sessArray;
    ConferenceController *confController;
}

@property(nonatomic,retain) IBOutlet UITableView *programTable;
@property(nonatomic,retain) NSMutableArray *sessArray;

- (id) initWithConferenceController:(ConferenceController *)conferenceController;
@end
