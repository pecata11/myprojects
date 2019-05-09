//
//  UITableViewCell-Helpers.m
//  ConfComp
//
//  Created by Antoan Tateosian on 30.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "UITableViewCell-Helpers.h"

#import "Constants.h"

#define MARK_CELL_VIEW_TAG 1333

@implementation UITableViewCell (Helpers)

+ (UITableViewCell *) dynamicHeightCellWithIdentifier:(NSString *)identifier 
                                                table:(UITableView *)tableView
                                                 text:(NSString *)text 
                                                 font:(UIFont *)font 
                                         acessoryType:(UITableViewCellAccessoryType)accessoryType
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(40,40,300,150)];
        lbl.lineBreakMode = UILineBreakModeWordWrap;
        lbl.minimumFontSize = font.pointSize;
        lbl.font = font;
        lbl.numberOfLines = 0;
        lbl.tag = 1;
        lbl.backgroundColor = [UIColor clearColor];
        
        UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(20,20,50,25)];
        lbl2.lineBreakMode = UILineBreakModeWordWrap;
        lbl2.minimumFontSize = font.pointSize;
        lbl2.font = font;
        lbl2.numberOfLines = 0;
        lbl2.tag = 2;
        lbl2.text=@"Title:";
        lbl2.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
        lbl2.backgroundColor = [UIColor clearColor];
        //[cell.contentView addSubview:lbl2];
        [lbl2 release];
        [cell.contentView addSubview:lbl];
        
        [lbl release];
    }
    
    UILabel *lbl = (UILabel *)[cell.contentView viewWithTag:1];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:lbl.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    [lbl setText:text];
    [lbl setFrame:CGRectMake(CELL_CONTENT_MARGIN, 0, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
    
    cell.accessoryType = accessoryType;
    
    return cell;
}

+ (CGFloat) heightForDynamicCellWithText:(NSString *)text font:(UIFont *)font
{
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height;
}

- (void) setMarkWithColor:(UIColor *)color leftOffset:(CGFloat)leftOffset
{
    UIView *v = [self viewWithTag:MARK_CELL_VIEW_TAG];
    if (v == nil)
    {
        v = [[UIView alloc] initWithFrame:CGRectMake(leftOffset, 0.0, 5.0, self.bounds.size.height)];
        v.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight);
        v.tag = MARK_CELL_VIEW_TAG;
        [self addSubview:v];
        [v release];
    }
    
    v.backgroundColor = color;
}

@end
