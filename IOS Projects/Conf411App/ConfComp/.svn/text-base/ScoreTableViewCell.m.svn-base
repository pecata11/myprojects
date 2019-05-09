//
//  ScoreTableViewCell.m
//  ConfComp
//
//  Created by Antoan Tateosian on 03.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "ScoreTableViewCell.h"

NSString * const ScoreCellIdentifier = @"ScoreCellIdentifier";
CGFloat const ScoreCellHeight = 34.0;

@interface ScoreTableViewCell ()

- (void) updateStars;
- (void) onScoreChanged;

@end

@implementation ScoreTableViewCell

@synthesize score = _score;
@synthesize delegate;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) starButtonPressed:(id)sender
{
    self.score = ((UIButton *)sender).tag;
    
    [self onScoreChanged];
}

- (void) clearButtonPressed:(id)sender
{
    self.score = 0;
    
    [self onScoreChanged];
}

- (void) setScore:(NSInteger)newScore
{
    NSAssert1(newScore >= 0 && newScore <= 5, @"Invalid score - must be in [0, 5], and it is: %d", newScore);
    
    _score = newScore;
    
    [self updateStars];
}

- (void) updateStars
{
    for (int i = 1; i <= 5; i++)
    {
        UIButton *btn = (UIButton *)[self viewWithTag:i];
        
        if (i <= self.score)
        {
            [btn setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
        }
        else
        {
            [btn setImage:[UIImage imageNamed:@"star-off.png"] forState:UIControlStateNormal];
        }
    }
}

- (void) onScoreChanged
{
    if ([delegate respondsToSelector:@selector(scoreTableViewCellScoreChanged:)])
    {
        [delegate scoreTableViewCellScoreChanged:self];
    }
}

@end
