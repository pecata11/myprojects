//
//  WebDavWrapper.h
//  SecureSync
//
//  Created by Petko Yanakiev on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirstDetailViewController.h"
@class FMWebDavRequest;

@interface WebDavWrapper : NSObject{

    NSString *baseURL;
    NSString *username;
    NSString *password;    
    NSArray *directoryListing;
    BOOL waitingOnAuthentication;

}
@property(nonatomic,retain)NSString *baseURL;
@property(nonatomic,retain)NSString *username;
@property(nonatomic,retain)NSString *password;
@property(nonatomic) BOOL waitingOnAuthentication;
@property(nonatomic,retain) NSArray *directoryListing;

-(id)initWithBaseUrl:(NSString*)url:(NSString*)user:(NSString*)pass;
-(NSData*) callGetRequest:(NSString*)fileName:(NSString*)sess_id;
-(void) callPutRequest:(NSData*)fileData:(NSString*)fileName:(NSString*)sess_id;
-(NSMutableArray*) listDirectories;
- (void)requestDidFetchDirectoryListing:(FMWebDavRequest*)req;

@end
