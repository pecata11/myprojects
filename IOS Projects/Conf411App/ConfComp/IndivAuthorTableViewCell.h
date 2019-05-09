//
//  IndivAuthorTableViewCell.h
//  ConfComp
//
//  Created by Petko Yanakiev on 1/6/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const IndivAuthorTableViewCellIdentifier;
extern CGFloat const IndivAuthorTableViewCellHeight;
@interface IndivAuthorTableViewCell : UITableViewCell{
    
    UILabel *authorName;
    UILabel *authorlblTitle;
    UILabel *authorTitle;
    UILabel *authorlblInstitution;
    UILabel *authorInstitution;
    UIImageView *authorImage;
}

@property(nonatomic,retain) IBOutlet UILabel *authorName;
@property(nonatomic,retain) IBOutlet UILabel *authorlblTitle;
@property(nonatomic,retain) IBOutlet UILabel *authorTitle;
@property(nonatomic,retain) IBOutlet UILabel *authorlblInstitution;
@property(nonatomic,retain) IBOutlet UILabel *authorInstitution;
@property(nonatomic,retain) IBOutlet UIImageView *authorImage;
@end
