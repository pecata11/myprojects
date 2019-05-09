//
//  ConferenceGridViewController.m
//  ConfComp
//
//  Created by Antoan Tateosian on 03.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.

#import "ConferenceGridViewController.h"
#import "ConfDay.h"
#import <QuartzCore/QuartzCore.h>
#import "ConfSession.h"
#import "PresentationViewController.h"
#import "Utils.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "UIButton+property.h"
#import "AgendaPresentations.h"
#import "UIViewController+CommonClass.h"
#import "SessionPaper.h"

//anonimous category for declaring private methods. 
@interface ConferenceGridViewController ()

- (void) loadTimes;
- (void) getTimeFramesForFirstDay;
-(NSArray*) getSessionsForSelectedDay:(int)dayIndex;
-(NSMutableArray*) getMarkedPresentationsForSelectedDay:(NSArray*)sessions;
-(AgendaPresentations*)parsePressTimeAndConstructAgendaObject:(SessionPaper*)presentation;
-(AgendaPresentations*)calculateStartEndHours:(SessionPaper *)presentation;
-(NSMutableArray*) fillButtonsPositions:(NSMutableArray*) collectMarked;
-(NSMutableArray*) fillButtonsArray:(NSMutableArray*) buttonsPositions;
-(void) loadGrid:(NSMutableArray*)buttons;
-(void) drawAgenda:(int)day;
- (void) daysControlClick:(id)sender;
- (IBAction)buttonClicked:(id)sender;

@end

@implementation ConferenceGridViewController

#define GRID_ROW_HEIGHT 20.0
#define GRID_DIFF_BETWEEN_ROWS 10.0
#define GRID_COL_WIDTH 40.0
#define GRID_TOP_OFFSET 2.0
#define GRID_TIME_LEFT_OFFSET 5.0
#define BUTTON_CORNER_RADIUS 15.0
#define RIGTH_OFFSET_IPHONE 70
#define RIGTH_OFFSET_IPAD 90
#define BUTTON_WIDTH_IPAD 100
#define BUTTON_WIDTH_IPHONE 80
#define BUTTON_OFFSET_IPAD 105
#define BUTTON_OFFSET_IPHONE 90

@synthesize gridView = _gridView;
@synthesize labelView=_labelView;
@synthesize btnMark = _btnMark;
@synthesize daysControl=_daysControl;
@synthesize hourCoordinateMap=_hourCoordinateMap;

- (id) initWithDay:(ConfDay *)inDay conferenceController:(ConferenceController *)conferenceController:(NSArray* )daysSess
{
    if ((self = [super initWithNibName:@"ConferenceGrid" bundle:[NSBundle mainBundle]]))
    {
        days=[daysSess retain];
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
    //[day release];
    [_gridView release];
    [_btnMark release];
    [_labelView release];
    [_hourCoordinateMap release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self importCommonView:confController];
    
    self.navigationItem.rightBarButtonItem = self.btnMark;
    NSArray *Days= [NSArray arrayWithObjects: @"Sun",@"Mon", @"Tue",@"Wed", @"Thur", @"Fri", @"Sat", nil];
    daysControl = [[UISegmentedControl alloc] initWithItems:Days];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        daysControl.frame = CGRectMake(0, 0, 768, 30);
    }else{
        daysControl.frame = CGRectMake(0, 0, 320, 30);
    }

    
    daysControl.segmentedControlStyle = UISegmentedControlStyleBar;
    daysControl.selectedSegmentIndex = 0;
	[daysControl addTarget:self
                    action:@selector(daysControlClick:)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:daysControl];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [self.labelView setContentSize:CGSizeMake(RIGTH_OFFSET_IPAD,4000)];
    }else{
        [self.labelView setContentSize:CGSizeMake(RIGTH_OFFSET_IPHONE,4000)];
    }
  
    self.labelView.delegate=self;
    self.gridView.delegate=self;
    [self.gridView setNeedsDisplay];
    [self getTimeFramesForFirstDay];
}


-(void) drawAgenda:(int)dayIndex{
    
    NSArray *sessions = [self getSessionsForSelectedDay:dayIndex];
    NSMutableArray *presentations = 
                [self getMarkedPresentationsForSelectedDay:sessions];
    NSMutableArray *buttonPositions = 
                [self fillButtonsPositions:presentations];
    NSMutableArray *buttons = 
                [self fillButtonsArray:buttonPositions];
    
    [self loadGrid:buttons];
}

-(void) getTimeFramesForFirstDay{
    
    [self loadTimes];
    [self drawAgenda:0];
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.gridView.subviews)
    {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.gridView.contentSize = contentRect.size;
}

- (void) daysControlClick:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *) sender;
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.gridView.subviews)
    {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.gridView.contentSize = contentRect.size;
   
    int dayIndex = 0;
    for(int i = 0; i < [days count]; i++)
    {
        //clean a gridView here.
        for(UIView *view in self.gridView.subviews){
            if([view isKindOfClass:[UIButton class]]){
                [view removeFromSuperview];
            }
        }
        //we found a matching day with data.
        if ([segment selectedSegmentIndex] == i){
            dayIndex = i;
            break;
        }
    }
    [self loadTimes];
    [self drawAgenda:dayIndex];
}

-(NSArray*) getSessionsForSelectedDay:(int)dayIndex{
    
    ConfDay *day = [days objectAtIndex:dayIndex];
    
    NSMutableArray  *sessions = [[[NSMutableArray alloc] init]autorelease];
    for (int j = [day.sessions count]-1, q = 0; j >= 0; j--, q++) 
    {
        ConfSession *session = [day.sessions objectAtIndex:j];
        [sessions insertObject:session atIndex:q];       
        [session retain];
    }
    return sessions;
}

- (NSMutableArray*) getMarkedPresentationsForSelectedDay:(NSArray*)sessions
{
    NSMutableArray *collectMarked = [[[NSMutableArray alloc] init]autorelease];
    for(ConfSession *session in sessions)
    {
        for(SessionPaper *presentation in session.presentations)
        {
            if(presentation.marked == 1)
            {
                if(presentation.presTime == nil)
                {
                    presentation.presTime = session.timeStr;
                }
                [collectMarked addObject:presentation];
            }
        }
    }
    return collectMarked;
}

-(AgendaPresentations*)parsePressTimeAndConstructAgendaObject:(SessionPaper*)presentation
{
    NSArray  *time = [presentation.presTime componentsSeparatedByString: @"-"];
    NSString *startTime = [time objectAtIndex:0];
    NSString *endTime = [time objectAtIndex:1];
    NSArray *hour = [startTime componentsSeparatedByString:@":"];
    NSArray *minute = [endTime componentsSeparatedByString:@":"];
    
    int startHour=[[hour objectAtIndex:0] intValue];
    int startMinute=[[minute objectAtIndex:0] intValue];
    
    int endHour=[[hour objectAtIndex:1] intValue];
    int endMinute=[[minute objectAtIndex:1] intValue];
    
    //if we have different hours and minutes construct the agenda object.
    if(startHour != endHour || startMinute != endMinute)
    {
        AgendaPresentations *agendaObject = [[[AgendaPresentations alloc]init]autorelease];
        agendaObject.presentationName = presentation.title;
        agendaObject.presentationStartTime = startTime;
        agendaObject.presentationEndTime = endTime;
        agendaObject.presentation = presentation;
        return agendaObject;
    } 
    return nil;
}

-(AgendaPresentations*)calculateStartEndHours:(SessionPaper *)presentation{
    
    AgendaPresentations* agendaObject =[self parsePressTimeAndConstructAgendaObject:presentation];
    
    if(agendaObject != nil)
    {
        for (id key in self.hourCoordinateMap)
        {  
            NSString *trimmedStringStart = 
                    [agendaObject.presentationStartTime stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if([trimmedStringStart isEqualToString:key]){
                agendaObject.yStartHour=[(NSNumber*) 
                        [self.hourCoordinateMap objectForKey:key] floatValue];
            }
            
            NSString *trimmedStringEnd = 
                 [agendaObject.presentationEndTime stringByTrimmingCharactersInSet:
                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if([trimmedStringEnd isEqualToString:key]){
                agendaObject.yEndHour=[(NSNumber*) 
                       [self.hourCoordinateMap objectForKey:key] floatValue];
             
            }
        }
        return agendaObject;
    }  
    else 
    { 
        return nil;
    }
    
}

-(NSMutableArray*)fillButtonsPositions:(NSMutableArray*) markedPres{
    
    NSMutableArray *buttonsPositions=[[[NSMutableArray alloc]init]autorelease];
    
    for(SessionPaper *presentation in markedPres)
    {
        AgendaPresentations *agenda = 
                [self calculateStartEndHours:presentation];
        
        if(agenda != nil)
        {
            [buttonsPositions addObject:agenda];
        }

    }
    return buttonsPositions;
}

-(NSMutableArray*) fillButtonsArray:(NSMutableArray*) buttonsPositions{
    
    NSMutableArray *buttons=[[[NSMutableArray alloc]init]autorelease];
    
    for(AgendaPresentations *agp in buttonsPositions)
    {
        CGRect rect;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
         rect = CGRectMake(RIGTH_OFFSET_IPAD,agp.yStartHour,BUTTON_WIDTH_IPAD,agp.yEndHour-agp.yStartHour);
        }else{
           rect = CGRectMake(RIGTH_OFFSET_IPHONE,agp.yStartHour,BUTTON_WIDTH_IPHONE,agp.yEndHour-agp.yStartHour);
        }
       
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor=[UIColor colorWithRed:100.0/255 green:184.0/255 blue:50.0/255 alpha:1.0];
        button.layer.cornerRadius=BUTTON_CORNER_RADIUS;
        [button setTitle:[agp.presentationName stringByAppendingString:@"..."] forState:UIControlStateNormal];
        button.titleLabel.frame=CGRectMake(0,40, button.frame.size.width, button.frame.size.height/2);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            button.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
        }
        else
        {
            button.titleLabel.font=[UIFont boldSystemFontOfSize:10.0];
        }
        button.titleLabel.textColor=[UIColor whiteColor];
        button.titleLabel.lineBreakMode=UILineBreakModeWordWrap;
        button.titleLabel.numberOfLines=3;
        button.frame=rect;
        //add "arrow" image to the button right corner.
        UIImage *image = [UIImage imageNamed:@"agenda_arrow.png"];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = CGRectMake(button.frame.size.width-15, 5, 10, 10);
        [button addSubview:imageView];
        [imageView release];
        [button addTarget:self action:@selector(buttonClicked:) 
                forControlEvents:UIControlEventTouchUpInside];
        button.property = agp.presentation;
        
        [buttons addObject:button];
    }
    return buttons;
}

- (IBAction)buttonClicked:(id)sender {
    
	UIButton *button = (UIButton *)sender;
    SessionPaper *pres = (SessionPaper*)button.property;
    PresentationViewController *presVc = [[PresentationViewController alloc] initWithPresentation:pres conferenceController:confController];
    [self.navigationController pushViewController:presVc animated:YES];
    [presVc release];
}

- (void) loadTimes
{
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.gridView.subviews)
    {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.gridView.contentSize = contentRect.size;
    NSArray *times = [Utils generateTime];
    NSArray *timesWithoutSuffixes = [Utils generateTimeWithoutSuffixes];
    
    NSMutableDictionary *hMap =[[NSMutableDictionary alloc]init];
    for (int i = 0; i < [times count]; i++)
    {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        lbl.text = [times objectAtIndex:i];
        [lbl sizeToFit];
        CGRect frame = lbl.frame;
        lbl.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
             lbl.font=[UIFont systemFontOfSize:16.0];
        }else{
             lbl.font=[UIFont systemFontOfSize:12.0];
        }

    
        CGFloat y = GRID_TOP_OFFSET - GRID_DIFF_BETWEEN_ROWS / 2.0 + 
        (GRID_ROW_HEIGHT + GRID_DIFF_BETWEEN_ROWS) * i + 
        (GRID_ROW_HEIGHT - frame.size.height) / 2.0;
        
        frame.origin = CGPointMake(GRID_TIME_LEFT_OFFSET, y);
        lbl.frame = frame;
        
        [hMap setValue:[NSNumber numberWithFloat:y] 
                             forKey:[NSString stringWithFormat:@"%@" ,
                                     [timesWithoutSuffixes objectAtIndex:i]]];
        
        
        [self.gridView addSubview:lbl];
        [lbl release];
    }
    self.hourCoordinateMap=hMap;
    [hMap release];
}

- (void) loadGrid:(NSMutableArray*)buttons
{
    if([buttons count] == 1)
    {
        [self.gridView addSubview:[buttons objectAtIndex:0]];
    }
    if([buttons count] != 0)
    {
        [self.gridView addSubview:[buttons objectAtIndex:0]];
        for(UIButton *a in buttons){
            for(UIButton* b in buttons){
                if(![b isEqual:a])
                {
                    if(CGRectIntersectsRect(b.frame, a.frame))
                    {
                        
                        int offset=0;
                        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        {
                            offset=BUTTON_OFFSET_IPAD;
                        }
                        else
                        {
                            offset=BUTTON_OFFSET_IPHONE;    
                        }
                        b.frame = CGRectMake(b.frame.origin.x + offset,
                                             b.frame.origin.y, 
                                             b.frame.size.width,
                                             b.frame.size.height);
                        [self.gridView addSubview:b];
                    }   
                    else{
                        [self.gridView addSubview:a]; 
                    }
                }
            }
        }
    }
}

-(void) viewWillAppear:(BOOL)animated 
{
     [super viewWillAppear:animated];
    //set the background color of a button when view appear.
    for(UIView *view in self.gridView.subviews){
        if([view isKindOfClass:[UIButton class]]){
            view.backgroundColor=[UIColor colorWithRed:100.0/255 green:184.0/255 blue:50.0/255 alpha:1.0];
        }
    }

    UIImage *backgroundImage = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        backgroundImage = 
                [UIImage imageNamed:@"background_navbar_agenda_ipad"];
    }
    else
    {
        backgroundImage = 
                [UIImage imageNamed:@"background_navbar_agenda"];
    }
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675360];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    [[self.navigationController navigationBar] resetBackground:8765360];
}

- (void) viewDidUnload
{
    self.gridView = nil;
    self.btnMark = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
