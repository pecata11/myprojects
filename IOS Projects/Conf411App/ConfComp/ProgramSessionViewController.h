//
//  ProgramSessionViewController.h
//  Conference411
//
//  Created by Petko Yanakiev on 3/1/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConferenceController;

@interface ProgramSessionViewController : UIViewController{
    
    NSString *type;
    NSMutableArray *sessArray;
    UITableView *programSessionTable;
    ConferenceController *confController;
    NSArray *sortedArray;
}

@property(nonatomic,retain) IBOutlet UITableView *programSessionTable;
@property(nonatomic,retain) NSMutableArray *sessArray;
@property(nonatomic,retain) NSArray *sortedArray;
@property(nonatomic,retain) NSString *type;
-(id) initProgramSessionViewController:(NSString*) type:(ConferenceController*)conferenceController;
@end