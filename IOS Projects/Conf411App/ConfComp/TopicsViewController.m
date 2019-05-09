//
//  TopicsViewController.m
//  ConfComp
//
//  Created by Antoan Tateosian on 05.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "TopicsViewController.h"

#import "Topic.h"
#import "TopicViewController.h"
#import "UITableViewCell-Helpers.h"
#import "Constants.h"

@implementation TopicsViewController

- (id) initWithTopics:(NSArray *)inTopics conferenceController:(ConferenceController *)conferenceController
{
    if ((self = [super initWithNibName:@"Topics" bundle:[NSBundle mainBundle]]))
    {
        topics = [inTopics retain];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Topics";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData]; // for some reason the mark view is not shown initially...
    
    /*[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:PRES_SECTION__PRESENTATION_NAME]]
     withRowAnimation:UITableViewRowAnimationNone];*/
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

- (void) dealloc
{
    [topics release];
    
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [topics count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Topic *topic = [topics objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = topic.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell setMarkWithColor:topic.markColor leftOffset:MARK_LEFT_OFFSET_PLAIN];
    
    return cell;
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Topic *topic = [topics objectAtIndex:indexPath.row];
    TopicViewController *topicVc = [[TopicViewController alloc] initWithTopic:topic conferenceController:confController];
    [self.navigationController pushViewController:topicVc animated:YES];
    [topicVc release];
}

@end
