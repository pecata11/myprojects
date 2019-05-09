//
//  SessionTableViewCell.m
//  Conference411
//
//  Created by Petko Yanakiev on 2/2/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import "SessionTableViewCell.h"
#import "ConfSession.h"
#import "Author.h"
#import "ConfDay.h"
#import "ConfTimeFrame.h"
#import "Place.h"
#import "ConfTrack.h"

NSString * const SessionTableViewCellIdentifier = @"AuthorsTableViewCellIdentifier";
CGFloat const SessionTableViewCellHeight = 312.0;

#define SESSION_CELL_IDENTIFIER @"SessionCellIdentifer"

@implementation SessionTableViewCell

@synthesize titleLabel=_titleLabel;
@synthesize titleText=_titleText;
@synthesize chairLabel=_chairLabel;
@synthesize chairText=_chairText;
@synthesize dateLabel=_dateLabel;
@synthesize timeLabel=_timeLabel;
@synthesize placeLabel=_placeLabel;
@synthesize trackLabel=_trackLabel;
@synthesize trackText=_trackText;
@synthesize sessDescripionLabel=_sessDescripionLabel;
@synthesize sessDescriptionText=_sessDescriptionText;   

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}


+ (SessionTableViewCell *) cellWithSession:(ConfSession *)session table: (UITableView *)tableView:(NSInteger)row:(NSString*)trackLabelName:(NSString*)moderatorLabelName 
{
    SessionTableViewCell *sessCell = [tableView dequeueReusableCellWithIdentifier:SESSION_CELL_IDENTIFIER];
    
    if (sessCell == nil)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"SessionTableViewCell" owner:nil options:nil];
        for (id obj in arr)
        {
            if ([obj isKindOfClass:self])
            {
                sessCell = (SessionTableViewCell *)obj;
                break;
            }
        }
        sessCell.titleLabel.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
        sessCell.chairLabel.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
        sessCell.trackLabel.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
        sessCell.sessDescripionLabel.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
       // NSLog(@"The trackLabelNumber is:%@",trackLabelName);
        if(trackLabelName !=nil){
        sessCell.trackLabel.text=trackLabelName;
        }else{
            sessCell.trackLabel.text=@"";
        }
        if(moderatorLabelName !=nil){
            sessCell.chairLabel.text=moderatorLabelName;
        }else{
            sessCell.chairLabel.text=@"";
        }
        sessCell.titleText.text=session.name;

        if(session.chair != nil)
        {
            NSMutableString *chairNames=[[NSMutableString alloc]init];
            [chairNames appendString:session.chair.name];
            if(session.coChair!=nil)
            {
                [chairNames appendString:@","];
                [chairNames appendString:session.coChair.name];
            }
            sessCell.chairText.text= chairNames;
            [chairNames release];
        }
        else
        {
            sessCell.chairText.text = @"";
        }
        sessCell.dateLabel.text=session.day.dateStr;
        sessCell.timeLabel.text=session.timeStr;
        sessCell.placeLabel.text=session.place.name;
        
        if(session.trackId != 0){
        sessCell.trackText.text = session.track.description;
        }
        else{ sessCell.trackText.text = @""; }
        
        if(session.description != nil)
        {
            sessCell.sessDescriptionText.text=session.description;
        }else{
            sessCell.sessDescriptionText.text=@"";
        }
        //fill the cell content here.
    }
    return sessCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) dealloc
{
    [_titleLabel release];
    [_titleText release];
    [_chairLabel release];
    [_chairText release];
    [_dateLabel release];
    [_timeLabel release];
    [_placeLabel release];
    [_trackLabel release];
    [_trackText release];
    [_sessDescripionLabel release];
    [_sessDescriptionText release];   
    [super dealloc];
}

@end