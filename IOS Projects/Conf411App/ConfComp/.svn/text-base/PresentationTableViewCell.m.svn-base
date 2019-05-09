//
//  PresentationTableViewCell.m
//  ConfComp
//
//  Created by Antoan Tateosian on 30.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "PresentationTableViewCell.h"
#import "Constants.h"
#import "Author.h"
#import "Institution.h"
#import "Presentation.h"
#import <QuartzCore/QuartzCore.h>
#import "SessionPaper.h"
NSString * const PresentationTableViewCellIdentifier = @"PresCellIdentifer";
#define PRESENTATION_CELL_IDENTIFIER @"PresCellIdentifer"

@interface PresentationTableViewCell ()

- (void) updateGui;

@end

@implementation PresentationTableViewCell

@synthesize lblDate = _lblDate;
@synthesize lblPresentationName = _lblPresentationName;
@synthesize lblFirstAuthorName = _lblFirstAuthorName;
@synthesize lblInstitutionName = _lblInstitutionName;
@synthesize lblDateStr=_lblDateStr;
@synthesize lblCountPres=_lblCountPres;
@synthesize lblStaticText=_lblStaticText;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}
- (BOOL) isOpaque {
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateGui
{
    CGSize constraint = CGSizeMake(self.lblPresentationName.bounds.size.width, 20000.0f);
   
    CGSize size = [self.lblPresentationName.text sizeWithFont:self.lblPresentationName.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGRect presFrame = self.lblPresentationName.frame;
    presFrame.size.height = size.height;
    self.lblPresentationName.frame = presFrame;
    
    //CGRect authFrame = self.lblFirstAuthorName.frame;
    //authFrame.origin.y = presFrame.origin.y + presFrame.size.height + 1.0;
    //self.lblFirstAuthorName.frame = authFrame;
    
    //CGRect instFrame = self.lblInstitutionName.frame;
    //instFrame.origin.y = authFrame.origin.y + authFrame.size.height + 1.0;
    //self.lblInstitutionName.frame = instFrame;
}

+ (PresentationTableViewCell *) cellWithPresentation:(SessionPaper *)presentation table: (UITableView *)tableView:(NSInteger)row 
{
    PresentationTableViewCell *presCell = [tableView dequeueReusableCellWithIdentifier:PRESENTATION_CELL_IDENTIFIER];
    if (presCell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PresentationTableViewCell" owner:nil options:nil];
        for (id obj in arr)
        {
            if ([obj isKindOfClass:self])
            {
                presCell = (PresentationTableViewCell *)obj;
                break;
            }
        }
    }
    NSString *tim=nil;
    if([presentation.dayTimeValue isEqualToString:@"(null)"]){
        tim=@"";
    }else{
        tim=presentation.dayTimeValue;
    }

    presCell.lblDate.text = tim;
    presCell.lblDateStr.text=presentation.dateDayValue;
    presCell.lblCountPres.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    presCell.lblCountPres.text = presentation.programNumber;  
    presCell.lblStaticText.text=presentation.title;
    presCell.lblStaticText.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    NSString * name=nil;
    for(Author* author in presentation.authors){
        name=author.name;
        break;
    }
    presCell.lblFirstAuthorName.text = name;
    return presCell;
}

+ (CGFloat) heightWithPresentation:(SessionPaper *)presentation
{
    CGSize constraint = CGSizeMake(270.0, 20000.0f);
    
    CGFloat height = 0.0;
    height += [@"f" sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeTailTruncation].height;
    height += [presentation.title sizeWithFont:[UIFont boldSystemFontOfSize:17.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeTailTruncation].height;
    height += 1.0 + [@" " sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeTailTruncation].height;
    height += 1.0 + [@" " sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeTailTruncation].height;
    return height + 20.0;
}

- (void) dealloc
{
    [_lblDate release];
    [_lblPresentationName release];
    [_lblFirstAuthorName release];
    [_lblInstitutionName release];
    [_lblDateStr release];
    [_lblCountPres release];
    [_lblStaticText release];
    
    [super dealloc];
}

@end