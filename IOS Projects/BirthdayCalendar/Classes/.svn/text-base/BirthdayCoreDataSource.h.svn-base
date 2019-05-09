#import "KalDataSource.h"

@class Birthday;


/*
 *    HolidaySqliteDataSource
 *    ---------------------
 *
 *  This example data source retrieves world holidays
 *  from an Sqlite database stored locally in the application bundle.
 *  When the presentingDatesFrom:to:delegate message is received,
 *  it queries the database for the specified date range and
 *  instantiates a Holiday object for each row in the result set.
 */

@class DataModelManager;
@class Birthday;
@interface BirthdayCoreDataSource : NSObject <KalDataSource,UITableViewDelegate>
{
    NSMutableArray *items;
    NSMutableArray *birthdays;
    NSManagedObjectContext *managedObjectContext;
    DataModelManager *dataModel;
}

+ (BirthdayCoreDataSource *)dataSource;
- (Birthday *)holidayAtIndexPath:(NSIndexPath *)indexPath;  
// exposed for 
//HolidayAppDelegate so that it can implement the UITableViewDelegate protocol.

@end
