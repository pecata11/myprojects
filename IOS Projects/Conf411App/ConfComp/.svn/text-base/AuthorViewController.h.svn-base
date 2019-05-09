//
//  AuthorViewController.h
//  ConfComp
//
//  Created by Antoan Tateosian on 30.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Author;
@class ConferenceController;

@interface AuthorViewController : UIViewController {
@private
    Author *author;
    UITableView *tableViewAuthor;
    ConferenceController *confController;
    BOOL isChecked;
    UIView  *view1;
    UILabel *authorName;
    UILabel *authorlblTitle;
    UILabel *authorTitle;
    UILabel *authorlblInstitution;
    UILabel *authorInstitution;
    UIImageView *authorImage;

}
@property (nonatomic,retain) IBOutlet UITableView *tableViewAuthor;
@property(nonatomic,retain) IBOutlet UILabel *authorName;
@property(nonatomic,retain) IBOutlet UILabel *authorlblTitle;
@property(nonatomic,retain) IBOutlet UILabel *authorTitle;
@property(nonatomic,retain) IBOutlet UILabel *authorlblInstitution;
@property(nonatomic,retain) IBOutlet UILabel *authorInstitution;
@property(nonatomic,retain) IBOutlet UIImageView *authorImage;
@property(nonatomic,retain) IBOutlet UIView *view1;

- (id) initWithAuthor:(Author *)author conferenceController:(ConferenceController *)conferenceController;
@property (nonatomic) BOOL isChecked;
-(IBAction)programButtonClicked:(id)sender;
-(void)initFirstView;

@end
