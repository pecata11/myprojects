//
//  AuthorsViewController.h
//  ConfComp
//
//  Created by Antoan Tateosian on 30.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConferenceController;

@interface AuthorsViewController : UIViewController {
@private
    NSArray *authors;
    UITableView *tableViewAuthors;
    UIImage *oldBackground;
    BOOL isChecked;
    BOOL isCustom;
    ConferenceController *confController;
}

@property (nonatomic,retain) IBOutlet UITableView *tableViewAuthors;
@property (nonatomic, retain) UIImage *oldBackground;
@property (assign) BOOL isCustom;
@property (nonatomic) BOOL isChecked;

- (id) initWithAuthors:(NSArray *)authors conferenceController:(ConferenceController *)conferenceController;

@end
