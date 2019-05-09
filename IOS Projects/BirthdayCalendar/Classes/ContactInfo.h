//
//  ContactInfo.h
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactInfo : NSObject{
    
    NSString *firstName;
    NSString *lastName;
    NSDate   *birthDay;
    NSData   *personPhoto;
    NSString *name;
    NSString *phone;
    BOOL marked;
    BOOL send;
    NSInteger index;
    NSString *nn;
    NSString *message;

}
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSDate   *birthDay;
@property (nonatomic, retain) NSData   *personPhoto;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *nn;
@property (nonatomic, retain) NSString *message;
@property (nonatomic) NSInteger index;
@property (nonatomic, assign, getter = isMarked) BOOL marked;
@property (nonatomic, assign, getter = isSended) BOOL send;
@end
