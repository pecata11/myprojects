//
//  UIBottomBarView.h
//  Conference411
//
//  Created by Petko Yanakiev on 1/30/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConferenceController;
@interface UIBottomBarView : UIView{
    BOOL isChecked;
    ConferenceController *confController;
    UINavigationController *navigationController;
    UIButton *searchButton;
}

@property (assign) BOOL isChecked;
@property(nonatomic,retain) UINavigationController *navigationController;
@property(nonatomic,retain)IBOutlet UIButton *searchButton;
-(IBAction)homeButtonPressed:(id)sender;
-(IBAction)searchButtonClicked:(id)sender;
-(IBAction)agendaButtonClicked:(id)sender;
-(IBAction)programButtonClicked:(id)sender;
@end
