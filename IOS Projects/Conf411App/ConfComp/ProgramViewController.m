//
//  ProgramViewController.m
//  Conference411
//
//  Created by Petko Yanakiev on 3/1/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import "ProgramViewController.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "ConferenceController.h"
#import "ConfSession.h"
#import "ConfTimeFrame.h"
#import "ProgramSessionViewController.h"
#import "UIViewController+CommonClass.h"

@implementation ProgramViewController

@synthesize programTable=_programTable;
@synthesize sessArray=_sessArray;


- (id) initWithConferenceController:(ConferenceController *)conferenceController{

    if ((self = [super initWithNibName:@"ProgramViewController" bundle:[NSBundle mainBundle]]))
    {
        confController = conferenceController;
    }
    return self;
       
}

-(void) viewDidLoad{
    
    [super viewDidLoad];
    if ([self.programTable respondsToSelector:@selector(setBackgroundView:)]) {
        [self.programTable setBackgroundView:nil];
    }
    self.programTable.backgroundColor = [UIColor clearColor];

    [self importCommonView:confController];
    
    NSMutableSet *tempSet=[[NSMutableSet alloc]init];
    NSMutableArray  *sarray=[[NSMutableArray alloc]init];
    for (ConfSession *sess in confController.sessions)
    {
        if (![tempSet containsObject:sess.sessionType]) 
        {
            [tempSet addObject:sess.sessionType];
             [sarray addObject:sess.sessionType];
        }
    }
    [tempSet release];
    
    
    [sarray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString*) obj1 compare:(NSString*) obj2 options:  NSCaseInsensitiveSearch];
    }];
    [sarray insertObject:@"All sessions" atIndex:0];
    self.sessArray=sarray;
    [sarray release];
}


-(void) viewDidUnload{
    [super viewDidUnload];
}

-(void) viewWillAppear:(BOOL)animated {
    
    UIImage *backgroundImage = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        backgroundImage = [UIImage imageNamed:@"background_navbar_program_ipad"];
    }
    else
    {
        backgroundImage = [UIImage imageNamed:@"background_navbar_program"];
    }

    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675311];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [[self.navigationController navigationBar] resetBackground:8765311];
}

-(void) dealloc{

    [_programTable release];
    [_sessArray release];
    [super dealloc];
}

#pragma mark - Table view data source
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sessArray count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text=[self.sessArray objectAtIndex:indexPath.section];
    cell.textLabel.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 10.0;
    
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3.0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *sType = [self.sessArray objectAtIndex:indexPath.section];
    ProgramSessionViewController *psVc = [[ProgramSessionViewController alloc] initProgramSessionViewController:sType:confController];
    [self.navigationController pushViewController:psVc animated:YES];
    [psVc release];
}
@end