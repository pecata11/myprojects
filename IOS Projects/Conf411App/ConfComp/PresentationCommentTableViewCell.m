//
//  PresentationCommentTableViewCell.m
//  ConfComp
//
//  Created by Antoan Tateosian on 05.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "PresentationCommentTableViewCell.h"

#import "Presentation.h"
#import "Author.h"
#import "Institution.h"

@interface PresentationCommentTableViewCell ()

- (void) updateGui;

@end

@implementation PresentationCommentTableViewCell

#define PRESENTATION_COMMENT_CELL_IDENTIFIER @"PresCommentCellIdentifier"

@synthesize lblPresName = _lblPresName;
@synthesize lblAuthorName = _lblAuthorName;
@synthesize lblInstitution = _lblInstitution;
@synthesize lblComment = _lblComment;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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

- (void) dealloc
{
    [_lblPresName release];
    [_lblAuthorName release];
    [_lblInstitution release];
    [_lblComment release];
    
    [super dealloc];
}

+ (PresentationCommentTableViewCell *) cellWithPresentation:(Presentation *)presentation table:(UITableView *)tableView 
{
    PresentationCommentTableViewCell *presCell = [tableView dequeueReusableCellWithIdentifier:PRESENTATION_COMMENT_CELL_IDENTIFIER];
    if (presCell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PresentationCommentTableViewCell" owner:nil options:nil];
        for (id obj in arr)
        {
            if ([obj isKindOfClass:self])
            {
                presCell = (PresentationCommentTableViewCell *)obj;
                break;
            }
        }
    }
    presCell.lblPresName.text = presentation.title;
    presCell.lblAuthorName.text = presentation.firstAuthor.name;
    presCell.lblInstitution.text = presentation.firstAuthor.institution.name;
    presCell.lblComment.text = presentation.comment;
    
    [presCell updateGui];
    
    return presCell;
}

- (void) updateGui
{
    CGSize constraint = CGSizeMake(self.lblPresName.bounds.size.width, 20000.0f);
    
    CGSize size = [self.lblPresName.text sizeWithFont:self.lblPresName.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGRect presFrame = self.lblPresName.frame;
    presFrame.size.height = size.height;
    self.lblPresName.frame = presFrame;
    
    CGRect authFrame = self.lblAuthorName.frame;
    authFrame.origin.y = presFrame.origin.y + presFrame.size.height + 1.0;
    self.lblAuthorName.frame = authFrame;
    
    CGRect instFrame = self.lblInstitution.frame;
    instFrame.origin.y = authFrame.origin.y + authFrame.size.height + 1.0;
    self.lblInstitution.frame = instFrame;
    
    constraint.width = self.lblComment.bounds.size.width;
    size = [self.lblComment.text sizeWithFont:self.lblComment.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGRect commentFrame = self.lblComment.frame;
    commentFrame.origin.y = instFrame.origin.y + instFrame.size.height + 1.0;
    commentFrame.size.height = size.height;
    self.lblComment.frame = commentFrame;
}

+ (CGFloat) heightWithPresentation:(Presentation *)presentation
{
    CGSize constraint = CGSizeMake(290.0, 20000.0f);
    
    CGFloat height = 0.0;
    height += [presentation.title sizeWithFont:[UIFont boldSystemFontOfSize:17.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap].height;
    height += 1.0 + [@"f" sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeTailTruncation].height;
    height += 1.0 + [@"f" sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeTailTruncation].height;
    height += 1.0 + [presentation.comment sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap].height;
    NSLog(@"the height is:%f",height);
    return height + 20.0;
}

@end
