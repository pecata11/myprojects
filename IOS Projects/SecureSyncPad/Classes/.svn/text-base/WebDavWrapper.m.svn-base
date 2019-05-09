//
//  WebDavWrapper.m
//  SecureSync
//
//  Created by Petko Yanakiev on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebDavWrapper.h"
#import "FMWebDavRequest.h"
#import "Constants.h"

@implementation WebDavWrapper

@synthesize baseURL=_baseURL;
@synthesize username=_username;
@synthesize password=_password;
@synthesize waitingOnAuthentication=_waitingOnAuthentication;
@synthesize directoryListing=_directoryListing;


-(id)initWithBaseUrl:(NSString*)url:(NSString*)user:(NSString*)pass{
    if(self = [super init])
    {
    self.baseURL=url;
    self.username=user;
    self.password=pass;
    self.waitingOnAuthentication=NO;
    }
    return self;
}

-(void) dealloc{
    
    [super dealloc];
    [_baseURL release];
    [_username release];
    [_password release];
    [_directoryListing release];
}

-(NSData*) callGetRequest:(NSString*)fileName:(NSString*)sess_id{
    
    FMWebDavRequest *getRequest = [[[FMWebDavRequest requestURL:NSStringToURL(fileName) delegate:self endSelector:nil contextInfo:nil :self.username :self.password] rlsynchronous]  get:sess_id];  
    NSData *fileData = getRequest.responseData;            
    NSInteger getRequestCode=getRequest.responseStatusCode;
    NSLog(@"The getRequestCode is:%d",getRequestCode);
    return fileData; 
}

-(void) callPutRequest:(NSData*)fileData:(NSString*)fileName:(NSString*)sess_id{
    
    FMWebDavRequest *putRequest = [[[FMWebDavRequest requestURL:NSStringToURL(fileName) delegate:self endSelector:nil contextInfo:nil :self.username :self.password] rlsynchronous] putData:fileData:sess_id];  
    NSInteger putRequestCode=putRequest.responseStatusCode;
    NSLog(@"The putRequestCode is:%d",putRequestCode);
}

-(NSArray*) listDirectories{
    self.waitingOnAuthentication=YES;
    
    [[FMWebDavRequest requestURL:NSStringToURL(self.baseURL) 
                        delegate:self 
                        endSelector:@selector(requestDidFetchDirectoryListing:)
                        contextInfo:nil:
                        self.username:
                        self.password] fetchDirectoryListing]; 
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    while (self.waitingOnAuthentication && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    
    return self.directoryListing;
}

- (void)requestDidFetchDirectoryListing:(FMWebDavRequest*)req {
    
    self.directoryListing=[[[NSMutableArray alloc]init]autorelease];
    self.directoryListing = [req directoryListing];
    
       self.waitingOnAuthentication = NO;
}
@end