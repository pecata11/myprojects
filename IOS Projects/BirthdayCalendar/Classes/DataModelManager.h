//
//  DataModelManager.h
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModelManager : NSObject{
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;
+(NSManagedObjectContext*) getObjectModel;
//for calendar management.
-(void) saveUserToModel :(NSString*)uID :(NSString*)uName :(NSString*)uDate :(NSString*)uPhoto :(NSData*)image;
-(BOOL) findCurrentObjectWithName :(NSString*)name;
-(void) deleteCurrentObjectWithName:(NSString*)name;
-(void) deleteCurrentObjectWithNameAndID :(NSString*)name :(NSString*)userID;
-(void) deleteAllObjects:(NSString *) entityDescription;
-(void) updateCurrentObject: (NSString*)userID :(NSString*)name :(NSString*)date :(NSString*)imageURL :(NSData*)imageData;
- (NSMutableArray*)fetchRecords;

//for contacts management.
- (NSMutableArray*)fetchContactsRecords;
-(void) saveContactsToModel :(NSNumber*)uID :(NSString*)uName :(NSString*)uPhone :(NSNumber*)checked;
-(void)savingContext;
-(void)updateCurrentContactObject :(NSNumber*)uID :(NSString*)uName :
(NSString*)uPhone :(NSNumber*)checked;

@end
