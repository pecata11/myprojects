//
//  DataModel.m
//  SecureSync
//
//  Created by Petko Yanakiev on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataModelManager.h"
#import "Entity.h" 

@implementation DataModelManager

@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;

+(NSManagedObjectContext*) getObjectModel{
    DataModelManager *dbModel= [[[DataModelManager alloc]init]autorelease];
    return dbModel.managedObjectContext;   
}


-(void) saveFileToModel:(NSString*)fName:(NSString*)fPath
{
    Entity *event = (Entity *)[NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:self.managedObjectContext];  
    [event setFileName:fName];
    [event setFilePath:fPath];
    
    NSError *error2;  
    if(![self.managedObjectContext save:&error2])
    {  
        
        NSString *msg = @"Error saving file name.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" 
                                                        message:msg 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }  
}

-(BOOL)findCurrentObjectWithName:(NSString*)name
{
    NSEntityDescription *productEntity=[NSEntityDescription entityForName:@"Entity" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:productEntity];
    NSPredicate *p=[NSPredicate predicateWithFormat:@"fileName == %@", name];
    [fetch setPredicate:p];
    
    NSError *fetchError;
    NSArray *fetchedProducts=[self.managedObjectContext executeFetchRequest:fetch error:&fetchError];
    [fetch release];
    //NSLog(@"The fetched objects number is:%@",[fetchedProducts count]);
    if([fetchedProducts count] != 0){
        return YES;
    }else return NO;
}

-(void)deleteCurrentObjectWithName:(NSString*)name
{    
    NSEntityDescription *productEntity=[NSEntityDescription entityForName:@"Entity" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:productEntity];
    NSPredicate *p=[NSPredicate predicateWithFormat:@"fileName == %@", name];
    [fetch setPredicate:p];
    
    NSError *fetchError;
    NSArray *fetchedProducts=[self.managedObjectContext executeFetchRequest:fetch error:&fetchError];
    for (NSManagedObject *file in fetchedProducts) {
        [self.managedObjectContext deleteObject:file];
    }
    [fetch release];
}

- (void) deleteAllObjects: (NSString *) entityDescription  
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error=nil;
    NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    
    for (NSManagedObject *managedObject in items) {
        [self.managedObjectContext deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityDescription);
    }
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
}

- (NSMutableArray*)fetchRecords 
{       
    // Define our table/entity to use.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:self.managedObjectContext];   
    
    // Setup the fetch request  
    NSFetchRequest *request = [[NSFetchRequest alloc] init];  
    [request setEntity:entity];   
    
    // Define how we will sort the records  
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fileName" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];  
    [request setSortDescriptors:sortDescriptors];  
    [sortDescriptor release];   
    // Fetch the records and handle an error  
    NSError *error2;  
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error2] mutableCopy]; 
    [request release];
    return mutableFetchResults;
}

#pragma mark -
#pragma mark ManageObjectContext Core Data methods.
- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"SecureSync.sqlite"]];
    NSError *error2 = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:[self managedObjectModel]];
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil URL:storeUrl options:nil error:&error2]) {
        /*Error for store creation should be handled in here*/
    }
    
    return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)dealloc {
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    [super dealloc];
}	
@end
