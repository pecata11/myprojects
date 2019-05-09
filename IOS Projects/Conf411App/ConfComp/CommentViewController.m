//
//  CommentViewController.m
//  ConfComp
//
//  Created by Antoan Tateosian on 03.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()

- (void) btnSavePressed:(id)sender;

@end

@implementation CommentViewController

@synthesize comment = _comment;
@synthesize textView = _textView;
@synthesize delegate;

- (id) initWithComment:(NSString *)inComment
{
    if ((self = [super initWithNibName:@"Comment" bundle:[NSBundle mainBundle]]))
    {
        origComment = [inComment copy];
    }
    
    return self;
}

- (NSString *) comment
{
    return self.textView.text;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) dealloc
{
    [origComment release];
    [_textView release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Comment";
    self.textView.text = origComment;
    
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(btnSavePressed:)];
    self.navigationItem.rightBarButtonItem = btnSave;
    [btnSave release];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)viewDidUnload
{
    self.textView = nil;
    
    [super viewDidUnload];
}

- (void) btnSavePressed:(id)sender
{
    if ([delegate respondsToSelector:@selector(commentViewControllerDidSave:)])
    {
        [delegate commentViewControllerDidSave:self];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
