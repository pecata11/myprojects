//
//  AuthorsViewController.m
//  ConfComp
//
//  Created by Antoan Tateosian on 30.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "AuthorsViewController.h"
#import "Author.h"
#import "Institution.h"
#import "AuthorViewController.h"
#import "AuthorsTableViewCell.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "ConfSearchViewController.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+CommonClass.h"

@interface AuthorsViewController ()

@property (nonatomic, retain) NSArray *letters;
@property (nonatomic, retain) NSDictionary *letterToAuthorsMapping;

- (void) loadAuthors;

- (Author *) authorAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation AuthorsViewController
@synthesize tableViewAuthors,oldBackground,isChecked,isCustom;
@synthesize letters = _letters;
@synthesize letterToAuthorsMapping = _letterToAuthorsMapping;

- (id) initWithAuthors:(NSArray *)inAuthors conferenceController:(ConferenceController *)conferenceController
{
    if ((self = [super initWithNibName:@"Authors" bundle:[NSBundle mainBundle]]))
    {
        authors = [inAuthors retain];
        confController = conferenceController;
    }
    
    return self;
}

- (void) loadAuthors
{
    NSMutableArray *lets = [[NSMutableArray alloc] initWithCapacity:30];
    NSMutableDictionary *mapping = [[NSMutableDictionary alloc] initWithCapacity:30];
    
    [(NSMutableArray*)authors sortUsingComparator:^NSComparisonResult(id obj1, id obj2) 
     {
         Author *auth1 = (Author*)obj1;
         Author *auth2 = (Author*)obj2;
         return [auth1.lastName compare:auth2.lastName];
     }];
    
    //int i = 0;
    for (Author *currAuthor in authors)
    {
        //NSLog(@"currAuthor: %@", currAuthor.lastName);
        if ([currAuthor.presentations count] < 1) {
            // This author doesn't have presentations assigned. He is actually an author but most probably Chair or Co-Chair. Should not be displayed in author's page
            //i++;
            continue;
        }
        
        NSString *firstLetter = @"";
        if (currAuthor.lastName != nil && [currAuthor.lastName length] > 0)
        {
            firstLetter = [[currAuthor.lastName substringToIndex:1] uppercaseString];
        }
        NSMutableArray *auths = [mapping valueForKey:firstLetter];
        if (auths == nil)
        {
            [lets addObject:firstLetter];
            [mapping setValue:[NSMutableArray arrayWithObject:currAuthor] forKey:firstLetter];
        }
        else
        {
            [auths addObject:currAuthor];
        }
    }
    
    //NSLog(@"Authors with presentations count: %d", [authors count] - i);
    self.letters = lets;
    self.letterToAuthorsMapping = mapping;
    
    [lets release];
    [mapping release];
}

- (Author *) authorAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *firstLetter = [self.letters objectAtIndex:indexPath.section];
    NSArray *auths = [self.letterToAuthorsMapping valueForKey:firstLetter];
    Author *author = [auths objectAtIndex:indexPath.row];
    if ([author.presentations count] == 0) {
        NSLog(@"Author: %@ - Presentations: %d", author.name, [author.presentations count]);
    }
    return author;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([tableViewAuthors respondsToSelector:@selector(setBackgroundView:)])
    {
        [tableViewAuthors setBackgroundView:nil];
    }
    tableViewAuthors.backgroundColor = [UIColor clearColor];
    
    [self importCommonView:confController];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    //self.navigationItem.leftBarButtonItem = nil;
    [backButton release];
    
    [self loadAuthors];
    
    [self.tableViewAuthors reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated {
    
    UIImage *backgroundImage = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        backgroundImage = [UIImage imageNamed:@"background_navbar_authors_ipad"];
    }
    else
    {
        backgroundImage = [UIImage imageNamed:@"background_navbar_authors"];
    }
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675313];
    }
    
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [[self.navigationController navigationBar] resetBackground:8675313];
}

- (void)viewDidUnload
{
    self.letters = nil;
    self.letterToAuthorsMapping = nil;
    
    [super viewDidUnload];
}

- (void) dealloc
{
    [authors release];
    [_letters release];
    [_letterToAuthorsMapping release];
    oldBackground = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.letters count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *firstLetter = [self.letters objectAtIndex:section];
    NSArray *auths = [self.letterToAuthorsMapping valueForKey:firstLetter];
    
    return [auths count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:AuthorsTableViewCellIdentifier];
    if (cell == nil)
    {
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:
                         @"AuthorsTableViewCell" owner:nil options:nil];
        for (id obj in objs)
        {
            if ([obj isKindOfClass:[AuthorsTableViewCell class]])
            {
                cell = obj;
                break;
            }
        }
    }
    
    AuthorsTableViewCell *authorCell = (AuthorsTableViewCell *)cell;    
    Author *author = [self authorAtIndexPath:indexPath];
    authorCell.authorsInstitution.text = author.institution.name;
    authorCell.authorsName.text = author.name;
    authorCell.authorsName.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    authorCell.authorsTitle.text=author.title;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        authorCell.authorsTitle.font=[UIFont systemFontOfSize:14.0];
        authorCell.authorsInstitution.font = [UIFont  systemFontOfSize:16.0];
        authorCell.authorsName.font=[UIFont boldSystemFontOfSize:18.0];
    }
    else
    {
        authorCell.authorsTitle.font=[UIFont systemFontOfSize:12.0];
        authorCell.authorsInstitution.font = [UIFont  systemFontOfSize:14.0];
        authorCell.authorsName.font=[UIFont boldSystemFontOfSize:16.0];
    }
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.letters objectAtIndex:section];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vv;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        vv=[[[UIView alloc]initWithFrame:CGRectMake(10,10,768,25)] autorelease];
    }
    else{
       vv=[[[UIView alloc]initWithFrame:CGRectMake(10,10,320,25)] autorelease];
    }

 
    UIImage *backgroundImage = [UIImage imageNamed:@"authors_header_image"];
    UIImageView *imView = [[UIImageView alloc]initWithImage:backgroundImage];
    imView.frame = CGRectMake(0,0,vv.frame.size.width,vv.frame.size.height);
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10,0,50,20)]; 
    label.text=[self.letters objectAtIndex:section];
    label.textColor= [UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    label.backgroundColor=[UIColor clearColor];
    [imView addSubview:label];
    [vv addSubview:imView];
    [vv sendSubviewToBack:imView];
    //[backgroundImage release];
    [imView release];
    [label release];
    
    return vv;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *vv;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
       vv=[[[UIView alloc]initWithFrame:CGRectMake(10,0,768,3)]autorelease];
    }
    else{
        vv=[[[UIView alloc]initWithFrame:CGRectMake(10,0,320,3)]autorelease];
    }
    
    //UIView *vv=[[[UIView alloc]initWithFrame:CGRectMake(10,0,320,3)]autorelease];
    UIImage *backgroundImage = [UIImage imageNamed:@"authors_header_image"];
    UIImageView *imView = [[UIImageView alloc]initWithImage:backgroundImage];
    imView.frame = CGRectMake(0,0,vv.frame.size.width,vv.frame.size.height);
    [vv addSubview:imView];
    //[backgroundImage release];
    [imView release];
    
    return vv;
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.letters;
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    //UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10,10, 50,20)]; 
    //label.text=[self.letters objectAtIndex:index];
    //label.textColor= [UIColor blueColor];
    return [self.letters indexOfObject:title];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
          return 10.0;
        }
        else{
          return 3.0;
        }
    } 
    return 25.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
        return 3.0;
    
    return 3.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Author *author = [self authorAtIndexPath:indexPath];
    AuthorViewController *authVc = [[AuthorViewController alloc] initWithAuthor:author conferenceController:confController];
    [self.navigationController pushViewController:authVc animated:YES];
    [authVc release];
}

@end
