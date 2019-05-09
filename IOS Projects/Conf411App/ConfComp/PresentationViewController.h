//
//  PresentationViewController.h
//  ConfComp
//
//  Created by Antoan Tateosian on 02.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommentViewController.h"
#import "ScoreTableViewCell.h"

@class Presentation;
@class ConferenceController;
@class SessionPaper;

@interface PresentationViewController : UIViewController <CommentViewControllerDelegate, ScoreTableViewCellDelegate> {
@private
    SessionPaper *presentation;
    ConferenceController *confController;
    //NSArray* sortedAuthors;
    UITableView *tableView;
    BOOL isChecked;

}

- (id) initWithPresentation:(SessionPaper *)presentation conferenceController:(ConferenceController *)conferenceController;
@property (nonatomic) BOOL isChecked;
@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSArray *sortedAuthors;

@end
