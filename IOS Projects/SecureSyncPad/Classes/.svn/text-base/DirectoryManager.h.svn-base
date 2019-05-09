//
//  DirectoryManager.h
//  SecureSync
//
//  Created by Petko Yanakiev on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebDavWrapper.h"
@class FMWebDavRequest;

@interface DirectoryManager : NSObject{
    NSMutableArray *dirArray;
    NSString *username;
    NSString *password;
    NSString *wdServer;
    NSInteger wdPort;
    WebDavWrapper *davWrapper;
}

@property(nonatomic,retain) NSMutableArray *dirArray;
@property(nonatomic,retain) NSString *username;
@property(nonatomic,retain) NSString *password;
@property(nonatomic,retain) NSString *wdServer;

@property(nonatomic) NSInteger wdPort;
-(id) initialize:(NSString*)server :(NSInteger)port;
+ (NSString *) documentsDirectory;
- (NSMutableArray*) downloadWebDavDirectory;
-(void) createRealDirectoryStructure:(NSMutableArray*)serverDirList:(NSString*) sess_id:(NSString*)encPass:(NSString*)encIV;

-(NSMutableArray*)putDirStructureInFileModelForPath:(NSString*)path;
-(NSMutableString*)getEncryptionKeys;
-(void) getModifiedFileIfExist:(NSString*)fileName;
-(WebDavWrapper*) getDavWrapper;
- (void)addSkipBackupAttributeToItemAtURL:(NSString *)URL;
+ (DirectoryManager*)managerWithValues:(NSString *)server:(NSInteger)port;
@end
