//
//  BirthdayTableCell.m
//  BirthdayCalendar
//
//  Created by Dimitar Kamenov on 1/22/13.
//
//

#import "BirthdayTableCell.h"

@implementation BirthdayTableCell

@synthesize birthdayDateField;

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

@end
