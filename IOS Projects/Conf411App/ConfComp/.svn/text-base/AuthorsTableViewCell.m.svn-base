//
//  AuthorsTableViewCell.m
//  ConfComp
//
//  Created by Petko Yanakiev on 1/5/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import "AuthorsTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
NSString * const AuthorsTableViewCellIdentifier = @"AuthorsTableViewCellIdentifier";
CGFloat const AuthorTableViewCellHeight = 80.0;

@implementation AuthorsTableViewCell

@synthesize authorsName= _authorsName;
@synthesize authorsTitle = _authorsTitle;
@synthesize authorsInstitution = _authorsInstitution;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //[self.layer setCornerRadius:7.0f];
        //[self.layer setMasksToBounds:YES];
        //[self.layer setBorderWidth:2.0f];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) dealloc
{
    [_authorsName release];
    [_authorsTitle release];
    [_authorsInstitution release];
    [super dealloc];
}

@end