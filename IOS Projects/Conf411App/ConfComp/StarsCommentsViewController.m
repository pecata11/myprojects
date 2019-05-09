//
//  StarsCommentsViewController.m
//  ConfComp
//
//  Created by Antoan Tateosian on 05.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "StarsCommentsViewController.h"

#import "Presentation.h"
#import "PresentationViewController.h"
#import "PresentationCommentTableViewCell.h"

@interface StarsCommentsViewController ()

- (NSInteger) scoreToSection:(NSInteger)score;
- (NSInteger) sectionToScore:(NSInteger)section;

- (void) loadFiltered;

@property (nonatomic, retain) NSMutableDictionary *starToPresentationsMapping;

@end

@implementation StarsCommentsViewController

@synthesize starToPresentationsMapping = _starToPresentationsMapping;

- (id) initWithPresentations:(NSArray *)inPresentations conferenceController:(ConferenceController *)conferenceController
{
    if ((self = [super initWithNibName:@"StarsComments" bundle:[NSBundle mainBundle]]))
    {
        origPresentations = [inPresentations retain];
        confController = conferenceController;
    }
    
    return self;
}

- (void) loadFiltered
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    self.starToPresentationsMapping = dict;
    [dict release];
    
    for (Presentation *currPresentation in origPresentations)
    {
        if (currPresentation.score > 0 || [currPresentation.comment length] > 0)
        {
            NSInteger score = currPresentation.score;
            NSMutableArray *arr = [self.starToPresentationsMapping objectForKey:[NSNumber numberWithInt:score]];
            if (arr == nil)
            {
                arr = [NSMutableArray array];
                [self.starToPresentationsMapping setObject:arr forKey:[NSNumber numberWithInt:score]];
            }
            [arr addObject:currPresentation];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) dealloc
{
    [_starToPresentationsMapping release];
    [origPresentations release];
    
    [super dealloc];
}

- (NSInteger) scoreToSection:(NSInteger)score
{
    return 5 - score;
}

- (NSInteger) sectionToScore:(NSInteger)section
{
    return 5 - section;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Stars and Comments";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadFiltered];
    
    [self.tableView reloadData];
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
    return 6;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *presentations = [self.starToPresentationsMapping objectForKey:[NSNumber numberWithInt:[self sectionToScore:section]]];
    return [presentations count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *presentations = [self.starToPresentationsMapping objectForKey:[NSNumber numberWithInt:[self sectionToScore:indexPath.section]]];
    Presentation *pres = [presentations objectAtIndex:indexPath.row];

    return [PresentationCommentTableViewCell cellWithPresentation:pres table:tableView];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 5)
    {
        return @"No stars, only comments";
    }
    else if (section == 4)
    {
        return @"1 star";
    }
    else
    {
        return [NSString stringWithFormat:@"%d stars", [self sectionToScore:section]];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *presentations = [self.starToPresentationsMapping objectForKey:[NSNumber numberWithInt:[self sectionToScore:indexPath.section]]];
    Presentation *pres = [presentations objectAtIndex:indexPath.row];

    return [PresentationCommentTableViewCell heightWithPresentation:pres];
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    NSArray *presentations = [self.starToPresentationsMapping objectForKey:[NSNumber numberWithInt:[self sectionToScore:indexPath.section]]];
//    Presentation *pres = [presentations objectAtIndex:indexPath.row];
//    PresentationViewController *presVc = [[PresentationViewController alloc] initWithPresentation:pres conferenceController:confController];
//    [self.navigationController pushViewController:presVc animated:YES];
//    [presVc release];
}

@end
