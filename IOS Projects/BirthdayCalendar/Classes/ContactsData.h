//
//  ContactsData.h
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ContactsData : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * userphone;
@property (nonatomic, retain) NSNumber * checked;
@property (nonatomic, retain) NSNumber * sendRequest;
@property (nonatomic, retain) NSString * sendMessage;
@property (nonatomic, retain) NSNumber * userID;

@end
