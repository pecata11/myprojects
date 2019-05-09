//
//  CommentViewController.h
//  ConfComp
//
//  Created by Antoan Tateosian on 03.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentViewControllerDelegate;

@interface CommentViewController : UIViewController {
@private
    id<CommentViewControllerDelegate> delegate;
    NSString *origComment;
}

- (id) initWithComment:(NSString *)comment;

@property (nonatomic, assign) id<CommentViewControllerDelegate> delegate;
@property (nonatomic, readonly) NSString *comment;

@property (nonatomic, retain) IBOutlet UITextView *textView;

@end

@protocol CommentViewControllerDelegate <NSObject>

@optional
- (void) commentViewControllerDidSave:(CommentViewController *)commentViewController;

@end