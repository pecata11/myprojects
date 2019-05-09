//
//  PresentationTableViewCellInner.m
//  ConfComp
//
//  Created by Petko Yanakiev on 1/25/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import "PresentationTableViewCellInner.h"
#import "Presentation.h"

#define PRESENTATION_INNER_CELL_IDENTIFIER @"PresCellInnerIdentifer"
@implementation PresentationTableViewCellInner

@synthesize lblStaticText=_lblStaticText;
@synthesize lblDynamicText=_lblDynamicText;

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


+ (PresentationTableViewCellInner *) cellWithPresentation:(SessionPaper *)presentation: (UITableView *)tableView:(NSInteger)row:(NSString*)textStatic:(NSString*)textDynamic 
{
    PresentationTableViewCellInner *presCell = [tableView dequeueReusableCellWithIdentifier:PRESENTATION_INNER_CELL_IDENTIFIER];
    if (presCell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PresentationTableViewCellInner" owner:nil options:nil];
        for (id obj in arr)
        {
            if ([obj isKindOfClass:self])
            {
                presCell = (PresentationTableViewCellInner *)obj;
                break;
            }
        }
    }
    presCell.lblStaticText.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        presCell.lblStaticText.font=[UIFont boldSystemFontOfSize:16.0];
        presCell.lblDynamicText.font=[UIFont boldSystemFontOfSize:16.0];
    }else{
       presCell.lblStaticText.font=[UIFont boldSystemFontOfSize:14.0];
        presCell.lblDynamicText.font=[UIFont boldSystemFontOfSize:12.0];
    }
    presCell.lblStaticText.text=textStatic;
    presCell.lblDynamicText.text=textDynamic;
    return presCell;
}

- (void) dealloc
{
    [_lblStaticText release];
    [_lblDynamicText release];
        
    [super dealloc];
}
@end
