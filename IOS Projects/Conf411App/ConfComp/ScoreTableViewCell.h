//
//  ScoreTableViewCell.h
//  ConfComp
//
//  Created by Antoan Tateosian on 03.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const ScoreCellIdentifier;
extern CGFloat const ScoreCellHeight;

@protocol ScoreTableViewCellDelegate;

@interface ScoreTableViewCell : UITableViewCell {
@private
    id<ScoreTableViewCellDelegate> delegate;
}

@property (nonatomic, assign) id<ScoreTableViewCellDelegate> delegate;

@property (nonatomic, assign) NSInteger score;

- (IBAction) starButtonPressed:(id)sender;
- (IBAction) clearButtonPressed:(id)sender;

@end

@protocol ScoreTableViewCellDelegate <NSObject>

@optional
- (void) scoreTableViewCellScoreChanged:(ScoreTableViewCell *)scoreTableViewCell;

@end