//
//  TopicViewController.m
//  ConfComp
//
//  Created by Antoan Tateosian on 05.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "TopicViewController.h"

#import "Topic.h"
#import "ConferenceController.h"
#import "Presentation.h"
#import "PresentationTableViewCell.h"
#import "Author.h"
#import "Institution.h"
#import "PresentationViewController.h"
#import "Utils.h"
#import "UITableViewCell-Helpers.h"
#import "Constants.h"

@interface TopicViewController ()

- (void) btnMarkPressed:(id)sender;

@end

@implementation TopicViewController

#define TOPIC__SECTION_NAME 0
#define TOPIC__SECTION_PRESENTATIONS 1

- (id) initWithTopic:(Topic *)inTopic conferenceController:(ConferenceController *)conferenceController
{
    if ((self = [super initWithNibName:@"Topic" bundle:[NSBundle mainBundle]]))
    {
        topic = [inTopic retain];
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
    [topic release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Topic";
    
    UIBarButtonItem *btnMark = [[UIBarButtonItem alloc] initWithTitle:[Utils markedToString:topic.isMarked] style:UIBarButtonItemStyleBordered target:self action:@selector(btnMarkPressed:)];
    self.navigationItem.rightBarButtonItem = btnMark;
    [btnMark release];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData]; // for some reason the mark view is not shown initially...
}

- (void) btnMarkPressed:(id)sender
{
    topic.marked = !topic.isMarked;
    
    UIBarButtonItem *btnMark = (UIBarButtonItem *)sender;
    [btnMark setTitle:[Utils markedToString:topic.isMarked]];

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
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == TOPIC__SECTION_NAME)
    {
        return 1;
    }
    else
    {
        return [topic.presentations count];
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == TOPIC__SECTION_NAME)
    {
        static NSString *TopicNameIdentifier = @"TopicNameIdentifier";
        
        cell = [tableView dequeueReusableCellWithIdentifier:TopicNameIdentifier];
        
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TopicNameIdentifier] autorelease];
        }
        
        cell.textLabel.text = topic.name;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setMarkWithColor:topic.markColor leftOffset:MARK_LEFT_OFFSET_GROUPED];
    }
    else
    {
        Presentation *presentation = [topic.presentations objectAtIndex:indexPath.row];
        
//        cell = [PresentationTableViewCell cellWithPresentation:presentation table:tableView];
        
        [cell setMarkWithColor:presentation.markColor leftOffset:MARK_LEFT_OFFSET_GROUPED];
    }

    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == TOPIC__SECTION_PRESENTATIONS)
    {
        if ([topic.presentations count] > 0)
        {
            return @"Presentations";
        }
        else
        {
            return @"No presentations";
        }
    }
    else
    {
        return nil;
    }
}

//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == TOPIC__SECTION_PRESENTATIONS)
//    {
////        Presentation *pres = [topic.presentations objectAtIndex:indexPath.row];
////        return [PresentationTableViewCell heightWithPresentation:pres];
//    }
//    else
//    {
//        return 30.0;
//    }
//}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == TOPIC__SECTION_PRESENTATIONS)
    {
//        Presentation *pres = [topic.presentations objectAtIndex:indexPath.row];
//        PresentationViewController *presVc = [[PresentationViewController alloc] initWithPresentation:pres conferenceController:confController];
//        [self.navigationController pushViewController:presVc animated:YES];
//        [presVc release];
    }
}

@end
