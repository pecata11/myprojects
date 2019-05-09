/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTileView.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "ManageBirthdayViewController.h"
#import "HolidayAppDelegate.h"

extern const CGSize kTileSize;

@implementation KalTileView

@synthesize date;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    origin = frame.origin;
    [self resetState];
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGFloat fontSize = 15.f;
  UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
  UIColor *shadowColor = nil;
  UIColor *textColor = nil;
  UIImage *markerImage = nil;
  CGContextSelectFont(ctx, [font.fontName cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);
      
  CGContextTranslateCTM(ctx, 0, kTileSize.height);
  CGContextScaleCTM(ctx, 1, -1);
  
  if ([self isToday] && self.selected) 
  {
    // Today with selected date that has birthday
    [[[UIImage imageNamed:@"day_tile_selected"] stretchableImageWithLeftCapWidth:1 topCapHeight:0] drawInRect:CGRectMake(-1, -1, kTileSize.width+1, kTileSize.height+1)];
    textColor = [UIColor colorWithRed:238.0/255 green:152.0/255 blue:7.0/255 alpha:1.0];
    shadowColor = [UIColor blackColor];
    markerImage = [UIImage imageNamed:@"day_marker_selected.png"];
      
  } 
  else if (([self isToday] && !self.selected)) 
  {
    //Today with not selected date
    //[[[UIImage imageNamed:@"day_tile.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0] drawInRect:CGRectMake(0, -1, kTileSize.width+1, kTileSize.height+1)];
      //UIImage *selImage = [[UIImage imageNamed:@"day_tile_high.png"]
      //                     stretchableImageWithLeftCapWidth:1 topCapHeight:0];
      UIImage *selImage = [[UIImage imageNamed:@"day_tile_active.png"]
                           stretchableImageWithLeftCapWidth:1 topCapHeight:0];
      [selImage drawInRect:CGRectMake(-1, -1, kTileSize.width+1, kTileSize.height+1)];
    textColor = [UIColor colorWithRed:238.0/255 green:152.0/255 blue:7.0/255 alpha:1.0];
    shadowColor = [UIColor blackColor];
    markerImage = [UIImage imageNamed:@"day_marker.png"];
    //NSLog(@"%f", [markerImage size].width);
  }
  else if (self.selected) 
  {
    // Day is selected but not is today
    UIImage *selImage = [[UIImage imageNamed:@"day_tile_selected.png"] 
                         stretchableImageWithLeftCapWidth:1 topCapHeight:0]; 
    [selImage drawInRect:CGRectMake(-1, -1, kTileSize.width+1, kTileSize.height+1)];
      
    textColor = [UIColor colorWithRed:253.0/255 green:255.0/255 blue:213.0/255 alpha:1.0];
    shadowColor = [UIColor blackColor];
    markerImage = [UIImage imageNamed:@"day_marker_selected.png"];
  } 
  else if (self.belongsToAdjacentMonth) 
  {
    // Message from previous/next month.
      UIImage *selImage = [[UIImage imageNamed:@"day_tile.png"]
                           stretchableImageWithLeftCapWidth:1 topCapHeight:0];
      [selImage drawInRect:CGRectMake(-1, -1, kTileSize.width+1, kTileSize.height+1)];
    textColor = [UIColor colorWithRed:86.0/255 green:66.0/255 blue:16.0/255 alpha:1.0];
    //shadowColor = nil;
    //markerImage = [UIImage imageNamed:@"Kal.bundle/kal_marker_dim.png"];
  }
  else if(flags.marked)
  {
    // Image from current month that is not selected and has a birthday
    UIImage *flagImage = [[UIImage imageNamed:@"day_tile_active.png"]
                           stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    [flagImage drawInRect:CGRectMake(-1, -1, kTileSize.width+1, kTileSize.height+1)];
//      UIImageView *imView=[[UIImageView alloc]init];
//      imView.image=flagImage;
//      imView.userInteractionEnabled = YES;
//      
//      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
//      [imView addGestureRecognizer:tap];
      
    textColor = [UIColor whiteColor];
    shadowColor = [UIColor blackColor];
    markerImage = [UIImage imageNamed:@"day_marker.png"];
  }
  else 
  {
    // Image from current month that is not selected and doesn't have birthdays
      UIImage *selImage = [[UIImage imageNamed:@"day_tile.png"]
                           stretchableImageWithLeftCapWidth:1 topCapHeight:0];
      [selImage drawInRect:CGRectMake(-1, -1, kTileSize.width+1, kTileSize.height+1)];
    textColor = [UIColor colorWithRed:86.0/255 green:66.0/255 blue:16.0/255 alpha:1.0];
    shadowColor = [UIColor whiteColor];
//    markerImage = [UIImage imageNamed:@"Kal.bundle/kal_marker.png"];
  }
  
  if (flags.marked)
    [markerImage drawInRect:CGRectMake(1.f, 23.f, 20.f, 20.f)];
  
  NSUInteger n = [self.date day];
  NSString *dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
  const char *day = [dayText cStringUsingEncoding:NSUTF8StringEncoding];
  CGSize textSize = [dayText sizeWithFont:font];
  CGFloat textX, textY;
  textX = roundf(0.5f * (kTileSize.width - textSize.width));
  textY = 6.f + roundf(0.5f * (kTileSize.height - textSize.height));
  if (shadowColor) {
   // [shadowColor setFill];
    //CGContextShowTextAtPoint(ctx, textX, textY, day, n >= 10 ? 2 : 1);
    //textY += 1.f;
  }
  [textColor setFill];
  CGContextShowTextAtPoint(ctx, textX, textY-4, day, n >= 10 ? 2 : 1);
  
  if (self.highlighted) {
    [[UIColor colorWithWhite:0.25f alpha:0.3f] setFill];
    CGContextFillRect(ctx, CGRectMake(0.f, 0.f, kTileSize.width, kTileSize.height));
  }
}


- (void)resetState
{
  // realign to the grid
  CGRect frame = self.frame;
  frame.origin = origin;
  frame.size = kTileSize;
  self.frame = frame;
  
  [date release];
  date = nil;
  flags.type = KalTileTypeRegular;
  flags.highlighted = NO;
  flags.selected = NO;
  flags.marked = NO;
}

- (void)setDate:(KalDate *)aDate
{
  if (date == aDate)
    return;

  [date release];
  date = [aDate retain];

  [self setNeedsDisplay];
}

- (BOOL)isSelected { return flags.selected; }

- (void)setSelected:(BOOL)selected
{
  if (flags.selected == selected)
    return;

  // workaround since I cannot draw outside of the frame in drawRect:
  if (![self isToday]) {
    CGRect rect = self.frame;
    if (selected) {
      rect.origin.x--;
      rect.size.width++;
      rect.size.height++;
    } else {
      rect.origin.x++;
      rect.size.width--;
      rect.size.height--;
    }
    self.frame = rect;
  }
  
  flags.selected = selected;
  [self setNeedsDisplay];
}

- (BOOL)isHighlighted { return flags.highlighted; }

- (void)setHighlighted:(BOOL)highlighted
{
  if (flags.highlighted == highlighted)
    return;
  
  flags.highlighted = highlighted;
  [self setNeedsDisplay];
}

- (BOOL)isMarked { return flags.marked; }

- (void)setMarked:(BOOL)marked
{
  if (flags.marked == marked)
    return;
  
  flags.marked = marked;
  [self setNeedsDisplay];
}

- (KalTileType)type { return flags.type; }

- (void)setType:(KalTileType)tileType
{
  if (flags.type == tileType)
    return;
  
  // workaround since I cannot draw outside of the frame in drawRect:
  CGRect rect = self.frame;
  if (tileType == KalTileTypeToday) {
    rect.origin.x--;
    rect.size.width++;
    rect.size.height++;
  } else if (flags.type == KalTileTypeToday) {
    rect.origin.x++;
    rect.size.width--;
    rect.size.height--;
  }
  self.frame = rect;
  
  flags.type = tileType;
  [self setNeedsDisplay];
}

- (BOOL)isToday { return flags.type == KalTileTypeToday; }

- (BOOL)belongsToAdjacentMonth { return flags.type == KalTileTypeAdjacent; }

- (void)dealloc
{
  [date release];
  [super dealloc];
}

@end
