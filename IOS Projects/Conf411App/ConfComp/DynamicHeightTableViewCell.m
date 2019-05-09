//
//  DynamicHeightTableViewCell.m
//  ConfComp
//
//  Created by Antoan Tateosian on 11/3/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "DynamicHeightTableViewCell.h"

#import "Constants.h"

@implementation DynamicHeightTableViewCell

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier text:(NSString *)text font:(UIFont *)font
{
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]))
    {
        lblText = [[UILabel alloc] initWithFrame:CGRectZero];
        lblText.lineBreakMode = UILineBreakModeWordWrap;
        lblText.minimumFontSize = font.pointSize;
        lblText.font = font;
        lblText.numberOfLines = 0;
        lblText.tag = 1;
        lblText.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:lblText];

        lblText.text = text;
        
        NSLog(@"set to: %@", lblText.text);
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:lblText.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        [lblText setText:text];
        [lblText setFrame:CGRectMake(CELL_CONTENT_MARGIN, 0, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
        
//        cell.accessoryType = accessoryType;
        
    }
    
    return self;
}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef cont = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(cont, [[UIColor brownColor] CGColor]);
    CGContextFillRect(cont, CGRectMake(self.contentView.frame.origin.x, 0.0, 30.0, self.contentView.bounds.size.height));
}

- (NSString *) labelText
{
    return lblText.text;
}

- (void) setLabelText:(NSString *)labelText
{
    lblText.text = labelText;
    
    NSLog(@"set to: %@", labelText);
}

- (void) dealloc
{
    [lblText release];
    
    [super dealloc];
}

@end
