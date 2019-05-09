//
//  ExhibitorsViewController.m
//  ConfComp
//
//  Created by Antoan Tateosian on 29.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "ExhibitorsViewController.h"

#import "Exhibitor.h"
#import "ExhibitorViewController.h"
#import "ExhibitorsTableViewCell.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "UIViewController+CommonClass.h"

@interface ExhibitorsViewController ()

@property (nonatomic, retain) NSMutableArray *searchExhibitors;
- (void) performSearch;

@end

@implementation ExhibitorsViewController

@synthesize tableView=_tableView;
@synthesize searchBar=_searchBar;
@synthesize searchExhibitors=_searchExhibitors;

- (id) initWithExhibitors:(NSArray *)inExhibitors conferenceController:(ConferenceController *)conferenceController
{
    if ((self = [super initWithNibName:@"Exhibitors" bundle:[NSBundle mainBundle]]))
    {
        exhibitors = [inExhibitors retain];
        confController = conferenceController;
        searchPerformed = NO;
    }
    
    return self;
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
    if ([self.tableView respondsToSelector:@selector(setBackgroundView:)]) {
        [self.tableView setBackgroundView:nil];
    }
    self.tableView.backgroundColor = [UIColor clearColor];
    
//    Exhibitor *ex=[[Exhibitor alloc] init];
//    ex.name=@"Baba qga";
//    ex.descr=@"dffadfadfafadfdffadfa";
//    ex.urlAddress=@"www.apple.com";
//    ex.exhibitorId = 11;
//    for(int i=0;i<=10;i++){[exhibitors insertObject:ex atIndex:i]; }
    [self importCommonView:confController];

    //self.title = @"Exhibitors";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    
    UIImage *backgroundImage = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        backgroundImage = [UIImage imageNamed:@"background_navbar_exhibitors_ipad"];
    }else{ backgroundImage = [UIImage imageNamed:@"background_navbar_exhibitors"]; 
    }

    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675340];
    }
    
    [self.tableView reloadData];
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self.navigationController navigationBar] resetBackground:8675340];
}

- (void) dealloc
{
    [exhibitors release];
    [_tableView release];
    [_searchBar release];
    [_searchExhibitors release];
    
    [super dealloc];
}


- (void) performSearch
{
    NSString *searchString = self.searchBar.text;
    
    // search presentations
    NSMutableArray *foundExpo = [[NSMutableArray alloc] init];
   // NSArray *allExhibitors = exhibitors;
    for (Exhibitor *currExhibitors in exhibitors)
    {
        //NSLog(@"Names is: %@",currExhibitors.name);
        if ([currExhibitors.name rangeOfString:searchString options:NSCaseInsensitiveSearch].length > 0)
        {
            [foundExpo addObject:currExhibitors];
        }
    }
    self.searchExhibitors = foundExpo;
    
    [foundExpo release];
    searchPerformed=YES;
    [self.tableView reloadData];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if(searchPerformed == YES)
    {
        //NSLog(@"The found results is:%d",[self.searchExhibitors count]);
        return [self.searchExhibitors count];
    }
    else
    { 
        return [exhibitors count]; 
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;    
    Exhibitor *expo = nil;
    
    if(searchPerformed == YES)
    {
        if([self.searchExhibitors count] == 1)
        {
            expo = [self.searchExhibitors objectAtIndex:0];
            //text = expo.name;
        }
        else
        {
            expo = [self.searchExhibitors objectAtIndex:indexPath.section];
            //text = expo.name;
        }
    }
    else
    {
        expo = [exhibitors objectAtIndex:indexPath.section];
    }
    cell = [ExhibitorsTableViewCell cellWithExhibitor:expo table:self.tableView:indexPath.section];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Exhibitor *expo=nil;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(searchPerformed == YES)
    {
        if([self.searchExhibitors count] == 1)
        {
            expo = [self.searchExhibitors objectAtIndex:0];
            
        }
        else
        {
            expo = [self.searchExhibitors objectAtIndex:indexPath.section];
            
        }
    }
    else
    {
        expo = [exhibitors objectAtIndex:indexPath.section];
    }
    
    ExhibitorViewController *exVc = [[ExhibitorViewController alloc] initWithExhibitor:expo conferenceController:confController];
    [self.navigationController pushViewController:exVc animated:YES];
    [exVc release];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    NSArray *searchField = nil;
    
    if(section == 0){
        searchField = self.searchExhibitors;
    }
    if (searchPerformed)
    {
        if(section == 0)
        {
            title = @"Exhibitors";
            title = [NSString stringWithFormat:@"%@ (%d results)", title, [searchField count]];
        }
    }
     return title;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(searchPerformed ==YES){
        if(section == 0){
            return 25.0;
        }
    }
    return 3.0;
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 3.0;
}*/

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
         return 76.0;
    }else{
       return 73.0;
    }

}


#pragma mark -
#pragma mark UISearchBarDelegate methods

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    [self performSearch];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

@end
