//
//  ConferenceController.h
//  ConfComp
//
//  Created by Anto  XX on 10/17/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ServerShortConferenceInfo;

@class Institution;
@class Author;
@class Presentation;

@protocol ConferenceControllerDelegate;
//Main Single conference controler class.
//Manages the information for a single conferention.

@interface ConferenceController : NSObject {
@private
    ServerShortConferenceInfo *confInfo;
    id<ConferenceControllerDelegate> delegate;
    
    NSDictionary *conferenceData;
        
    BOOL dataLoaded;
    BOOL daysLoaded;
    BOOL authorsLoaded;
    BOOL placesLoaded;
    BOOL sessionsLoaded;
    BOOL institutionsLoaded;
    BOOL bindAuthToInstCalled;
    BOOL bindInstToAuthorsCalled;
    //BOOL bindSessionsToPapersCalled;
    BOOL exhibitorsLoaded;
    BOOL topicsLoaded;
    BOOL presentationsLoaded;
    BOOL bindAuthToPresenationCalled;
    BOOL loadExtendedPresentationInfoCalled;
    BOOL bindPresentationsToTopicsCalled;
    BOOL loadExtendedTopicInfoCalled;
    BOOL sponsorsLoaded;
    BOOL sessionPapersLoaded;
    BOOL tracksLoaded;
}

- (id) initWithConference:(ServerShortConferenceInfo *)conference;

@property (nonatomic, assign) id<ConferenceControllerDelegate> delegate;

- (ServerShortConferenceInfo *) conference;

- (void) beginLoadingConferenceData;

- (NSString *) practicalInfoHtml;
- (NSArray *) exhibitors;
- (NSArray *) institutions;
- (NSArray *) authors;
- (NSArray *) presentations;
- (NSArray *) sessions;
- (NSArray *) days;
- (NSArray *) topics;
- (NSArray *) sponsors;

- (NSString *) conferenceLongName;
- (NSString *) conferenceShortName;
- (NSString *) conferenceDates;
- (NSString *) conferencePlace;
- (NSString *) conferenceVersion;
- (NSString *) conferenceTrackName;
- (NSString*) conferenceModeratorName;

- (BOOL) hasSponsors;
- (BOOL) hasAuthors;
- (BOOL) hasInstitutions;
- (BOOL) hasTopics;
- (BOOL) hasExhibitors;

@end

@protocol ConferenceControllerDelegate <NSObject>

@optional
- (void) conferenceControllerDidFinishLoading:(ConferenceController *)conferenceController;
- (void) conferenceControllerDidFailLoading:(ConferenceController *)conferenceController;

@end