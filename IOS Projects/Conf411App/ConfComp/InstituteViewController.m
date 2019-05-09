//
//  InstituteViewController.m
//  ConfComp
//
//  Created by Antoan Tateosian on 30.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "InstituteViewController.h"

#import "Constants.h"
#import "Institution.h"
#import "ConferenceController.h"
#import "AuthorViewController.h"
#import "UITableViewCell-Helpers.h"

@implementation InstituteViewController

- (id) initWithInstitute:(Institution *)inInstitute conferenceController:(ConferenceController *)inConfController
{
    if ((self = [super initWithNibName:@"Institute" bundle:[NSBundle mainBundle]]))
    {
        institute = [inInstitute retain];
        confController = inConfController;
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

- (void) viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Institution";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) dealloc
{
    [institute release];
    
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
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return [institute.people count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    if (indexPath.section == 0)
    {
        static NSString *InstituteCellIdentifier = @"InstituteCellIdentifier";
        
        cell = [UITableViewCell dynamicHeightCellWithIdentifier:InstituteCellIdentifier 
                                                          table:tableView 
                                                           text:institute.name 
                                                           font:[UIFont boldSystemFontOfSize:16.0]
                                                   acessoryType:UITableViewCellAccessoryNone];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        static NSString *PeopleCellIdentifier = @"PeopleCellIdentifier";
        
        cell = [tableView dequeueReusableCellWithIdentifier:PeopleCellIdentifier];
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PeopleCellIdentifier] autorelease];
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.text = [[institute.people objectAtIndex:indexPath.row] name];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return [UITableViewCell heightForDynamicCellWithText:institute.name font:[UIFont boldSystemFontOfSize:16.0]];
    }
    else
    {
        return 30.0;
    }
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return @"People";
    }
    else
    {
        return nil;
    }
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Author *auth = [institute.people objectAtIndex:indexPath.row];
    AuthorViewController *authVc = [[AuthorViewController alloc] initWithAuthor:auth conferenceController:confController];
    [self.navigationController pushViewController:authVc animated:YES];
    [authVc release];
}

@end
