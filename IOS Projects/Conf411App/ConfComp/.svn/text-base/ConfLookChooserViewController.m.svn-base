//
//  ConfLookChooserViewController.m
//  ConfComp
//
//  Created by Antoan Tateosian on 03.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "ConfLookChooserViewController.h"

#import "ConfDay.h"
#import "ConferenceListViewController.h"
#import "ConferenceGridViewController.h"

@implementation ConfLookChooserViewController

#define CONF_LOOK__ROW_LIST 0
#define CONF_LOOK__ROW_GRID 1

- (id) initWithDay:(ConfDay *)inDay conferenceController:(ConferenceController *)conferenceController
{
    if ((self = [super initWithNibName:@"ConfLookChooser" bundle:[NSBundle mainBundle]]))
    {
        day = [inDay retain];
        confController = conferenceController;
    }
    
    return self;
}

- (void) didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) dealloc
{
    [day release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];

    self.title = day.name;
    
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

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    NSString *text = nil;
    if (indexPath.row == CONF_LOOK__ROW_LIST)
    {
        text = @"List view";
    }
    else
    {
        text = @"Grid view";
    }
    
    cell.textLabel.text = text;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == CONF_LOOK__ROW_LIST)
    {
//        ConferenceListViewController *listVc = [[ConferenceListViewController alloc] initWithDay:day conferenceController:confController];
//        [self.navigationController pushViewController:listVc animated:YES];
//        [listVc release];
    }
    else
    {
//        ConferenceGridViewController *gridVc = [[ConferenceGridViewController alloc] initWithDay:day conferenceController:confController];
//        [self.navigationController pushViewController:gridVc animated:YES];
//        [gridVc release];
    }
}

@end
