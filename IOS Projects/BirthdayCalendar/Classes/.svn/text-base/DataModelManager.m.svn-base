//
//  DataModelManager.m
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "DataModelManager.h"
#import "UserData.h"
#import "ContactsData.h"

@implementation DataModelManager

@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;

+(NSManagedObjectContext*) getObjectModel
{
    DataModelManager *dbModel= [[[DataModelManager alloc]init]autorelease];
    return dbModel.managedObjectContext;   
}

-(void) saveContactsToModel :(NSNumber*)uID :(NSString*)uName :(NSString*)uPhone :(NSNumber*)checked
{
    ContactsData *user = (ContactsData *)[NSEntityDescription insertNewObjectForEntityForName:@"ContactsData" inManagedObjectContext:self.managedObjectContext];  
    [user setUserID:uID];
    //NSLog(@"the uID is:%d",[checked integerValue]);
    [user setUsername:uName];
    [user setUserphone:uPhone];
    [user setChecked:checked];
    [user setSendRequest:0];
}

-(void)savingContext{
    NSError *error2;  

        if(![self.managedObjectContext save:&error2])
        { 
            NSString *msg = @"Error saving user name.";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" 
                                                            message:msg 
                                                       delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else{
            //NSLog(@"saved context.");
        }
}

-(void) saveUserToModel:(NSString*)uID :(NSString*)uName :(NSString*)uDate :(NSString*)uPhoto :(NSData*) image
{
 
        UserData *user = (UserData *)[NSEntityDescription insertNewObjectForEntityForName:@"UserData" inManagedObjectContext:self.managedObjectContext];  
        [user setUserID:uID];
        [user setName:uName];
        [user setBirthday:uDate];
        if(image != nil)
        {
          [user setValue:image forKey:@"thumbimage"];
        }
        if(uPhoto != nil)
        {
            [user setPhoto:uPhoto];
        }
}

-(BOOL)findCurrentObjectWithName:(NSString*)name
{
    NSEntityDescription *productEntity=[NSEntityDescription entityForName:@"UserData" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:productEntity];
    NSPredicate *p=[NSPredicate predicateWithFormat:@"name == %@", name];
    [fetch setPredicate:p];
    
    NSError *fetchError;
    NSArray *fetchedProducts=[self.managedObjectContext executeFetchRequest:fetch error:&fetchError];
    [fetch release];
    //NSLog(@"The fetched objects number is:%@",[fetchedProducts count]);
    if([fetchedProducts count] != 0)
    {
        return YES;
    }else return NO;
}

-(void)updateCurrentObject :(NSString*)userid :(NSString*)name :(NSString*)date :(NSString*)imageURL :(NSData*)imageData
{
    NSError *error = nil;
    //NSLog(@"userid is:%@",userid);
    //This is your NSManagedObject subclass
    UserData *uData = nil;
    NSEntityDescription *productEntity=[NSEntityDescription entityForName:@"UserData" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:productEntity];

    //Set up to get the thing you want to update
    [request setPredicate:[NSPredicate predicateWithFormat:@"userID=%@",userid]];
    
    //Ask for it
    uData = [[self.managedObjectContext executeFetchRequest:request error:&error] lastObject];
    //NSLog(@"The name is:%@",uData.name);
    [request release];
    
    if (error) {
        //Handle any errors
    }
    
    if (!uData) {
        //Nothing there to update
    }
    //NSLog(@"The name is:%@",name);
    //Update the object
    [uData setUserID:userid];
    [uData setName:name];
    [uData setBirthday:date];
    if(imageData != nil)
    {
         [uData setValue:imageData forKey:@"thumbimage"];
         [uData setPhoto:imageURL];
    }
    else
    {
        [uData setPhoto:imageURL];
    }

    
    //Save it
    //error = nil;
    if (![self.managedObjectContext save:&error]) {
        //Handle any error with the saving of the context
    }
}


-(void)updateCurrentContactObject :(NSNumber*)uID :(NSString*)uName :(NSString*)uPhone :(NSNumber*)checked
{

    NSError *error = nil;
    //NSLog(@"userid is:%d",[uID integerValue]);
    //This is your NSManagedObject subclass
    ContactsData *uData = nil;
    NSEntityDescription *productEntity=[NSEntityDescription entityForName:@"ContactsData" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:productEntity];
    
    //Set up to get the thing you want to update
    [request setPredicate:[NSPredicate predicateWithFormat:@"userID=%d",[uID integerValue]]];
    
    //Ask for it
    uData = [[self.managedObjectContext executeFetchRequest:request error:&error] lastObject];
    //NSLog(@"The name is:%@",uData.name);
    [request release];
    
    if (error) {
        //Handle any errors
    }
    
    if (!uData) {
        //Nothing there to update
    }
    //NSLog(@"The name is:%@",uName);
    //Update the object
    [uData setUsername:uName];
    [uData setUserphone:uPhone];
    [uData setChecked:checked];  //false
    //[uData setSendRequest:1];
    [uData setSendMessage:@"Request sent!"];

    //Save it
    error = nil;
    if (![self.managedObjectContext save:&error]) {
        //Handle any error with the saving of the context
    }
    
}

-(void)deleteCurrentObjectWithName:(NSString*)name
{    
    NSEntityDescription *productEntity=[NSEntityDescription entityForName:@"UserData" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:productEntity];
    NSPredicate *p=[NSPredicate predicateWithFormat:@"name == %@", name];
    [fetch setPredicate:p];
    
    NSError *fetchError;
    NSArray *fetchedProducts=[self.managedObjectContext executeFetchRequest:fetch error:&fetchError];
    for (NSManagedObject *file in fetchedProducts) {
        [self.managedObjectContext deleteObject:file];
    }
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Handle the error
    }
    [fetch release];
}

-(void)deleteCurrentObjectWithNameAndID :(NSString*)name :(NSString*)userID
{    
    NSEntityDescription *productEntity=[NSEntityDescription entityForName:@"UserData" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:productEntity];
    NSPredicate *p=[NSPredicate predicateWithFormat:@"userID == %@", userID];
    [fetch setPredicate:p];
    
    NSError *fetchError;
    NSArray *fetchedProducts=[self.managedObjectContext executeFetchRequest:fetch error:&fetchError];
    for (NSManagedObject *file in fetchedProducts) {
        [self.managedObjectContext deleteObject:file];
    }
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Handle the error
    }
    [fetch release];
}

- (void) deleteAllObjects: (NSString *) entityDescription  
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    //NSMutableArray *items = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    
   // [self.managedObjectContext setRetainsRegisteredObjects:YES];

    for (NSManagedObject *managedObject in items) {
        if (managedObject != nil) {
            [self.managedObjectContext deleteObject:managedObject];
        }
        //NSLog(@"%@ object deleted",entityDescription);
    }
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}
- (NSMutableArray*)fetchContactsRecords 
{       
    // Define our table/entity to use.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ContactsData" inManagedObjectContext:self.managedObjectContext];   
    
    // Setup the fetch request  
    NSFetchRequest *request = [[NSFetchRequest alloc] init];  
    [request setEntity:entity];   
    
    // Define how we will sort the records  
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"username" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];  
    [request setSortDescriptors:sortDescriptors];  
    [sortDescriptor release];   
    // Fetch the records and handle an error  
    NSError *error2;  
    NSMutableArray *mutableFetchResults = [[[self.managedObjectContext executeFetchRequest:request error:&error2] mutableCopy]autorelease]; 
    [request release];
    return mutableFetchResults;
}

- (NSMutableArray*)fetchRecords 
{       
    // Define our table/entity to use.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserData" inManagedObjectContext:self.managedObjectContext];   
    
    // Setup the fetch request  
    NSFetchRequest *request = [[NSFetchRequest alloc] init];  
    [request setEntity:entity];   
    
    // Define how we will sort the records  
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];  
    [request setSortDescriptors:sortDescriptors];  
    [sortDescriptor release];   
    // Fetch the records and handle an error  
    NSError *error2;  
    NSMutableArray *mutableFetchResults = [[[self.managedObjectContext executeFetchRequest:request error:&error2] mutableCopy]autorelease]; 
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
                                               stringByAppendingPathComponent: @"Users.sqlite"]];
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
