/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalViewController.h"
#import "KalLogic.h"
#import "KalDataSource.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "ManageBirthdayViewController.h"

#import "GAI.h"

#import "config.h"

#ifdef __DISPLAY_BANNER__
#import "GADBannerView.h"
#endif /* __DISPLAY_BANNER__ */

#import "Constants.h"

#define PROFILER 0
#if PROFILER
#include <mach/mach_time.h>
#include <time.h>
#include <math.h>
void mach_absolute_difference(uint64_t end, uint64_t start, struct timespec *tp)
{
    uint64_t difference = end - start;
    static mach_timebase_info_data_t info = {0,0};

    if (info.denom == 0)
        mach_timebase_info(&info);
    
    uint64_t elapsednano = difference * (info.numer / info.denom);
    tp->tv_sec = elapsednano * 1e-9;
    tp->tv_nsec = elapsednano - (tp->tv_sec * 1e9);
}
#endif

NSString *const KalDataSourceChangedNotification = @"KalDataSourceChangedNotification";

@interface KalViewController ()
@property (nonatomic, retain, readwrite) NSDate *initialDate;
@property (nonatomic, retain, readwrite) NSDate *selectedDate;
- (KalView*)calendarView;

@end

@implementation KalViewController

@synthesize dataSource, delegate, initialDate, selectedDate,tableView;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.trackedViewName = @"KalViewController";
    
    //NSLog(@"%f,%f", self.tabBarController.view.frame.origin.y, self.tabBarController.view.frame.size.height);
    //NSLog(@"%f,%f", self.tabBarController.tabBar.frame.origin.y, self.tabBarController.tabBar.frame.size.height);
    //NSLog(@"%f,%f", self.view.frame.origin.y, self.view.frame.size.height);
    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    //bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
#ifdef __DISPLAY_BANNER__
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            self.view.frame.size.height -
                                            GAD_SIZE_320x50.height,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];
#endif /* __DISPLAY_BANNER__ */
}

- (id)initWithSelectedDate:(NSDate *)date
{
  if ((self = [super init])) {
    logic = [[KalLogic alloc] initForDate:date];
    self.initialDate = date;
    self.selectedDate = date;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:KalDataSourceChangedNotification object:nil];
      
      [self.tabBarItem setTitle:@"Calendar"];
      self.tabBarItem.tag=1;
      //[self.tabBarItem setImage:[UIImage imageNamed:@"CalendarD"]];
     
      [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"CalendarD-selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"CalendarD.png"]];
  }
  return self;
}

- (id)init
{
  return [self initWithSelectedDate:[NSDate date]];
}

- (KalView*)calendarView { return (KalView*)self.view; }

- (void)setDataSource:(id<KalDataSource>)aDataSource
{
  if (dataSource != aDataSource) {
    dataSource = aDataSource;
    tableView.dataSource = dataSource;
  }
}

- (void)setDelegate:(id<UITableViewDelegate>)aDelegate
{
  if (delegate != aDelegate) {
    delegate = aDelegate;
    tableView.delegate = delegate;
  }
}

- (void)sendSMS:(NSString*)name
{
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    
    if([MFMessageComposeViewController canSendText])
    {
        NSArray *sepString =[name componentsSeparatedByString:@"?"];
        NSMutableString* ms = [[NSMutableString alloc] init];
        [ms appendString:@"Happy Birthday "];
        [ms appendString:[sepString objectAtIndex:0]];
        [ms appendString:@" !"];
        controller.body = ms;
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
        [ms release];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
    {
        [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"SMS"
                                                         withAction:@"sent"
                                                          withLabel:nil
                                                          withValue:nil];
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message sent successfully." message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else 
        NSLog(@"Message failed");  
}

- (void)clearTable
{
  [dataSource removeAllItems];
  [tableView reloadData];
}

- (void)reloadData
{
  [dataSource presentingDatesFrom:logic.fromDate to:logic.toDate delegate:self];
}

-(void)redrawEntireMonth{
    
    [[self calendarView] redrawEntireMonth];
}

- (void)significantTimeChangeOccurred
{
  [[self calendarView] jumpToSelectedMonth];
  [self reloadData];
}

//----------------------------------
#pragma mark KalViewDelegate protocol

- (void)didSelectDate:(KalDate *)date
{
  self.selectedDate = [date NSDate];
    
    //ManageBirthdayViewController *mBirthdayVC =[[ManageBirthdayViewController alloc]initWithNibName:@"ManageBirthdayViewController" bundle:nil];
    //[self.navigationController pushViewController:mBirthdayVC animated:YES];
    //[mBirthdayVC release];

  NSDate *from = [[date NSDate] cc_dateByMovingToBeginningOfDay];
  NSDate *to = [[date NSDate] cc_dateByMovingToEndOfDay];
  [self clearTable];
  [dataSource loadItemsFromDate:from toDate:to];
  [tableView reloadData];
  [tableView flashScrollIndicators];
}

- (void)showPreviousMonth
{
  [self clearTable];
  [logic retreatToPreviousMonth];
  [[self calendarView] slideDown];
  [self reloadData];
  
    
  KalDate *initialKalDate = [KalDate dateFromNSDate:self.initialDate];
  KalDate *selectedKalDate = [KalDate dateFromNSDate:self.selectedDate];
  KalDate *dateToSet;
  if ((selectedKalDate.month != 2) || (((selectedKalDate.year % 4 == 0) && (selectedKalDate.year % 100 != 0)) || (selectedKalDate.year % 400 == 0))) {
    dateToSet = [KalDate dateForDay:initialKalDate.day month:selectedKalDate.month year:selectedKalDate.year];
  } else {
    dateToSet = [KalDate dateForDay:initialKalDate.day-(initialKalDate.day == 29?1:0) month:selectedKalDate.month year:selectedKalDate.year];
  }
  [[self calendarView] selectDate:dateToSet];
}

- (void)showFollowingMonth
{
  [self clearTable];
  [logic advanceToFollowingMonth];
  [[self calendarView] slideUp];
  [self reloadData];
  
  KalDate *initialKalDate = [KalDate dateFromNSDate:self.initialDate];
  KalDate *selectedKalDate = [KalDate dateFromNSDate:self.selectedDate];
  KalDate *dateToSet;
  if ((selectedKalDate.month != 2) || (((selectedKalDate.year % 4 == 0) && (selectedKalDate.year % 100 != 0)) || (selectedKalDate.year % 400 == 0))) {
    dateToSet = [KalDate dateForDay:initialKalDate.day month:selectedKalDate.month year:selectedKalDate.year];
  } else {
      dateToSet = [KalDate dateForDay:initialKalDate.day-(initialKalDate.day == 29?1:0) month:selectedKalDate.month year:selectedKalDate.year];
  }
  [[self calendarView] selectDate:dateToSet];
}

// -----------------------------------------
#pragma mark KalDataSourceCallbacks protocol

- (void)loadedDataSource:(id<KalDataSource>)theDataSource;
{
  NSArray *markedDates = [theDataSource markedDatesFrom:logic.fromDate to:logic.toDate];
  NSMutableArray *dates = [[markedDates mutableCopy] autorelease];
  for (int i=0; i<[dates count]; i++)
    [dates replaceObjectAtIndex:i withObject:[KalDate dateFromNSDate:[dates objectAtIndex:i]]];
  
  [[self calendarView] markTilesForDates:dates];
  [self didSelectDate:self.calendarView.selectedDate];
}

// ------------------------------------
#pragma mark -

- (void)showAndSelectDate:(NSDate *)date
{
  if ([[self calendarView] isSliding])
    return;
  [logic moveToMonthForDate:date];
  
#if PROFILER
  uint64_t start, end;
  struct timespec tp;
  start = mach_absolute_time();
#endif
  
  [[self calendarView] jumpToSelectedMonth];
  
#if PROFILER
  end = mach_absolute_time();
  mach_absolute_difference(end, start, &tp);
  printf("[[self calendarView] jumpToSelectedMonth]: %.1f ms\n", tp.tv_nsec / 1e6);
#endif
  
  [[self calendarView] selectDate:[KalDate dateFromNSDate:date]];
  [self reloadData];
}

- (NSDate *)selectedDate
{
  return [self.calendarView.selectedDate NSDate];
}


// -----------------------------------------------------------------------------------
#pragma mark UIViewController

- (void)didReceiveMemoryWarning
{
  self.initialDate = self.selectedDate; // must be done before calling super
  [super didReceiveMemoryWarning];
}

- (void)loadView
{
  //if (!self.title)
    //self.title = @"Calendar";
    
    KalView *kalView = [[[KalView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] delegate:self logic:logic:self.navigationController] autorelease];
    
  self.view = kalView;
    //kalView.backgroundColor=[UIColor colorWithRed:236.0/255 green:235.0/255 blue:231.0/255 alpha:1.0];
    kalView.backgroundColor=[[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]] autorelease];
    
  tableView = kalView.tableView;
  tableView.dataSource = dataSource;
  tableView.delegate = delegate;
    
  [tableView retain];
    
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 45)] autorelease];  
    UIColor *color=[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Month.png"]];
    headerView.backgroundColor = color;
    [color release];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(100, 6, headerView.bounds.size.width, 30)] autorelease];
    label.text=@"Birthdays";
    label.textColor=[UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:22];
    [headerView addSubview:label];
    
    [tableView setTableHeaderView:headerView];
    [tableView setRowHeight:72.0];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [kalView selectDate:[KalDate dateFromNSDate:/*self.initialDate]*/[NSDate date]]];
    
    [self reloadData];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  [tableView release];
  tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  //NSDate *start = [NSDate date];
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  [self clearTable];
  [self reloadData];

  KalDate *initialKalDate = [KalDate dateFromNSDate:self.initialDate];
  KalDate *selectedKalDate = [KalDate dateFromNSDate:self.selectedDate];
  KalDate *dateToSet;
  if ((selectedKalDate.month != 2) || (((selectedKalDate.year % 4 == 0) && (selectedKalDate.year % 100 != 0)) || (selectedKalDate.year % 400 == 0))) {
    dateToSet = [KalDate dateForDay:initialKalDate.day month:selectedKalDate.month year:selectedKalDate.year];
  } else {
    dateToSet = [KalDate dateForDay:initialKalDate.day-(initialKalDate.day == 29?1:0) month:selectedKalDate.month year:selectedKalDate.year];
  }
  [[self calendarView] selectDate:dateToSet];
    
  //bannerView_.frame = CGRectOffset(bannerView_.frame, 0, -bannerView_.frame.size.height);

#ifdef __DISPLAY_BANNER__
  bannerView_.frame = CGRectMake(0.0,
                                   self.view.frame.size.height -
                                   GAD_SIZE_320x50.height + 50,
                                   GAD_SIZE_320x50.width,
                                   GAD_SIZE_320x50.height);
#endif /* __DISPLAY_BANNER__ */
    
    //NSLog(@"%f,%f", self.tabBarController.view.frame.origin.y, self.tabBarController.view.frame.size.height);
    //NSLog(@"%f,%f", self.tabBarController.tabBar.frame.origin.y, self.tabBarController.tabBar.frame.size.height);
    //NSLog(@"%f,%f", self.view.frame.origin.y, self.view.frame.size.height);
    
  //NSLog(@"Calendar Load Time: %f", -[start timeIntervalSinceNow]);
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [tableView flashScrollIndicators];
}

#pragma mark -

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:KalDataSourceChangedNotification object:nil];
  [initialDate release];
  [selectedDate release];
  [logic release];
  [tableView release];
  [super dealloc];
}

@end
