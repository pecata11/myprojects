//
//  DataModel.h
//  SecureSync
//
//  Created by Petko Yanakiev on 5/23/12.
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

-(void) saveFileToModel:(NSString*)fName:(NSString*)fPath;
-(BOOL)findCurrentObjectWithName:(NSString*)name;
-(void)deleteCurrentObjectWithName:(NSString*)name;
-(void) deleteAllObjects: (NSString *) entityDescription;
- (NSMutableArray*)fetchRecords;
@end
