//
//  ConfSearchViewController.m
//  ConfComp
//
//  Created by Antoan Tateosian on 02.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "ConfSearchViewController.h"
#import "ConferenceController.h"
#import "Author.h"
#import "ConfSession.h"
#import "Presentation.h"
#import "PresentationViewController.h"
#import "AuthorViewController.h"
#import "UIAlertView-Helpers.h"
#import "UITableViewCell-Helpers.h"
#import "Constants.h"
#import "SessionViewController.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "MainViewController.h"
#import "UIViewController+CommonClass.h"

@interface ConfSearchViewController ()

@property (nonatomic, retain) NSMutableArray *searchPresentations;
@property (nonatomic, retain) NSMutableArray *searchSessions;
@property (nonatomic, retain) NSMutableArray *searchAuthors;
@property (nonatomic, retain) NSMutableArray *searchInstitutions;

- (void) searchPresentation:(NSString*)searchString;
- (void) searchSession:(NSString*)searchString;
- (void) performSearch;
- (void) switchTableSection:(NSIndexPath*)indexPath;
@end

@implementation ConfSearchViewController

#define SEARCH_SECTION__PRESENTATIONS 0
#define SEARCH_SECTION__SESSIONS 1
#define SEARCH_SESSION__AUTHORS 2

@synthesize searchPresentations = _searchPresentations;
@synthesize searchSessions = _searchSessions;
@synthesize searchAuthors = _searchAuthors;
@synthesize searchInstitutions = _searchInstitutions;
@synthesize searchBar = _searchBar;
@synthesize tblView = _tblView;


- (id) initWithConferenceController:(ConferenceController *)conferenceController
{
    if ((self = [super initWithNibName:@"ConfSearch" bundle:[NSBundle mainBundle]]))
    {
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

- (void) dealloc
{
    [_searchPresentations release];
    [_searchSessions release];
    [_searchAuthors release];
    [_searchInstitutions release];
    [_searchBar release];
    [_tblView release];
    //isChecked=nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.tblView respondsToSelector:@selector(setBackgroundView:)]) {
        [self.tblView setBackgroundView:nil];
    }
    self.tblView.backgroundColor = [UIColor clearColor];
    [self importCommonView:confController];
      // UIImage *backgroundImage = [UIImage imageNamed:@"search_cancel_button"];
    //[self.searchBar setCloseButtonTitle:@"Cancel" forState:UIControlStateNormal]; 
    //[self.searchBar setCancelButtonImage:backgroundImage forState:UIControlStateNormal]; 
    //self.title = @"Search";
    
    //[self.searchBar becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *backgroundImage=nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        backgroundImage = 
                [UIImage imageNamed:@"background_navbar_search_ipad"];
    }
    else
    {
        backgroundImage = 
                [UIImage imageNamed:@"background_navbar_search"];
    }
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675329];
    }

    [self.tblView reloadData];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self.navigationController navigationBar] resetBackground:8675329];
}


- (void)viewDidUnload
{
    self.searchBar = nil;
    self.tblView = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) searchPresentation:(NSString*)searchString
{
    NSMutableArray *presentationsFound=[[NSMutableArray alloc]init];
    NSArray *allPresentations = [confController presentations];
    for (Presentation *currPresentation in allPresentations)
    {
        if ([currPresentation.title rangeOfString:searchString options:NSCaseInsensitiveSearch].length > 0)
        {
            [presentationsFound addObject:currPresentation];
        }
    }
    self.searchPresentations=presentationsFound;
    [presentationsFound release];
}

- (void) searchAuthor:(NSString*)searchString
{
    NSMutableArray *foundAuthors = [[NSMutableArray alloc] init];
    NSArray *allAuthors = [confController authors];
    for (Author *currAuthor in allAuthors)
    {
        if ([currAuthor.name rangeOfString:searchString options:NSCaseInsensitiveSearch].length > 0)
        {
            [foundAuthors addObject:currAuthor];
        }
        //NSLog(@"The author name is:%@",currAuthor.name);
    }
    self.searchAuthors = foundAuthors;
    [foundAuthors release];
}

- (void) searchSession:(NSString*)searchString
{
    NSMutableArray* sessionsFound=[[NSMutableArray alloc]init];
    NSArray *allSessions = [confController sessions];
    for (ConfSession *currSession in allSessions)
    {
        if ([currSession.name rangeOfString:searchString options:NSCaseInsensitiveSearch].length > 0)
        {
            [sessionsFound addObject:currSession];
        }
    }
    self.searchSessions = sessionsFound;
    [sessionsFound release];
}

- (void) performSearch
{
    NSString *searchString = self.searchBar.text;
    
    [self searchAuthor:searchString];
    
    [self searchPresentation:searchString];    
    
    [self searchSession:searchString]; 

    searchPerformed = YES;
    [self.tblView reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDataSource methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case SEARCH_SECTION__PRESENTATIONS:
            return [self.searchPresentations count];
        case SEARCH_SECTION__SESSIONS:
            return [self.searchSessions count];
        case SEARCH_SESSION__AUTHORS:
            return [self.searchAuthors count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SearchCellIdentifier = @"SearchCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchCellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchCellIdentifier] autorelease];
    }
    
    NSString *text = nil;
    UIColor *markColor = [UIColor clearColor];
    
    switch (indexPath.section)
    {
        case SEARCH_SECTION__PRESENTATIONS:
        {
            Presentation *pres = [self.searchPresentations objectAtIndex:indexPath.row];
            text = pres.title;
            break;
        }
        case SEARCH_SECTION__SESSIONS:
        {
            ConfSession *sess = [self.searchSessions objectAtIndex:indexPath.row];
            text = sess.name;
            break;
        }
        case SEARCH_SESSION__AUTHORS:
        {
        Author *auth = [self.searchAuthors objectAtIndex:indexPath.row];
        text = auth.name;
        break;
        }
        default:
            break;
    }
    
    cell.textLabel.text = text;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setMarkWithColor:markColor leftOffset:MARK_LEFT_OFFSET_PLAIN];

    return cell;
}

- (void) switchTableSection:(NSIndexPath*)indexPath
{
    switch (indexPath.section)
    {
        case SEARCH_SECTION__PRESENTATIONS:
        {
            SessionPaper *pres = [self.searchPresentations objectAtIndex:indexPath.row];
            PresentationViewController *presVc = [[PresentationViewController alloc] initWithPresentation:pres conferenceController:confController];
            [self.navigationController pushViewController:presVc animated:YES];
            [presVc release];            
            break;
        }
        case SEARCH_SECTION__SESSIONS:
        {
            ConfSession *sess = [self.searchSessions objectAtIndex:indexPath.row];
            SessionViewController *session=[[SessionViewController alloc]initWithSession:sess conferenceController:confController];
            [self.navigationController pushViewController:session animated:YES];
            [session release];
            break;
        }
        case SEARCH_SESSION__AUTHORS:
        {
            Author *auth = [self.searchAuthors objectAtIndex:indexPath.row];
            AuthorViewController *authVc = [[AuthorViewController alloc] initWithAuthor:auth conferenceController:confController];
            [self.navigationController pushViewController:authVc animated:YES];
            [authVc release];
            break;
        }
        default:
            break;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self switchTableSection:indexPath];
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    NSArray *searchField = nil;
    switch (section)
    {
        case SEARCH_SECTION__PRESENTATIONS:
        {
            title = @"Presentations";
            searchField = self.searchPresentations;
            break;
        }
        case SEARCH_SECTION__SESSIONS:
        {
            title =  @"Sessions";
            searchField = self.searchSessions;
            break;
        }
        case SEARCH_SESSION__AUTHORS:
        {
            title = @"Authors";
            searchField = self.searchAuthors;
            break;
        }
        default:
            return nil;
    }
    
    if (searchPerformed)
    {
        title = [NSString stringWithFormat:@"%@ (%d results)", title, [searchField count]];
    }
    
    return title;
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
