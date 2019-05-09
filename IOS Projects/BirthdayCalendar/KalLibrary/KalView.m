/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalView.h"
#import "KalGridView.h"
#import "KalLogic.h"
#import "KalPrivate.h"
#import "Utils.h"

@interface KalView ()
- (void)addSubviewsToHeaderView:(UIView *)headerView;
- (void)addSubviewsToContentView:(UIView *)contentView;
- (void)setHeaderTitleText:(NSString *)text;
@end

static const CGFloat kHeaderHeight = 80.f;
static const CGFloat kMonthLabelHeight = 20.f;

@implementation KalView

@synthesize delegate, tableView,navController;

- (id)initWithFrame :(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic :(UINavigationController*)navigationController
{
  if ((self = [super initWithFrame:frame])) {
    delegate = theDelegate;
      
    logic = [theLogic retain];
      navController=navigationController;
    [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kHeaderHeight)] autorelease];
    headerView.backgroundColor = [UIColor grayColor];
    [self addSubviewsToHeaderView:headerView];
    [self addSubview:headerView];
    
    UIView *contentView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight, frame.size.width, frame.size.height - kHeaderHeight)] autorelease];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubviewsToContentView:contentView];
    [self addSubview:contentView];
  }
  
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  [NSException raise:@"Incomplete initializer" format:@"KalView must be initialized with a delegate and a KalLogic. Use the initWithFrame:delegate:logic: method."];
  return nil;
}

- (void)redrawEntireMonth { [self jumpToSelectedMonth]; }

- (void)slideDown { [gridView slideDown]; }
- (void)slideUp { [gridView slideUp]; }

- (void)showPreviousMonth
{
  if (!gridView.transitioning)
    [delegate showPreviousMonth];
}

- (void)showFollowingMonth
{
  if (!gridView.transitioning)
    [delegate showFollowingMonth];
}

- (void)addSubviewsToHeaderView:(UIView *)headerView
{
  const CGFloat kChangeMonthButtonWidth = 40.0f;
  const CGFloat kChangeMonthButtonHeight = 40.0f;
  const CGFloat kMonthLabelWidth = 200.0f;
  const CGFloat kHeaderVerticalAdjust = -3.f;
  
  // Header background gradient
  UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Month.png"]];
  
    UISwipeGestureRecognizer *swipeGestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showFollowingMonth)];
    [swipeGestureR setDirection: UISwipeGestureRecognizerDirectionRight ];
    [headerView addGestureRecognizer:swipeGestureR];
    
    [swipeGestureR release];
    
    UISwipeGestureRecognizer *swipeGestureL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPreviousMonth)];
    [swipeGestureL setDirection: UISwipeGestureRecognizerDirectionLeft];
    [headerView addGestureRecognizer:swipeGestureL];
    
    [swipeGestureL release];


  CGRect imageFrame = headerView.frame;
  imageFrame.origin = CGPointZero;
  backgroundView.frame = imageFrame;
  [headerView addSubview:backgroundView];
  [backgroundView release];
  
  // Create the previous month button on the left side of the view
   CGRect previousMonthButtonFrame = CGRectMake(self.left,
                                               kHeaderVerticalAdjust+10.f,
                                               kChangeMonthButtonWidth,
                                                kChangeMonthButtonHeight);
  UIButton *previousMonthButton = [[UIButton alloc] initWithFrame:previousMonthButtonFrame];
  [previousMonthButton setImage:[UIImage imageNamed:@"left_arrow.png"] forState:UIControlStateNormal];
  [previousMonthButton setImage:[UIImage imageNamed:@"left_arrow_highlighted.png"] forState:UIControlStateHighlighted];
  previousMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
  previousMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  [previousMonthButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
    
    //[leftButtonView addSubview:previousMonthButton];
    [headerView addSubview:previousMonthButton];
    
  [previousMonthButton release];
  
  // Draw the selected month name centered and at the top of the view
  CGRect monthLabelFrame = CGRectMake((self.width/2.0f) - (kMonthLabelWidth/2.0f),
                                      kHeaderVerticalAdjust+13.f,
                                      kMonthLabelWidth,
                                      kMonthLabelHeight);
  headerTitleLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
  headerTitleLabel.backgroundColor = [UIColor clearColor];
  headerTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.f];
  headerTitleLabel.textAlignment = UITextAlignmentCenter;
      UIColor* color=[UIColor colorWithRed:254.0/255 green:254.0/255 blue:245.0/255 alpha:1.0];
    headerTitleLabel.textColor = color;
    //[UIColor colorWithPatternImage:[UIImage imageNamed:@"Kal.bundle/kal_header_text_fill.png"]];
  headerTitleLabel.shadowColor = [UIColor whiteColor];
  headerTitleLabel.shadowOffset = CGSizeMake(0.f, 1.f);
  [self setHeaderTitleText:[logic selectedMonthNameAndYear]];
  [headerView addSubview:headerTitleLabel];
  
  // Create the next month button on the right side of the view
  CGRect nextMonthButtonFrame = CGRectMake(self.width- kChangeMonthButtonWidth,
                                           kHeaderVerticalAdjust+10.0f,
                                           kChangeMonthButtonWidth,
                                           kChangeMonthButtonHeight);
    
  UIButton *nextMonthButton = [[UIButton alloc] initWithFrame:nextMonthButtonFrame];
  [nextMonthButton setImage:[UIImage imageNamed:@"rigth_arrow.png"] forState:UIControlStateNormal];
    [nextMonthButton setImage:[UIImage imageNamed:@"rigth_arrow_highlighted.png"] forState:UIControlStateHighlighted];
  nextMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
  nextMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  [nextMonthButton addTarget:self action:@selector(showFollowingMonth) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:nextMonthButton];
   [nextMonthButton release];
  
  // Add column labels for each weekday (adjusting based on the current locale's first weekday)
  NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]] autorelease];
  NSDateFormatter *fmt = [[[NSDateFormatter alloc] init] autorelease];
  [fmt setLocale:locale];
  NSArray *weekdayNames = [fmt shortWeekdaySymbols];
  
  //NSArray * weekNames=[NSArray arrayWithObjects:@"Mon",@"Thus",@"Wed",@"Thur",@"Fri",@"Sat",@"Sun", nil];
    
  NSUInteger firstWeekday = [[NSCalendar currentCalendar] firstWeekday];
  NSUInteger i = firstWeekday - 1;
    
  for (CGFloat xOffset = 0.f; xOffset < headerView.width; xOffset += 46.f, i = (i+1)%7) {
    CGRect weekdayFrame = CGRectMake(xOffset, 55.f, 46.f, kHeaderHeight - 55.f);
    UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
    //weekdayLabel.backgroundColor = [UIColor clearColor];
    weekdayLabel.font = [UIFont systemFontOfSize:13.f];
    weekdayLabel.textColor= [UIColor colorWithRed:86.0/255 green:66.0/255 blue:16.0/255 alpha:1.0];
    weekdayLabel.textAlignment = UITextAlignmentCenter;
   // weekdayLabel.textColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.f];
   // weekdayLabel.textColor = [UIColor whiteColor];
    //weekdayLabel.shadowColor = [UIColor whiteColor];
    //weekdayLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    weekdayLabel.text = [weekdayNames objectAtIndex:i];
    [headerView addSubview:weekdayLabel];
    [weekdayLabel release];
  }
}
    
- (void)addSubviewsToContentView:(UIView *)contentView
{
  // Both the tile grid and the list of events will automatically lay themselves
  // out to fit the # of weeks in the currently displayed month.
  // So the only part of the frame that we need to specify is the width.
    //NSLog(@"The width is:%f",self.width);
  CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.width, 0.f);

  // The tile grid (the calendar body)
    gridView = [[KalGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:delegate:navController];
  [gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
  [contentView addSubview:gridView];

  // The list of events for the selected day
  tableView = [[UITableView alloc] initWithFrame:fullWidthAutomaticLayoutFrame style:UITableViewStylePlain];
    //NSLog(@"The width is:%f",tableView.height);
  tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(100,gridView.height,120,44)] autorelease];
    imageView.image = [UIImage imageNamed:@"DaviaLogo.png"];
   [contentView addSubview:imageView];
    //imageView.bottom = contentView.bottom - 10;
    imageView.top = ([Utils resolution] == UIDeviceResolution_iPhoneRetina4)?270:230;
#ifdef DEBUG
    NSLog(@"gridView %@", gridView);
    NSLog(@"headerTitleLabel %@", headerTitleLabel);
    NSLog(@"tableView %@", tableView);
    NSLog(@"shadowView %@", shadowView);
    NSLog(@"contentView %@", contentView);
    NSLog(@"imageView %@", imageView);
#endif
  
  // Drop shadow below tile grid and over the list of events for the selected day
  //shadowView = [[UIImageView alloc] initWithFrame:fullWidthAutomaticLayoutFrame];
  //shadowView.image = [UIImage imageNamed:@"Kal.bundle/kal_grid_shadow.png"];
  //shadowView.height = shadowView.image.size.height;
  //[contentView addSubview:shadowView];
  
  // Trigger the initial KVO update to finish the contentView layout
  [gridView sizeToFit];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (object == gridView && [keyPath isEqualToString:@"frame"]) {
    
    /* Animate tableView filling the remaining space after the
     * gridView expanded or contracted to fit the # of weeks
     * for the month that is being displayed.
     *
     * This observer method will be called when gridView's height
     * changes, which we know to occur inside a Core Animation
     * transaction. Hence, when I set the "frame" property on
     * tableView here, I do not need to wrap it in a
     * [UIView beginAnimations:context:].
     */
    CGFloat gridBottom = gridView.top + gridView.height;
    CGRect frame = tableView.frame;
    frame.origin.y = gridBottom;
    frame.size.height = tableView.superview.height - gridBottom;
    tableView.frame = frame;
    shadowView.top = gridBottom;
    
  } else if ([keyPath isEqualToString:@"selectedMonthNameAndYear"]) {
    [self setHeaderTitleText:[change objectForKey:NSKeyValueChangeNewKey]];
    
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)setHeaderTitleText:(NSString *)text
{
  [headerTitleLabel setText:text];
  [headerTitleLabel sizeToFit];
  headerTitleLabel.left = floorf(self.width/2.f - headerTitleLabel.width/2.f);
}

- (void)jumpToSelectedMonth { [gridView jumpToSelectedMonth]; }

- (void)selectDate:(KalDate *)date {  [gridView selectDate:date]; }

- (BOOL)isSliding { return gridView.transitioning; }

- (void)markTilesForDates:(NSArray *)dates { [gridView markTilesForDates:dates]; }

- (KalDate *)selectedDate { return gridView.selectedDate; }

- (void)dealloc
{
  [logic removeObserver:self forKeyPath:@"selectedMonthNameAndYear"];
  [logic release];
  
  [headerTitleLabel release];
  [gridView removeObserver:self forKeyPath:@"frame"];
  [gridView release];
  [tableView release];
  [shadowView release];
  [navController release];
  [super dealloc];
}

@end
