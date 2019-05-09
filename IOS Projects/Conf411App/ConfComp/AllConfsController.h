//
//  AllConfsController.h
//  ConfComp
//
//  Created by Anto  XX on 10/17/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DownloadOperation.h"
#import "ConferenceController.h"

@class ServerShortConferenceInfo;
@class ExtendedServerShortConferenceInfo;
@class ConferenceController;

extern NSString * const AllConfsControllerDidDownloadConference;
extern NSString * const AllConfsControllerDidDownloadConference_ConferenceKey;

extern NSString * const AllConfsControllerDidFailDownloadingConference;
extern NSString * const AllConfsControllerDidFailDownloadingConference_ConferenceKey;

extern NSString * const AllConfsControllerDidLoadConferenceController;
extern NSString * const AllConfsControllerDidFailLoadingConferenceController;
extern NSString * const AllConfsControllerDidLoadConferenceController_ConferenceKey;

//Manages all conferences behaviour.
@interface AllConfsController : NSObject <DownloadOperationDelegate, ConferenceControllerDelegate> {
@private
    NSString *conferencesFolder;
    //the queue for a downloaded conference.
    NSOperationQueue *downloadingQueue;
    NSOperationQueue *cachingQueue;
    NSMutableDictionary *downloadingConferences; // conferenceId is the key
    NSMutableArray *downloadedConferences;
    NSMutableDictionary *confIdToControllerMapping;
    NSMutableDictionary *confIdToLoadingControllerMapping;
    NSString *confServer;
    NSInteger confPort;
}
@property(nonatomic,retain) NSString *confServer;
@property(nonatomic) NSInteger confPort;

//methods declarations.
+ (AllConfsController *) sharedConferencesController;

- (NSInteger) numberOfCachedConferences;

- (NSArray *) downloadedConferences;

- (BOOL) conferenceDownloaded:(ServerShortConferenceInfo *)confInfo;
- (void) downloadConference:(ExtendedServerShortConferenceInfo *)confInfo;

- (BOOL) deleteConference:(ServerShortConferenceInfo *)confInfo;

- (NSString *) folderPathForConference:(ServerShortConferenceInfo *)confInfo;

- (ConferenceController *) conferenceControllerForConference:(ServerShortConferenceInfo *)confInfo;
- (BOOL) hasConferenceControllerForConference:(ServerShortConferenceInfo *)confInfo;
- (void) requestControllerForConference:(ServerShortConferenceInfo *)confInfo;
- (void) removeCachedConferenceControllers;

@end
