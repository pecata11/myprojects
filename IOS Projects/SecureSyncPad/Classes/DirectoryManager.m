//
//  DirectoryManager.m
//  SecureSync
//
//  Created by Petko Yanakiev on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DirectoryManager.h"
#import "Reachability.h"
#import "Constants.h"
#import "FMWebDavRequest.h"
#import "UIDevice+UIDevice_IdentifierAddition.h"
#import "NSString+NSString__MD5Addition.h"
#import "FileModel.h"
#import "CryptManager.h"
#include "base64.h"
#include <sys/xattr.h>

@implementation DirectoryManager

@synthesize dirArray=_dirArray;
@synthesize username=_username;
@synthesize password=_password;
@synthesize wdServer=_wdServer;
@synthesize wdPort=_wdPort;



-(void) dealloc{
  
    [_username release];
    [_password release];
    [_wdServer release];
    [davWrapper release];
    [super dealloc];
}

+ (NSString *) documentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (DirectoryManager*)managerWithValues:(NSString *)server:(NSInteger)port {
    
    DirectoryManager *dirManager = [[[DirectoryManager alloc] init] autorelease];
    NSString *mac=[[UIDevice currentDevice] macaddress];
    NSString *udid=[[UIDevice currentDevice] uniqueDeviceIdentifier];
    dirManager.username = udid;
    dirManager.password = mac;
    dirManager.wdServer = server;
    dirManager.wdPort = port;
    dirManager->davWrapper =[[WebDavWrapper alloc] initWithBaseUrl:dirManager.wdServer:dirManager.username:dirManager.password];
    return dirManager;
}

-(id)initialize:(NSString*)server :(NSInteger)port{
        [super init];
        NSString *mac=[[UIDevice currentDevice] macaddress];
        NSString *udid=[[UIDevice currentDevice] uniqueDeviceIdentifier];
        self.username = udid;
        self.password = mac;
        self.wdServer = server;
        self.wdPort = port;
        davWrapper =[[WebDavWrapper alloc] initWithBaseUrl:self.wdServer:self.username:self.password];
    return self;
}

-(NSMutableArray*) downloadWebDavDirectory{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection:self.wdServer:self.wdPort];    
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus != NotReachable) 
    {
        NSLog(@"Is reachable");
        NSMutableArray *dirs= [davWrapper listDirectories];
      return dirs;
    }
    return nil;
}

-(WebDavWrapper*) getDavWrapper{
    return davWrapper;
}

-(NSMutableString*) getEncryptionKeys{
    
    NSMutableString *mutString=[[[NSMutableString alloc]init]autorelease];
    
    NSString *docsFolder = [DirectoryManager documentsDirectory];
    NSString *serializedHeaderPath = [docsFolder stringByAppendingPathComponent:SERIALIZED_HEADERS];
    NSDictionary *headers=[NSKeyedUnarchiver unarchiveObjectWithFile:serializedHeaderPath];
    NSString *sess_id=nil;
    NSString *sess_password=nil;
    NSString *sess_iv=nil;

     sess_id = [headers objectForKey:@"session_id"];
     sess_password = [headers objectForKey:@"session_password"];
     sess_iv = [headers objectForKey:@"session_iv"];
    
    if (sess_id != nil && sess_password != nil && sess_iv != nil) 
    {
        [mutString appendString:sess_id];
        [mutString appendString:@"##"];
        [mutString appendString:sess_password];
        [mutString appendString:@"##"];
        [mutString appendString:sess_iv];
        return mutString;
    }
    else
    {
        return nil;
    }
}

-(void) createRealDirectoryStructure:(NSMutableArray*)serverDirList:(NSString*) sess_id:(NSString*)encPass:(NSString*)encIV
{
    NSData* passDecoded= [base64 decodeBase64FromString:encPass];
    NSData *ivDecoded=[base64 decodeBase64FromString:encIV];

    NSString *documentPath=[DirectoryManager documentsDirectory];
    NSString *mainDirPath=[documentPath stringByAppendingPathComponent:MAIN_DIR];
    
    NSFileManager *localFileManager=[[NSFileManager alloc]init];
    
    NSError *error=nil;
    
        [localFileManager createDirectoryAtPath:mainDirPath 
                    withIntermediateDirectories:YES attributes:nil error:&error];
        NSLog(@"The dir created successfully!");
    
    for(NSString *name in serverDirList)
    {
        NSString *localFilePath = [mainDirPath
                                   stringByAppendingPathComponent:name];
        NSString *fileName = [self.wdServer stringByAppendingPathComponent:name];
        
        //case 1 we have a file.
        if(![name hasSuffix:@"/"])
        {
           
            NSData *fileData = [davWrapper callGetRequest:fileName:sess_id];
            NSData *decryptedData = [CryptManager decryptData:fileData key:passDecoded iv:ivDecoded];
                
            [localFileManager createFileAtPath:localFilePath contents:decryptedData attributes:nil];
            NSLog(@"File created successfully");
        }
        //case 2 we have a directory.
        else if([name hasSuffix:@"/"])
        {
            NSData *fileData = [davWrapper callGetRequest:fileName:sess_id];
            NSLog(@"The file data geted is:%@",fileData);
            [localFileManager createDirectoryAtPath:localFilePath 
                                  withIntermediateDirectories:YES attributes:nil error:&error];
            NSLog(@"Directory created succesfully");
        }
    }//for
    [localFileManager release];
    [self addSkipBackupAttributeToItemAtURL:mainDirPath];
}


- (void)addSkipBackupAttributeToItemAtURL:(NSString *)URL
{
    const char* filePath = [URL  fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    //printf("C String: %s\n",filePath);  
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    NSLog(@"The geted result is:%d",result);
}

-(void) getModifiedFileIfExist:(NSString *)fileName{
    
    NSString *documentPath = [DirectoryManager documentsDirectory];
    NSError *error=nil;
    NSString *webdavPath=[documentPath stringByAppendingPathComponent:MAIN_DIR];
    NSString *filePath=[webdavPath stringByAppendingPathComponent:fileName];
    
    NSString *inboxPath=[documentPath stringByAppendingPathComponent:@"Inbox"];
    NSString *filePathInbox=[inboxPath stringByAppendingPathComponent:fileName];
    
    NSFileManager *localFileManager = [[NSFileManager alloc] init];
    
    if([localFileManager fileExistsAtPath:filePathInbox]){
        
        [localFileManager removeItemAtPath:filePath error:&error];
        [localFileManager copyItemAtPath:filePathInbox toPath:filePath error:NULL];
        [localFileManager removeItemAtPath:filePathInbox error:&error];
        NSLog(@"File copied and removed from inbox folder.");
    }
    [localFileManager release];
}

-(NSMutableArray*)putDirStructureInFileModelForPath:(NSString*)dirPath
{
        NSMutableArray *array=[[NSMutableArray alloc]init];
        NSString *documentPath = [DirectoryManager documentsDirectory];
        NSFileManager *localFileManager=[[NSFileManager alloc] init];
        NSString *path=[documentPath stringByAppendingPathComponent:dirPath];
        
        NSDirectoryEnumerator *dirEnumerator = [localFileManager enumeratorAtPath:path];  
    
    for (NSString *file in dirEnumerator) 
    {
        NSString *filePath=[path stringByAppendingPathComponent:file];
        BOOL isDir=NO;
        if ([localFileManager fileExistsAtPath:filePath isDirectory:&isDir] || isDir)
        {
           FileModel *fileModel=[[FileModel alloc]init];
           if (isDir)
           { 
               [dirEnumerator skipDescendents];
               fileModel.filePath = filePath;
               fileModel.directory = YES;
               fileModel.fileName = file;
               [array addObject:fileModel];
           }
           else if(!isDir)
           {
                if(![file isEqualToString:@".DS_Store"])
                {
                    fileModel.filePath=filePath;
                    fileModel.directory=NO;
                    fileModel.fileName= file;
                    fileModel.encrypted=YES;
                    [array addObject:fileModel];
                }
           }
            [fileModel release];
        }
    }
    [localFileManager release];
    NSMutableArray *cArray = [NSMutableArray array];

    for(FileModel *fm in array){
        if(fm.directory == 1){
            [cArray addObject:fm];
        }
    }
    
    for(FileModel *fm in array){
        if(fm.directory != 1){
            [cArray addObject:fm];
        }
    }
    [array release];
    return cArray;
}
@end