//
//  ProgramSessionViewController.m
//  Conference411
//
//  Created by Petko Yanakiev on 3/1/12.
//  Copyright (c) 2012 EGT. All rights reserved.
//

#import "ProgramSessionViewController.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "ConfSession.h"
#import "CalendarTableViewCell.h"
#import "ConfTimeFrame.h"
#import "Place.h"
#import "ConfDay.h"
#import "SessionViewController.h"
#import "ConferenceController.h"
#import "UIViewController+CommonClass.h"
#define commonColor [UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];

@implementation ProgramSessionViewController

@synthesize programSessionTable=_programSessionTable;
@synthesize sessArray=_sessArray;
@synthesize type=_type;
@synthesize sortedArray=_sortedArray;


-(id) initProgramSessionViewController:(NSString*) pType:(ConferenceController*)conferenceController{
    
    if ((self = [super initWithNibName:@"ProgramSessionViewController" bundle:[NSBundle mainBundle]]))
    {
        self.type=pType;
        confController = conferenceController;
    }
    return self;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.programSessionTable respondsToSelector:@selector(setBackgroundView:)]) {
        [self.programSessionTable setBackgroundView:nil];
    }
    self.programSessionTable.backgroundColor = [UIColor clearColor];
    
    [self importCommonView:confController];

    
    if([self.type isEqualToString:@"All sessions"])
    {
        self.sessArray= [NSMutableArray arrayWithArray:confController.sessions];
    }
    else
    {
        self.sessArray=[[[NSMutableArray alloc]init]autorelease];
        for(ConfSession *sess in confController.sessions)
        {
             if([sess.sessionType isEqualToString:self.type]){
                [self.sessArray addObject:sess];
              }
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
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
    [_programSessionTable release];
    [_sessArray release];
    [_sortedArray release];
    [_type release];
    [super dealloc];
    
}

#pragma mark - Table view data source
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{ 
    
   self.sortedArray = [self.sessArray sortedArrayUsingSelector:@selector(compare:)];
    
//    [(NSMutableArray*) self.sessArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) 
//     {
//         ConfSession *sess1 = (ConfSession*)obj1;
//         ConfSession *sess2 = (ConfSession*)obj2;
//         if([sess1.timeStr compare:sess2.timeStr] == NSOrderedSame)
//             return [sess1.sessionNumber compare:sess2.sessionNumber];
//              
//         else if ([sess1.sessionNumber compare:sess2.sessionNumber] == NSOrderedSame) 
//              return [sess1.name compare:sess2.name];
//         else  
//              return [sess1.timeStr compare:sess2.timeStr];
//     }];
    return [self.sortedArray count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ return 1; }

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CalendarTableViewCellIdentifier];
    if (cell == nil){
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:
                         @"CalendarTableViewCell" owner:nil options:nil];
        for (id obj in objs){
            if ([obj isKindOfClass:[CalendarTableViewCell class]]){
                cell = obj;
                break;
            }
        }
    }
    
    CalendarTableViewCell *callCell = (CalendarTableViewCell *)cell;
    ConfSession *session = [self.sortedArray objectAtIndex:indexPath.section];
    callCell.lblStaticText.textColor = commonColor;
    callCell.lblName.textColor=commonColor;
    callCell.lblCount.textColor=commonColor;
    
    callCell.lblPlace.font=[UIFont boldSystemFontOfSize:14.0];
    callCell.lblName.font=[UIFont boldSystemFontOfSize:14.0];
    callCell.lblStaticText.font=[UIFont boldSystemFontOfSize:14.0];
    
    callCell.lblName.text=session.name;
    callCell.lblDateStr.text=session.day.dateStr;
    callCell.lblTimeFrame.text=session.timeStr;
    callCell.lblPlace.text=session.place.name;
    callCell.lblStaticText.text=session.sessionType;
    callCell.lblSessionNumber.text=session.sessionNumber;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return callCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{ return 3.0; }

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{ return 3.0; }

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ConfSession *session = [self.sortedArray objectAtIndex:indexPath.section];
    SessionViewController *sessionVc = [[SessionViewController alloc] initWithSession:session conferenceController:confController];
    [self.navigationController pushViewController:sessionVc animated:YES];
    [sessionVc release];
}
@end