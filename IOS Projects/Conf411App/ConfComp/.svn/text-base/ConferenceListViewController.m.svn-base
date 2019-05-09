//
//  ConferenceListViewController.m
//  ConfComp
//
//  Created by Antoan Tateosian on 03.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "ConferenceListViewController.h"
#import "ConfDay.h"
#import "ConferenceController.h"
#import "ConfSession.h"
#import "SessionViewController.h"
#import "CalendarTableViewCell.h"
#import "Place.h"
#import "MainViewController.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "UIViewController+CommonClass.h"

@implementation ConferenceListViewController

@synthesize tableViewCalendar,daysControl,isChecked;

- (id) initWithDay:(ConfDay *)inDay conferenceController:(ConferenceController *)conferenceController:(NSArray*) daysSess
{
    if ((self = [super initWithNibName:@"ConferenceList" bundle:[NSBundle mainBundle]]))
    {
        day = [inDay retain];
        days = [daysSess retain];
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
    [day release];
    [sessArray release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    if ([self.tableViewCalendar respondsToSelector:@selector(setBackgroundView:)]) {
        [self.tableViewCalendar setBackgroundView:nil];
    }
    self.tableViewCalendar.backgroundColor = [UIColor clearColor];

    
    [self importCommonView:confController];
    
    //self.title = day.name;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    //self.navigationItem.backBarButtonItem =backButton;
    [backButton release];
    NSArray* daysFiltered=[self fillSegmentedControl:days];
    daysControl = [[UISegmentedControl alloc] initWithItems:daysFiltered];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
         daysControl.frame = CGRectMake(0, 0, 768, 40);
    }else{
         daysControl.frame = CGRectMake(0, 0, 320, 30);
    }
    daysControl.segmentedControlStyle = UISegmentedControlStyleBar;
    daysControl.selectedSegmentIndex = 0;
	[daysControl addTarget:self
	                     action:@selector(pickOne:)
	           forControlEvents:UIControlEventValueChanged];
  
    //daysControl.tintColor=[UIColor lightGrayColor];
    
    [self.view addSubview:daysControl];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSMutableArray*)filterDays:(NSArray *)sessDays:(NSArray *)daysArray {
    
    NSMutableArray *filtDays=[[[NSMutableArray alloc]init]autorelease];
    NSMutableArray *origDays = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [sessDays count]; i++)
    {
        ConfDay *dd = [sessDays objectAtIndex:i];
        if([dd.sessions count] != 0)
        {   
            [origDays addObject:dd.name];
        }
    }
    for(NSString* dayName in origDays)
    {
        for(NSString *item in daysArray)
        {
            if ([dayName rangeOfString:item].location != NSNotFound) 
            {
                NSString* mystr = nil;
                if([item isEqualToString:@"Thursday"])
                {
                    mystr=[item substringToIndex:4];
                    
                }
                else
                {
                    mystr=[item substringToIndex:3];
                }
                [filtDays addObject:mystr];
            }
        }
    }
    [origDays release];
    return filtDays;
}

-(NSArray*)fillSegmentedControl:(NSArray*) sessDays{
    
    NSMutableArray *filteredDays=[[[NSMutableArray alloc]init]autorelease];
    
    NSArray *defaultDays = [NSArray arrayWithObjects: @"Sunday", @"Monday", @"Tuesday",@"Wednesday", @"Thursday",@"Friday", @"Saturday", nil];
    
    if([sessDays count] != 0)
    {
        filteredDays =  [self filterDays:sessDays:defaultDays];
        return filteredDays;
    }
      //filled with default values.
        for(NSString *item in defaultDays)
        {
            NSString* mystr = nil;
            if([item isEqualToString:@"Thursday"])
            {
                mystr=[item substringToIndex:4];
            }
            else
            {
                mystr=[item substringToIndex:3];
            }
            [filteredDays addObject:mystr];
        }
        return filteredDays;
}


//Action method executes when user touches the button
- (void) pickOne:(id)sender{
    [self.tableViewCalendar reloadData];
} 
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillAppear:(BOOL)animated {
  
    UIImage *backgroundImage = nil;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        backgroundImage = [UIImage imageNamed:@"background_navbar_calendar_ipad"];
    }
    else{
        backgroundImage = [UIImage imageNamed:@"background_navbar_calendar"]; 
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
   if([days count] != 0)
   {
       for(int i = 0; i <= [days count] - 1; i++)
       {
           ConfDay *dd = [days objectAtIndex:i];
           if (daysControl.selectedSegmentIndex == i)
           {
               NSArray *sortedArray = 
               [dd.sessions sortedArrayUsingSelector:@selector(compare:)];
               return [self combineSessions:sortedArray];
           }
       }
    }
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger) combineSessions:(NSArray*) daySessions{
   
    sessArray = [[NSMutableArray alloc] init];
    for (int i = 0, q = 0; i <= [daySessions count]-1; i++, q++) 
    {
        ConfSession *session = [daySessions objectAtIndex:i];
        [sessArray insertObject:session atIndex:q];
        //[session release];
    }
    
    return [sessArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CalendarTableViewCellIdentifier];
    if (cell == nil)
    {
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:
                         @"CalendarTableViewCell" owner:nil options:nil];
        for (id obj in objs)
        {
            if ([obj isKindOfClass:[CalendarTableViewCell class]])
            {
                cell = obj;
                break;
            }
        }
    }
    
    CalendarTableViewCell *callCell = (CalendarTableViewCell *)cell;   
   //ConfTimeFrame *frame = [day.timeFrames objectAtIndex:indexPath.section];
    ConfSession *session = [sessArray objectAtIndex:indexPath.section];
    callCell.lblStaticText.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    callCell.lblStaticText.text=session.sessionType;
    callCell.lblName.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    callCell.lblCount.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    callCell.lblName.text=session.name;
    callCell.lblDateStr.text=session.day.dateStr;
    callCell.lblTimeFrame.text=session.timeStr;
    callCell.lblPlace.text=session.place.name;
    
    callCell.lblSessionNumber.text=session.sessionNumber;
    
    callCell.lblPlace.font=[UIFont boldSystemFontOfSize:14.0];
    callCell.lblName.font=[UIFont boldSystemFontOfSize:14.0];
    callCell.lblStaticText.font=[UIFont boldSystemFontOfSize:14.0];
    callCell.lblCount.text = @"";
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

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //ConfTimeFrame *frame = [day.timeFrames objectAtIndex:section];
    return @""; 
    //[NSString stringWithFormat:@"%@ - %@", frame.timeStr, frame.type];
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //ConfTimeFrame *frame = [day.timeFrames objectAtIndex:indexPath.section];
    ConfSession *session = [sessArray objectAtIndex:indexPath.section];
    SessionViewController *sessionVc = [[SessionViewController alloc] initWithSession:session conferenceController:confController];
    [self.navigationController pushViewController:sessionVc animated:YES];
    [sessionVc release];
}
@end
