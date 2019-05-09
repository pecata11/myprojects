//
//  InstitutionsViewController.m
//  ConfComp
//
//  Created by Antoan Tateosian on 30.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "InstitutionsViewController.h"

#import "Institution.h"
#import "InstituteViewController.h"

@interface InstitutionsViewController ()

@property (nonatomic, retain) NSArray *letters;
@property (nonatomic, retain) NSDictionary *letterToInstitutesMapping;

- (void) loadInstitutions;

- (Institution *) institutionAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation InstitutionsViewController

@synthesize letters = _letters;
@synthesize letterToInstitutesMapping = _letterToInstitutesMapping;

- (id) initWithInstitutions:(NSArray *)inInstitutions conferenceController:(id)inConfController
{
    if ((self = [super initWithNibName:@"Institutions" bundle:[NSBundle mainBundle]]))
    {
        institutions = [inInstitutions retain];
        confController = inConfController;
    }
    
    return self;
}

- (void) loadInstitutions
{
    NSMutableArray *lets = [[NSMutableArray alloc] initWithCapacity:30];
    NSMutableDictionary *mapping = [[NSMutableDictionary alloc] initWithCapacity:30];
    
    for (Institution *currInst in institutions)
    {
        NSString *firstLetter = [[currInst.name substringToIndex:1] uppercaseString];
        NSMutableArray *insts = [mapping valueForKey:firstLetter];
        if (insts == nil)
        {
            [lets addObject:firstLetter];
            [mapping setValue:[NSMutableArray arrayWithObject:currInst] forKey:firstLetter];
        }
        else
        {
            [insts addObject:currInst];
        }
    }
    
    self.letters = lets;
    self.letterToInstitutesMapping = mapping;
    
    [lets release];
    [mapping release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) dealloc
{
    [institutions release];
    [_letters release];
    [_letterToInstitutesMapping release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Institutions";
    
    [self loadInstitutions];
    
    [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (Institution *) institutionAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *firstLetter = [self.letters objectAtIndex:indexPath.section];
    NSArray *insts = [self.letterToInstitutesMapping valueForKey:firstLetter];
    Institution *inst = [insts objectAtIndex:indexPath.row];
    return inst;
}

- (void) viewDidUnload
{
    self.letters = nil;
    self.letterToInstitutesMapping = nil;
    
    [super viewDidUnload];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
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
    NSArray *insts = [self.letterToInstitutesMapping valueForKey:firstLetter];
    return [insts count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Institution *inst = [self institutionAtIndexPath:indexPath];
    
    cell.textLabel.text = inst.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.letters objectAtIndex:section];
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.letters;
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.letters indexOfObject:title];
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Institution *inst = [self institutionAtIndexPath:indexPath];
    
    InstituteViewController *instVc = [[InstituteViewController alloc] initWithInstitute:inst conferenceController:confController];
    [self.navigationController pushViewController:instVc animated:YES];
    [instVc release];
}

@end
