//
//  AllConfsController.m
//  ConfComp
//
//  Created by Anto  XX on 10/17/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "AllConfsController.h"

#import "Reachability.h"
#import "ServerShortConferenceInfo.h"
#import "ExtendedServerShortConferenceInfo.h"
#import "Utils.h"
#import "Constants.h"
#import "ConferenceController.h"
#import "SBJson.h"

@interface DownloadConferenceInfo : NSObject

@property (nonatomic, retain) ExtendedServerShortConferenceInfo *confInfo;
@property (nonatomic, retain) NSMutableArray *operations;
@property (nonatomic, copy) NSString *tempFolderName;
@property (nonatomic, assign) NSInteger numCompletedDownloads;

- (id) initWithConferenceInfo:(ServerShortConferenceInfo *)confInfo;

@end

@implementation DownloadConferenceInfo

@synthesize confInfo = _confInfo;
@synthesize operations = _operations;
@synthesize tempFolderName = _tempFolderName;
@synthesize numCompletedDownloads = _numCompletedDownloads;

- (id) initWithConferenceInfo:(ExtendedServerShortConferenceInfo *)inConfInfo
{
    if ((self = [super init]))
    {
        self.confInfo = [inConfInfo retain];
        NSMutableArray *opers = [[NSMutableArray alloc] initWithCapacity:[self.confInfo.linksToDownload count]];
        self.operations = opers;
        [opers release];
        
        self.numCompletedDownloads = 0;
        
        NSString *unqDirName = [Utils randomIdentifier];
        NSString *docsFolders = [Utils documentsDirectory];
        self.tempFolderName = [docsFolders stringByAppendingPathComponent:unqDirName];
    }
    
    return self;
}

- (void) dealloc
{
    [_confInfo release];
    [_operations release];
    [_tempFolderName release];
    
    [super dealloc];
}

@end

@interface AllConfsController ()

- (void) createQueue;
- (void) loadDownloadedConferences;

- (ExtendedServerShortConferenceInfo *) shortInfoForDownloadedConferenceWithId:(NSString *)conferenceId;

- (void) sortConferences;

- (NSDictionary *) cacheShortInfoForExtendedInfo:(ExtendedServerShortConferenceInfo *)serverInfo;

- (BOOL) isLoadingControllerForConferenceWithId:(NSString *)confId;

- (void) onSuccessfullyLoadedController:(ConferenceController *)controller;
- (void) onFailedLoadingController:(ConferenceController *)controller;

- (void) makeCacheForConference:(ExtendedServerShortConferenceInfo *)confInfo;
- (void) cachingConferenceDataFinished:(ExtendedServerShortConferenceInfo *)confInfo;

@end

@implementation AllConfsController

#define CONFERENCES_FOLDER_NAME @"Conferences"

static AllConfsController *sharedConferencesController = nil;

NSString * const AllConfsControllerDidDownloadConference = @"AllConfsDidDownloadConference";
NSString * const AllConfsControllerDidDownloadConference_ConferenceKey = @"Conf";

NSString * const AllConfsControllerDidFailDownloadingConference = @"AllConfsDidFailDownloadingConference";
NSString * const AllConfsControllerDidFailDownloadingConference_ConferenceKey = @"Conf";

NSString * const AllConfsControllerDidLoadConferenceController = @"AllConfsDidLoadConferenceController";
NSString * const AllConfsControllerDidFailLoadingConferenceController = @"AllConfsDidFailLoadingConferenceController";
NSString * const AllConfsControllerDidLoadConferenceController_ConferenceKey = @"ConfController";

@synthesize confServer;
@synthesize confPort;

- (id) init
{
    if ((self = [super init]))
    {
        NSString *docsFolder = [Utils documentsDirectory];
        
        conferencesFolder = [[docsFolder stringByAppendingPathComponent:CONFERENCES_FOLDER_NAME] retain];
        
        NSFileManager *fileMan = [NSFileManager defaultManager];
        BOOL isDir = NO;
        if (![fileMan fileExistsAtPath:conferencesFolder isDirectory:&isDir] || !isDir)
        {
            NSError *err;
            if (![fileMan createDirectoryAtPath:conferencesFolder withIntermediateDirectories:NO attributes:nil error:&err])
            {
                NSLog(@"error creating conferences folder: %@", [err localizedDescription]);
                return nil;
            } else {
                NSURL *dbURLPath = [NSURL fileURLWithPath:conferencesFolder];
                [Utils addSkipBackupAttributeToItemAtURL:dbURLPath];
            }
        }
        NSLog(@"conferences folder = %@", conferencesFolder); 
        // TODO: this must be removed later
        
        [self loadDownloadedConferences];
        
        confIdToControllerMapping = [[NSMutableDictionary alloc] init];
        confIdToLoadingControllerMapping = [[NSMutableDictionary alloc] init];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *server = [defaults stringForKey:@"confServer"];
        NSString *port=[defaults stringForKey:@"confPort"];
        self.confServer=server;
        self.confPort=[port intValue];
        NSLog(@"The read server value is:%@",self.confServer);
        NSLog(@"The read port value is:%d",self.confPort);
    }
    
    return self;
}

- (NSString *) folderPathForConference:(ServerShortConferenceInfo *)confInfo
{
    return [conferencesFolder stringByAppendingPathComponent:confInfo.confId];
}

- (ConferenceController *) conferenceControllerForConference:(ServerShortConferenceInfo *)confInfo
{
    if (confInfo == nil)
    {
        return nil;
    }
    
    return [confIdToControllerMapping valueForKey:confInfo.confId];
}

- (BOOL) hasConferenceControllerForConference:(ServerShortConferenceInfo *)confInfo
{
    if (confInfo == nil)
    {
        return NO;
    }
    
    return [confIdToControllerMapping valueForKey:confInfo.confId] != nil;
}

- (NSInteger) numberOfCachedConferences
{
    return [downloadedConferences count];
}

- (void) loadDownloadedConferences
{
    if (downloadedConferences != nil)
    {
        [downloadedConferences release];
        downloadedConferences = nil;
    }
    
    downloadedConferences = [[NSMutableArray alloc] init];
    
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSArray *downloadedIds = [fileMan contentsOfDirectoryAtPath:conferencesFolder error:nil];
    for (NSString *currDownloadedId in downloadedIds)
    {
        BOOL isDir = NO;
        if ([fileMan fileExistsAtPath:[conferencesFolder stringByAppendingPathComponent:currDownloadedId] isDirectory:&isDir] && isDir)
        {
            ServerShortConferenceInfo *confInfo = [self shortInfoForDownloadedConferenceWithId:currDownloadedId];
            [downloadedConferences addObject:confInfo];
        }
    }
    
    [self sortConferences];
}

- (void) sortConferences
{
    [downloadedConferences sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ServerShortConferenceInfo *info1 = (ServerShortConferenceInfo *)obj1;
        ServerShortConferenceInfo *info2 = (ServerShortConferenceInfo *)obj2;
        return [info1.name compare:info2.name];
    }];
}

- (BOOL) conferenceDownloaded:(ExtendedServerShortConferenceInfo *)confInfo
{
    if (confInfo == nil)
    {
        return NO;
    }
    
    for (ExtendedServerShortConferenceInfo *currConfInfo in downloadedConferences)
    {
        if ([currConfInfo.confId isEqualToString:confInfo.confId])
        {
            return YES;
        }
    }
    
    return NO;
}

- (void) downloadConference:(ExtendedServerShortConferenceInfo *)confInfo
{
    if (![self conferenceDownloaded:confInfo] && ![downloadingConferences objectForKey:confInfo.confId])
    {
        [self createQueue];
   
    Reachability *reachability = [Reachability reachabilityForInternetConnection: self.confServer:self.confPort];    
        NetworkStatus internetStatus = [reachability currentReachabilityStatus];
        
        if (internetStatus != NotReachable) {
            
            //my web-dependent code
            [downloadingQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
        }
        else  {
            NSString *msg = @"Conferences are not reachable! This requires Internet connectivity.";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Problem" 
                                                            message:msg 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }

        DownloadConferenceInfo *downloadInfo = [[DownloadConferenceInfo alloc] initWithConferenceInfo:confInfo];
        
        NSFileManager *fileMan = [NSFileManager defaultManager];
        [fileMan createDirectoryAtPath:downloadInfo.tempFolderName withIntermediateDirectories:NO attributes:nil error:nil];
        
        NSURL *dbURLPath = [NSURL fileURLWithPath:downloadInfo.tempFolderName];
        [Utils addSkipBackupAttributeToItemAtURL:dbURLPath];
        
        for (NSURL *currDownloadUrl in confInfo.linksToDownload)
        {
            DownloadOperation *oper = [[DownloadOperation alloc] initWithUrl:currDownloadUrl];
            oper.delegate = self;
            oper.tag = confInfo.confId;
            [downloadInfo.operations addObject:oper];
            [oper release];
        }
        [downloadingConferences setObject:downloadInfo forKey:confInfo.confId];
        
        for (DownloadOperation *oper in downloadInfo.operations)
        {
            [downloadingQueue addOperation:oper];
        }
        
        [downloadInfo release];
    }
    else
    {
        NSLog(@"already downloaded or downloading, man");
    }
    // TODO: this must be implemented later
}

- (void) createQueue
{
    if (downloadingQueue == nil)
    {
        downloadingQueue = [[NSOperationQueue alloc] init];
        downloadingConferences = [[NSMutableDictionary alloc] init];
    }
    
    if (cachingQueue == nil)
    {
        cachingQueue = [[NSOperationQueue alloc] init];
    }
}

- (NSArray *) downloadedConferences
{
    return downloadedConferences;
}

- (ExtendedServerShortConferenceInfo *) shortInfoForDownloadedConferenceWithId:(NSString *)conferenceId
{
    NSString *confPath = [conferencesFolder stringByAppendingPathComponent:conferenceId];

    // TODO: this must be removed later
    ExtendedServerShortConferenceInfo *confInfo = [[ExtendedServerShortConferenceInfo alloc] init];
    confInfo.confId = conferenceId;
    
    NSDictionary *cachedInfo = [NSDictionary dictionaryWithContentsOfFile:[confPath stringByAppendingPathComponent:CACHED_SHORT_INFO_FILE_NAME]];
    //NSLog(@"Ther name is%@",[cachedInfo valueForKey:@"name"]);
    confInfo.name = [cachedInfo valueForKey:@"name"];
    confInfo.date = [cachedInfo valueForKey:@"date"];
    confInfo.venue = [cachedInfo valueForKey:@"venue"];
    confInfo.version = [[cachedInfo valueForKey:@"version"] intValue];
    
    NSString *imagePath = [confPath stringByAppendingPathComponent:SMALL_IMAGE_FILE_NAME];
    confInfo.image = [UIImage imageWithContentsOfFile:imagePath];
     
    NSString *bigImagePath = [confPath stringByAppendingPathComponent:LARGE_IMAGE_FILE_NAME];
    confInfo.bigImage = [UIImage imageWithContentsOfFile:bigImagePath];
    
    NSString *mapImagePath = [confPath stringByAppendingPathComponent:MAP_IMAGE_FILE_NAME];
    confInfo.mapImage = [UIImage imageWithContentsOfFile:mapImagePath];
    
    return [confInfo autorelease];
}

- (BOOL) deleteConference:(ServerShortConferenceInfo *)confInfo
{
    NSString *confFolder = [conferencesFolder stringByAppendingPathComponent:confInfo.confId];
    NSError *err;
    BOOL result = [[NSFileManager defaultManager] removeItemAtPath:confFolder error:&err];
    if (result)
    {
        [confIdToControllerMapping removeObjectForKey:confInfo.confId];
        
        [downloadedConferences removeObject:confInfo];
    }
    else
    {
        NSLog(@"error occurred while deleting: %@", [err localizedDescription]);
    }
    
    return result;
}

- (NSDictionary *) cacheShortInfoForExtendedInfo:(ExtendedServerShortConferenceInfo *)serverInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:serverInfo.name forKey:@"name"];
    [dict setValue:serverInfo.date forKey:@"date"];
    [dict setValue:serverInfo.venue forKey:@"venue"];
    [dict setValue:[NSString stringWithFormat:@"%d", serverInfo.version] forKey:@"version"];
    return dict;
}

- (BOOL) isLoadingControllerForConferenceWithId:(NSString *)confId
{
    return [confIdToLoadingControllerMapping valueForKey:confId] != nil;
}

- (void) requestControllerForConference:(ServerShortConferenceInfo *)confInfo
{
    if ([self hasConferenceControllerForConference:confInfo])
    {
        [self onSuccessfullyLoadedController:[self conferenceControllerForConference:confInfo]];
    }
    else if (![self isLoadingControllerForConferenceWithId:confInfo.confId])
    {
        ConferenceController *confController = [[ConferenceController alloc] initWithConference:confInfo];
        confController.delegate = self;
        [confIdToLoadingControllerMapping setValue:confController forKey:confInfo.confId];
        [confController beginLoadingConferenceData];
        [confController release];
    }
}
 
- (void) removeCachedConferenceControllers
{
    [confIdToControllerMapping removeAllObjects];
}

- (void) onSuccessfullyLoadedController:(ConferenceController *)controller
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:controller forKey:AllConfsControllerDidLoadConferenceController_ConferenceKey];
    
    [center postNotificationName:AllConfsControllerDidLoadConferenceController object:self userInfo:userInfo];
}

- (void) onFailedLoadingController:(ConferenceController *)controller
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:controller forKey:AllConfsControllerDidLoadConferenceController_ConferenceKey];
    
    [center postNotificationName:AllConfsControllerDidFailLoadingConferenceController object:self userInfo:userInfo];
}

- (void) makeCacheForConference:(ExtendedServerShortConferenceInfo *)confInfo
{
    NSString *folderName = [self folderPathForConference:confInfo];
    NSString *jsonData = [NSString stringWithContentsOfFile:[folderName stringByAppendingPathComponent:CONF_DATA_FILE_NAME] encoding:NSUTF8StringEncoding error:nil];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    id obj = [parser objectWithString:jsonData error:nil];
 
    [NSKeyedArchiver archiveRootObject:obj toFile:[folderName stringByAppendingPathComponent:SERIALIZED_DATA_FILE_NAME]];
    
    [self performSelectorOnMainThread:@selector(cachingConferenceDataFinished:) withObject:confInfo waitUntilDone:NO];
}

- (void) cachingConferenceDataFinished:(ExtendedServerShortConferenceInfo *)confInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AllConfsControllerDidDownloadConference 
                                                    object:self 
                                                    userInfo:[NSDictionary dictionaryWithObject:confInfo 
                                                            forKey:AllConfsControllerDidDownloadConference_ConferenceKey]
     ];
    
    [downloadingConferences removeObjectForKey:confInfo.confId];
}

#pragma mark -
#pragma mark DownloadOperationDelegate methods

- (void) downloadOperationFailed:(DownloadOperation *)downloadOperation
{
    NSLog(@"download operation failed: %@", downloadOperation); 
    // TODO: this must be changed later
    
    NSString *confId = downloadOperation.tag;
    DownloadConferenceInfo *downloadInfo = [downloadingConferences objectForKey:confId];
    ServerShortConferenceInfo *confInfo = downloadInfo.confInfo;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AllConfsControllerDidFailDownloadingConference 
                                                        object:self 
                                                      userInfo:[NSDictionary dictionaryWithObject:confInfo
                                                    forKey:AllConfsControllerDidFailDownloadingConference_ConferenceKey]
     ];
    
    [downloadingConferences removeObjectForKey:confId];
}

- (void) downloadOperationFinished:(DownloadOperation *)downloadOperation
{
    NSString *confId = downloadOperation.tag;
    NSData *data = downloadOperation.downloadedData;

    DownloadConferenceInfo *downloadInfo = [downloadingConferences objectForKey:confId];
    
    if (downloadInfo == nil) // this means that some of the files for this conference has failed to download
    {
        return;
    }
    
    ExtendedServerShortConferenceInfo *confInfo = downloadInfo.confInfo;
    
    NSInteger operIndex = [downloadInfo.operations indexOfObject:downloadOperation];
    
    NSAssert(operIndex != NSNotFound, @"This is totally impossible, man");
    
    NSString *fileName = [confInfo.fileNames objectAtIndex:operIndex];
    NSString *pathToWrite = [downloadInfo.tempFolderName stringByAppendingPathComponent:fileName]; 
    // TODO: this must be changed later
    BOOL writtenSuccessfully = [data writeToFile:pathToWrite atomically:YES];
    if (!writtenSuccessfully)
    {
        [self downloadOperationFailed:downloadOperation];
        return;
    }
    NSURL *dbURLPath = [NSURL fileURLWithPath:pathToWrite];
    [Utils addSkipBackupAttributeToItemAtURL:dbURLPath];
    
    downloadInfo.numCompletedDownloads++;
  
    if (downloadInfo.numCompletedDownloads == [downloadInfo.confInfo.linksToDownload count])
    {
        NSFileManager *fileMan = [NSFileManager defaultManager];
        NSString *finalFolderName = [conferencesFolder stringByAppendingPathComponent:confInfo.confId];
        BOOL isDir = NO;
        if (![fileMan fileExistsAtPath:finalFolderName isDirectory:&isDir] || !isDir)
        {
            NSError *err = nil;
            if (![fileMan moveItemAtPath:downloadInfo.tempFolderName toPath:finalFolderName error:&err])
            {
                NSLog(@"error moving final dir with error: %@", [err localizedDescription]);
            } else {
                NSURL *dbURLPath = [NSURL fileURLWithPath:finalFolderName];
                [Utils addSkipBackupAttributeToItemAtURL:dbURLPath];
            }
            
            NSLog(@"finished and saved to: %@", finalFolderName); // TODO: this must be removed later
        }
        else
        {
            NSAssert(nil, @"this is somehow already downloaded..."); // TODO: this must be changed later - overwrite or something...
        }

        NSDictionary *cacheInfo = [self cacheShortInfoForExtendedInfo:confInfo];
        BOOL cacheSavedSuccessfully = [cacheInfo writeToFile:[finalFolderName stringByAppendingPathComponent:CACHED_SHORT_INFO_FILE_NAME] atomically:YES];
        if (!cacheSavedSuccessfully)
        {
            NSLog(@"unsuccessful saving of cached data");
        } else {
            NSURL *dbURLPath = [NSURL fileURLWithPath:finalFolderName];
            [Utils addSkipBackupAttributeToItemAtURL:dbURLPath];
        }
        
        ExtendedServerShortConferenceInfo *info = [self shortInfoForDownloadedConferenceWithId:confId];
        
        [downloadedConferences addObject:info];
        [self sortConferences];
        
        NSInvocationOperation *makeCacheOper = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(makeCacheForConference:) object:confInfo];
        makeCacheOper.queuePriority = NSOperationQueuePriorityVeryHigh;
        [cachingQueue addOperation:makeCacheOper];
        [makeCacheOper release];
        
        /* ORIGINAL CODE
        [[NSNotificationCenter defaultCenter] postNotificationName:AllConfsControllerDidDownloadConference 
                                                            object:self 
                                                          userInfo:[NSDictionary dictionaryWithObject:confInfo 
                                            forKey:AllConfsControllerDidDownloadConference_ConferenceKey]
        ];
        
        [downloadingConferences removeObjectForKey:confId];
        */ // END ORIGINAL CODE
    }
}

#pragma mark -
#pragma mark ConferenceControllerDelegate methods

- (void) conferenceControllerDidFinishLoading:(ConferenceController *)conferenceController
{
    [confIdToControllerMapping setObject:conferenceController forKey:conferenceController.conference.confId];
    [confIdToLoadingControllerMapping removeObjectForKey:conferenceController.conference.confId];
 
    [self onSuccessfullyLoadedController:conferenceController];
}

- (void) conferenceControllerDidFailLoading:(ConferenceController *)conferenceController
{
    [confIdToLoadingControllerMapping removeObjectForKey:conferenceController.conference.confId];
    
    [self onFailedLoadingController:conferenceController];
}

#pragma mark -
#pragma mark Singleton Implementation

+ (AllConfsController *) sharedConferencesController
{
	@synchronized (self)
	{
		if (sharedConferencesController == nil)
		{
			sharedConferencesController = [[self alloc] init];
		}
	}
	
	return sharedConferencesController;
}

+ (id) allocWithZone:(NSZone *)zone
{
	@synchronized (self)
	{
		if (sharedConferencesController == nil)
		{
			sharedConferencesController = [super allocWithZone:zone];
			return sharedConferencesController;
		}
	}
	
	return nil;
}

- (id) copyWithZone:(NSZone *)zone
{
	return self;
}

- (id) retain
{
	return self;
}

- (oneway void) release
{
	
}

- (id) autorelease
{
	return self;
}

- (NSUInteger) retainCount
{
	return NSUIntegerMax;
}

- (void) dealloc
{
    [downloadingConferences release];
    [downloadingQueue release];
    [cachingQueue release];
    [conferencesFolder release];
    [downloadedConferences release];
    [confIdToControllerMapping release];
    [confIdToLoadingControllerMapping release];
    
	[super dealloc];
}

@end
