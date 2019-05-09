

//#import "Kal.h"
#import "BirthdayCoreDataSource.h"
#import "Birthday.h"
#import "DataModelManager.h"
#import "UserData.h"
#import "CalendarTableViewCell.h"
#import "Utils.h"
#import "NSDate+Helper.h"

#define  decemberDaysEleven 11
#define  decemberDaysTwelve 12



static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
  return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

@interface BirthdayCoreDataSource ()
- (NSArray *)holidaysFrom:(NSDate *)fromDate to:(NSDate *)toDate;
- (NSString*)extractYearFromDates :(NSString *)dateTextFrom :(NSString *)dateTextTo;

@end

@implementation BirthdayCoreDataSource


+ (BirthdayCoreDataSource *)dataSource
{
  return [[[[self class] alloc] init] autorelease];
}

- (id)init
{
  if ((self = [super init])) 
  {
    items = [[NSMutableArray alloc] init];
    birthdays = [[NSMutableArray alloc] init];
    managedObjectContext=[DataModelManager getObjectModel];
    dataModel = [[DataModelManager alloc]init];
  }
  return self;
}

- (Birthday *)holidayAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"The count of items is:%d",[items count]);
     return [items objectAtIndex:indexPath.row];
}

#pragma mark UITableViewDataSource protocol conformance

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Birthday *birth = [self holidayAtIndexPath:indexPath];
    static NSString *CellIdentifier = @"CalendarTableViewCell";
	
    CalendarTableViewCell *calCell = (CalendarTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (calCell == nil) {
        
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CalendarTableViewCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				calCell =  (CalendarTableViewCell *) currentObject;
				break;
			}
		}
	}
    [calCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    calCell.userNameLabel.textColor=[UIColor colorWithRed:86.0/255 green:66.0/255 blue:16.0/255 alpha:1.0];
    calCell.userBirthdayDateLabel.textColor=[UIColor colorWithRed:86.0/255 green:66.0/255 blue:16.0/255 alpha:1.0];
    NSString* uname=[birth.name stringByReplacingOccurrencesOfString:@"?" withString:@""];
    calCell.userNameLabel.text=uname;
    
    NSString* result = [Utils formatDateForTableCell:birth.date];
    calCell.userBirthdayDateLabel.text=result;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        UIImage *image;
        if(birth.thumbimage != nil)
        {
            image = [[UIImage alloc] initWithData:birth.thumbimage];
            [Utils resizeImage:&image];
            [calCell.imageView stopAnimating];
            calCell.imageView.image = image;
            calCell.imageView.contentMode = UIViewContentModeScaleToFill;
        }
        else
        {
            //calCell.imageView.image = [UIImage imageNamed:@"Spinner.png"];
            calCell.imageView.animationImages = [Utils spinnerImages];
            calCell.imageView.animationDuration = 1.1;
            //calCell.imageView.contentMode = UIViewContentModeCenter;
            [calCell.imageView startAnimating];
            NSURL *imageURL = [NSURL URLWithString:birth.photo];
            NSData* imageD = [NSData dataWithContentsOfURL:imageURL];
            //NSLog(@"The date as string is:%@",birth.dateAsString);
            image = [[UIImage alloc] initWithData:imageD];
            [Utils resizeImage:&image];

        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [calCell.imageView stopAnimating];
            calCell.imageView.image=image;
            if (!birth.thumbimage) {
                NSData *imageData = [[NSData alloc]initWithData:UIImagePNGRepresentation(image)];
                [dataModel updateCurrentObject:birth.userID:birth.name:birth.dateAsString:birth.photo:imageData];
                [imageData release];
            }
            [calCell setNeedsLayout];
            
        });
    });
    
    return calCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [items count];
}


#pragma mark Sqlite access

- (NSString *)databasePath
{
  return [[NSBundle mainBundle] pathForResource:@"holidays" ofType:@"db"];
}


- (NSString*)extractYearFromDates :(NSString *)dateTextFrom :(NSString *)dateTextTo
{
    NSString *yearFinal;
    NSArray* stringComponentsFrom = [dateTextFrom componentsSeparatedByString:@"-"];
    NSArray* stringComponentsTo = [dateTextTo componentsSeparatedByString:@"-"];
    
    NSString *yearFrom=[stringComponentsFrom objectAtIndex:0];
    NSString *yearTo=[stringComponentsTo objectAtIndex:0];
    
    NSString *monthFrom=[stringComponentsFrom objectAtIndex:1];
    NSInteger yearFromInt=[yearFrom intValue];
    NSInteger yearToInt=[yearTo intValue];
    NSInteger monthFromInt=[monthFrom intValue];
    
    
    if(yearToInt > yearFromInt)
    {
        if(monthFromInt == decemberDaysEleven 
           || monthFromInt == decemberDaysTwelve)
        { 
            yearFinal = yearFrom;
        }
        else
        {
            yearFinal = yearTo;
        }
        if(monthFromInt == decemberDaysTwelve) yearFinal = yearTo;
    }
    else{
        yearFinal = yearFrom;
    }
    //NSLog(@"The final year is:%@",yearFinal);
    return yearFinal;
}

- (BOOL)isDate :(NSDate *)date :(NSDate *)firstDate :(NSDate *)lastDate
{
    return [date compare:firstDate] == NSOrderedDescending &&
    [date compare:lastDate]  == NSOrderedAscending;
}

- (void)loadHolidaysFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
    //NSDate *start = [NSDate date];
    
    NSString *dateTextFrom = [NSDate stringFromDate:fromDate withFormat:@"yyyy-MM-dd"];
    NSString *dateTextTo=[NSDate stringFromDate:toDate withFormat:@"yyyy-MM-dd"];

    //NSLog(@"The startDate is:%@",fromDate);
    //NSLog(@"The end date is:%@",toDate);
            
    NSString *yearFinal = [self extractYearFromDates:dateTextFrom:dateTextTo];
    NSMutableArray *resultArray = [dataModel fetchRecords];
    
    NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]] autorelease];
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:locale];
	[inputFormatter setDateFormat:@"yyyy-MM-dd"];
    [inputFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    for(UserData *um in resultArray)
    {
        NSString *newDate=[Utils changeYearToPassed:um.birthday:yearFinal];
        NSDate *birthdayDate = [inputFormatter dateFromString:newDate];
        
        BOOL result = false;
        if(birthdayDate) {
            result = [self isDate:birthdayDate :fromDate :toDate];
        }
        if (result)
        {
            [birthdays addObject:[Birthday birthdayNamed:um.name :birthdayDate:um.birthday:um.photo:um.userID:-1:um.thumbimage]];
        }
    }
    
    [inputFormatter release];
    [delegate loadedDataSource:self];
    
    //NSLog(@"%f20", -[start timeIntervalSinceNow]);
}

#pragma mark KalDataSource protocol conformance

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
    /*
    [birthdays removeAllObjects];
    dispatch_async(dispatch_get_global_queue
                   ( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                       [self loadHolidaysFrom:fromDate to:toDate delegate:delegate];
                       dispatch_sync(dispatch_get_main_queue(), ^{
                           [delegate loadedDataSource:self];
                       });
                   });
     */
    [birthdays removeAllObjects];
    [self loadHolidaysFrom:fromDate to:toDate delegate:delegate];
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
   
  return [[self holidaysFrom:fromDate to:toDate] valueForKeyPath:@"date"];
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    
  [items addObjectsFromArray:[self holidaysFrom:fromDate to:toDate]];
}

- (void)removeAllItems
{
  [items removeAllObjects];
}

#pragma mark -

- (NSArray *)holidaysFrom:(NSDate *)fromDate to:(NSDate *)toDate
{    
  
//  NSMutableArray *matches = [NSMutableArray array];
//    for (Birthday *holiday in birthdays){
//      //NSLog(@"Holiday date is:%@",holiday.date);
//    if (IsDateBetweenInclusive(holiday.date, fromDate, toDate))
//      [matches addObject:holiday];
//    }
  
  return birthdays;
}

- (void)dealloc
{
  [items release];
  [birthdays release];
  [managedObjectContext release];
  [dataModel release];
  [super dealloc];
}

@end
