//
//  IndivAuthorTableViewCell.m
//  ConfComp
//
//  Created by Petko Yanakiev on 1/6/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "IndivAuthorTableViewCell.h"

NSString * const IndivAuthorTableViewCellIdentifier = @"IndivAuthorTableViewCellIdentifier";
CGFloat const IndivAuthorTableViewCellHeight = 105.0;

@implementation IndivAuthorTableViewCell

@synthesize authorName= _authorName;
@synthesize authorlblTitle = _authorlblTitle;
@synthesize authorTitle = _authorTitle;
@synthesize authorlblInstitution=_authorlblInstitution;
@synthesize authorInstitution=_authorInstitution;
@synthesize authorImage=_authorImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.authorlblTitle.text =@"Title";
    if (self) {
        /*
        self.authorlblTitle.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
        self.authorlblTitle.font=[UIFont boldSystemFontOfSize:16.0];
        self.authorTitle.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
        self.authorlblTitle.text =@"Title";
        self.authorTitle.font=[UIFont boldSystemFontOfSize:16.0];
        self.authorlblInstitution.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
        self.authorlblInstitution.font=[UIFont boldSystemFontOfSize:16.0];
        self.authorlblInstitution.text=@"Affiliation";
        // Initialization code
        //[self.layer setCornerRadius:7.0f];
        //[self.layer setMasksToBounds:YES];
        //[self.layer setBorderWidth:2.0f];
         */
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
    [super dealloc];
    [_authorName release];
    [_authorlblTitle release];
    [_authorInstitution release];
    [_authorlblInstitution release];
    [_authorTitle release];
    [_authorImage release];
   
}

@end
