//
//  ExhibitorsTableViewCell.m
//  Conference411
//
//  Created by Petko Yanakiev on 2/6/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import "ExhibitorsTableViewCell.h"
#import "Exhibitor.h"

NSString * const ExhibitorsTableViewCellIdentifier = @"ExhibitorsTableViewCellIdentifier";
CGFloat const ExhibitorsTableViewCellHeight = 88.0;

#define SESSION_CELL_IDENTIFIER @"ExhibitorsCellIdentifer"

@implementation ExhibitorsTableViewCell

@synthesize vendorLabelCount=_vendorLabelCount;
@synthesize vendorCount=_vendorCount;
@synthesize vendorLabelTitle=_vendorLabelTitle;
@synthesize vendorTitle=_vendorTitle;
@synthesize vendorImage=_vendorImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}


+ (ExhibitorsTableViewCell *) cellWithExhibitor:(Exhibitor*)expo table: (UITableView *)tableView:(NSInteger)row{
    
    ExhibitorsTableViewCell *expoCell = [tableView dequeueReusableCellWithIdentifier:SESSION_CELL_IDENTIFIER];
    
    if (expoCell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ExhibitorsTableViewCell" owner:nil options:nil];
        for (id obj in arr)
        {
            if ([obj isKindOfClass:self])
            {
                expoCell = (ExhibitorsTableViewCell *)obj;
                break;
            }
        }
        
        expoCell.vendorLabelCount.text=@"Vendor: ";
        expoCell.vendorLabelCount.textColor = [UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
        expoCell.vendorLabelTitle.text=@"Title";
         expoCell.vendorLabelTitle.textColor = [UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
        expoCell.vendorTitle.text = expo.name;
        expoCell.vendorCount.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
        expoCell.vendorCount.text = [NSString stringWithFormat:@"%d", row+1];
        
        if(expo.logoUrlAddress != nil)
        {
        NSURL *url = [[NSURL alloc] initWithString:expo.logoUrlAddress];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
            [url release];
        UIImage *image = [UIImage imageWithData:imageData];
        expoCell.vendorImage.image=image;
        }
    }
    return expoCell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) dealloc
{
    [_vendorLabelCount release];
    [_vendorCount release];
    [_vendorLabelTitle release];
    [_vendorTitle release];
    [_vendorImage release];
    
    [super dealloc];
}



@end
