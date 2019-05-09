//
//  AuthorViewController.m
//  ConfComp
//
//  Created by Antoan Tateosian on 30.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "AuthorViewController.h"
#import "Author.h"
#import "ConferenceController.h"
#import "Institution.h"
#import "PresentationTableViewCell.h"
#import "Presentation.h"
#import "PresentationViewController.h"
#import "Constants.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import <QuartzCore/QuartzCore.h>
#import "ProgramViewController.h"
#import "UIViewController+CommonClass.h"
#import "SessionPaper.h"


@implementation AuthorViewController

@synthesize tableViewAuthor,isChecked;
@synthesize view1;
@synthesize authorName;
@synthesize authorlblTitle;
@synthesize authorTitle;
@synthesize authorlblInstitution;
@synthesize authorInstitution;
@synthesize authorImage;

- (id) initWithAuthor:(Author *)inAuthor conferenceController:(ConferenceController *)conferenceController
{
    if ((self = [super initWithNibName:@"Author" bundle:[NSBundle mainBundle]]))
    {
        author = [inAuthor retain];
        confController = conferenceController;
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


- (void) dealloc
{
    [author release];
    [view1 release];
    [authorName release];
    [authorlblTitle release];
    [authorTitle release];
    [authorlblInstitution release];
    [authorInstitution release];
    [authorImage release];

    [super dealloc];
}

-(IBAction)programButtonClicked:(id)sender
{    
    ProgramViewController *programVc = [[ProgramViewController alloc] initWithConferenceController:confController];
    [self.navigationController pushViewController:programVc animated:YES];
    [programVc release];
}


#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    if ([tableViewAuthor respondsToSelector:@selector(setBackgroundView:)])
    {
        [tableViewAuthor setBackgroundView:nil];
    }
    tableViewAuthor.backgroundColor = [UIColor clearColor];
    [self importCommonView:confController];
    self.view.backgroundColor=[UIColor clearColor];
    [self initFirstView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)initFirstView{
    
    CALayer *l = [view1 layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    
    self.authorlblTitle.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    self.authorlblTitle.font=[UIFont boldSystemFontOfSize:16.0];
    self.authorTitle.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    self.authorlblTitle.text =@"Title:";
    self.authorTitle.font=[UIFont boldSystemFontOfSize:15.0];
    self.authorlblInstitution.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    //self.authorlblInstitution.font=[UIFont boldSystemFontOfSize:16.0];
    self.authorlblInstitution.font=[UIFont systemFontOfSize:16.0];
    self.authorInstitution.font=[UIFont boldSystemFontOfSize:14.0];
    self.authorlblInstitution.text=@"Affiliation:";
    self.authorName.text = author.name;
    self.authorTitle.text = author.title;

    NSString *institutionText = @"";
    int institutionCounter;
    for(institutionCounter=0;institutionCounter<[author.institutions count]-1;institutionCounter++) {
        Institution *inst = [author.institutions objectAtIndex:institutionCounter];
        institutionText = [institutionText stringByAppendingString:inst.name];
        institutionText = [institutionText stringByAppendingString:@", "];
    };
    Institution *inst = [author.institutions objectAtIndex:institutionCounter];
    institutionText = [institutionText stringByAppendingString:inst.name];
    self.authorInstitution.text = institutionText;
    [self.authorInstitution sizeToFit];
    
    NSData *imageData = [NSData dataWithContentsOfURL:author.image];
    UIImage *image = [UIImage imageWithData:imageData];
    if (image == nil)
    {
        image = [UIImage imageNamed:@"authors_image.png"];
    }
    self.authorImage.image=image;
}

-(void) viewWillAppear:(BOOL)animated {
    
    
    
    
    UIImage *backgroundImage = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        backgroundImage = [UIImage imageNamed:@"background_navbar_indiv_author_ipad"];
    }
    else
    {
        backgroundImage = [UIImage imageNamed:@"background_navbar_indiv_author"];
    }

    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675312];
    }
     [self.tableViewAuthor reloadData];
}

-(void) viewWillDisappear:(BOOL)animated {
  
     [[self.navigationController navigationBar] resetBackground:8675312];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [author.presentations count];
        return count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 10.0;
    
    return 1.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
        return 3.0;
    
    return 3.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
      
        //NSLog(@"Index path section is:%d",indexPath.section);
        SessionPaper *presentation = [author.presentations objectAtIndex:indexPath.section];
        cell = [PresentationTableViewCell cellWithPresentation:presentation table:tableView:indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
         return cell;
}

#pragma mark - Table view delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        SessionPaper *pres = [author.presentations objectAtIndex:indexPath.row];
        PresentationViewController *presVc = [[PresentationViewController alloc] initWithPresentation:pres conferenceController:confController];
        [self.navigationController pushViewController:presVc animated:YES];
        [presVc release];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
            return 105; 
}
@end
