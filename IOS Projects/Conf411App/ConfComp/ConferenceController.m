//
//  ConferenceController.m
//  ConfComp
//
//  Created by Petko Yanakiev  on 10/17/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "ConferenceController.h"

#import "ServerShortConferenceInfo.h"
#import "SBJson.h"
#import "AllConfsController.h"
#import "Constants.h"
#import "Exhibitor.h"
#import "Place.h"
#import "Institution.h"
#import "Author.h"
#import "Presentation.h"
#import "ConfDay.h"
#import "ConfTimeFrame.h"
#import "ConfSession.h"
#import "Topic.h"
#import "GridElement.h"
#import "Sponsor.h"
#import "SessionPaper.h"
#import "ConfTrack.h"
#include <Foundation/Foundation.h>

@interface ConferenceController ()

- (void) loadPlaces;
- (void) loadDays;
//- (void) loadTimeFrames;
- (void) loadSessions;
- (void) loadAuthors;
- (void) loadInstitutions;
- (void) bindAuthorsToInstitutions;
- (void) loadExhibitors;
- (void) loadTopics;
- (void) loadPresentations;
- (void) bindAuthorsToPresentations;
- (void) loadExtendedPresentationInfo;
- (void) saveExtendedPresentationInfo;
- (void) bindPresentationsToTopics;
- (void) loadExtendedTopicInfo;
- (void) saveExtendedTopicInfo;
- (void) loadSponsors;

- (void) loadSessionPapers;
-(void) loadTracks;

//added by petco at 13.02.2012
- (void)  bindInstitutionsToAuthors;
NSComparisonResult compareObjects(id obj1, id obj2,void *context);

@property (nonatomic, retain) NSDictionary *conferenceData;
@property (nonatomic, retain) NSMutableDictionary *dayIdToDayMapping;
@property (nonatomic, retain) NSMutableDictionary *placeIdToPlaceMapping;
@property (nonatomic, retain) NSMutableDictionary *presentationIdToPresentationMapping;
//@property (nonatomic, retain) NSMutableDictionary *timeFrameIdToTimeFrameMapping;
@property (nonatomic, retain) NSMutableDictionary *sessionIdToSessionMapping;
@property (nonatomic, retain) NSMutableDictionary *authorIdToAuthorMapping;
@property (nonatomic, retain) NSMutableDictionary *institutionIdToInstitutionMapping;
@property (nonatomic, retain) NSMutableDictionary *exhibitorIdToExhibitorMapping;
@property (nonatomic, retain) NSMutableDictionary *sponsorIdToSponsorMapping;
@property (nonatomic, retain) NSMutableDictionary *topicIdToTopicMapping;

@property (nonatomic, retain) NSMutableDictionary *presIdToExtendedInfoMapping; // values are NSMutableDictionary with "score", "comment" values
@property (nonatomic, retain) NSMutableDictionary *topicIdToExtendedInfoMapping; // values are NSMutableDictionary with @"marked", etc values
@property(nonatomic,retain) NSMutableDictionary *sessionToPaperMapping;

@property (nonatomic,retain)NSMutableDictionary *trackIdToTrackMapping;

- (NSDictionary *) tblConference;
- (NSArray *) tblExhibitors;
- (NSArray *) tblPlaces;
- (NSArray *) tblInstitutions;
- (NSArray *) tblPeople;
- (NSArray *) tblPresentations;
- (NSArray *) tblPresentationAuthor;
- (NSArray *) tblSessions;
- (NSArray *) tblDays;
- (NSArray *) tblTopics;
- (NSArray *) tblPresentationTopic;
- (NSArray *) tblSponsors;
//added by petco at 13.02.2012.
- (NSArray*)  tblInstitutionsAuthors;
- (NSArray*)  tblPresentationsSessions;
- (NSArray*)  tblTracks;

+ (NSString *) safeStringValue:(id)jsonStrValue;

- (void) onSuccessfullyLoaded;
- (void) onFailed;

@property (nonatomic, retain) NSOperationQueue *queue;

@end

@implementation ConferenceController

@synthesize conferenceData;
@synthesize placeIdToPlaceMapping = _placeIdToPlaceMapping;
@synthesize presentationIdToPresentationMapping = _presentationIdToPresentationMapping;
@synthesize dayIdToDayMapping = _dayIdToDayMapping;
@synthesize sessionIdToSessionMapping = _sessionIdToSessionMapping;
@synthesize authorIdToAuthorMapping = _authorIdToAuthorMapping;
@synthesize institutionIdToInstitutionMapping = _institutionIdToInstitutionMapping;
@synthesize exhibitorIdToExhibitorMapping = _exhibitorIdToExhibitorMapping;
@synthesize topicIdToTopicMapping = _topicIdToTopicMapping;
@synthesize presIdToExtendedInfoMapping = _presIdToExtendedInfoMapping;
@synthesize topicIdToExtendedInfoMapping = _topicIdToExtendedInfoMapping;
@synthesize sponsorIdToSponsorMapping = _sponsorIdToSponsorMapping;
@synthesize delegate;
@synthesize queue = _queue;
@synthesize sessionToPaperMapping=_sessionToPaperMapping;
@synthesize trackIdToTrackMapping=_trackIdToTrackMapping;

- (id) initWithConference:(ServerShortConferenceInfo *)conference
{
    if ((self = [super init]))
    {
        confInfo = [conference retain];
        dataLoaded = NO;
        daysLoaded = NO;
        authorsLoaded = NO;
        placesLoaded = NO;
        sessionsLoaded = NO;
        institutionsLoaded = NO;
        exhibitorsLoaded = NO;
        topicsLoaded = NO;
        presentationsLoaded = NO;
        bindAuthToPresenationCalled = NO;
        loadExtendedPresentationInfoCalled = NO;
        bindPresentationsToTopicsCalled = NO;
        loadExtendedTopicInfoCalled = NO;
        sponsorsLoaded = NO;
        sessionPapersLoaded=NO;
        tracksLoaded=NO;
    }
    
    return self;
}

- (ServerShortConferenceInfo *) conference
{
    return confInfo;
}

+ (NSString *) safeStringValue:(id)jsonStrValue
{
    if (![jsonStrValue isKindOfClass:[NSString class]]) // json null values are presented as [NSNull null]
    {
        return nil;
    }
    else
    {
        return jsonStrValue;
    }
}

+ (NSString *) safeFloatValue:(id)jsonStrValue
{
    if (![jsonStrValue isKindOfClass:[NSNumber class]]) // json null values are presented as [NSNull null]
    {
        return nil;
    }
    else
    {
        return jsonStrValue;
    }
}


- (void) loadConferenceData
{
    if (dataLoaded)
    {
        return;
    }
    
    AllConfsController *confsController = [AllConfsController sharedConferencesController];
    NSString *folderPath = [confsController folderPathForConference:confInfo];
    NSString *serializedDataPath = [folderPath stringByAppendingPathComponent:SERIALIZED_DATA_FILE_NAME];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:serializedDataPath];
    
    if (!obj)
    {
        NSString *confDataPath = [folderPath stringByAppendingPathComponent:CONF_DATA_FILE_NAME];
        NSError *err = nil;
        NSString *theDataStr = [[[NSString alloc] initWithContentsOfFile:confDataPath encoding:NSUTF8StringEncoding error:&err] autorelease];
        //NSLog(@"The data is %@",theDataStr);
        if (theDataStr == nil)
        {
            
             //added by petko on 14.11,2011.
            NSString *message= @"error loading conference";
            UIAlertView *alert = [[UIAlertView alloc] 
                                        initWithTitle:@"Load error" 
                                        message:message 
                                        delegate:nil 
                                        cancelButtonTitle:@"OK" 
                                        otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            [self onFailed];
            return;
        }
    
        SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
        obj = [parser objectWithString:theDataStr error:&err];
        if (!obj)
        {
            NSLog(@"error parsing conference: %@", [err localizedDescription]);
            [self onFailed];
            return;
        }
        else
        {
            NSLog(@"first saving");
            [NSKeyedArchiver archiveRootObject:obj toFile:serializedDataPath];
        }
    }        
    
    NSAssert1([obj isKindOfClass:[NSDictionary class]], @"conference data is not a NSDictionary, but %@", NSStringFromClass(obj));
    
    self.conferenceData = obj;
    //NSLog(@"The conference data is:%@",self.conferenceData);
    
    //NSString *strPDF=[self loadPDFForGettingStarted];
    //NSLog(@"The read PDF url is:%@",strPDF);
    
    [self loadPlaces];
    
    [self loadDays];
    [self loadTracks];
    [self loadSessions];
    
    [self loadInstitutions];
    [self loadAuthors];
    [self bindInstitutionsToAuthors];    
    [self loadTopics];
    [self loadExtendedPresentationInfo];
    
    [self loadPresentations];
    [self bindAuthorsToPresentations];
    [self bindPresentationsToTopics];
    
    [self loadSessionPapers];    
    [self loadSponsors];
    [self loadExhibitors];
    
    dataLoaded = YES;
    [self onSuccessfullyLoaded];
}

- (void) onSuccessfullyLoaded
{
    if ([delegate respondsToSelector:@selector(conferenceControllerDidFinishLoading:)])
    {
        [(NSObject *)delegate performSelectorOnMainThread:@selector(conferenceControllerDidFinishLoading:) withObject:self waitUntilDone:NO];
    }
}

- (void) onFailed
{
    if ([delegate respondsToSelector:@selector(conferenceControllerDidFailLoading:)])
    {
        [(NSObject *)delegate performSelectorOnMainThread:@selector(conferenceControllerDidFailLoading:) withObject:self waitUntilDone:NO];
    }
}

- (void) beginLoadingConferenceData
{
    if (self.queue == nil)
    {
        NSOperationQueue *q = [[NSOperationQueue alloc] init];
        self.queue = q;
        [q release];
        
        NSInvocationOperation *oper = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadConferenceData) object:nil];
        [oper setQueuePriority:NSOperationQueuePriorityVeryHigh];
        [self.queue addOperation:oper];
        [oper release];
    }
}

- (void) loadPlaces
{
    if (placesLoaded)
    {
        return;
    }
    
    NSArray *places = [self tblPlaces];
    //NSLog(@"The places array is %@",places);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:[places count]];
    self.placeIdToPlaceMapping = dict;
    [dict release];
    
    for (NSDictionary *currRawPlace in places)
    {
        Place *place = [[Place alloc] init];
        place.placeId = [[currRawPlace valueForKey:@"primaryKey"] intValue];
        place.name = [ConferenceController safeStringValue:[currRawPlace valueForKey:@"name"]];
        
        if ([currRawPlace valueForKey:@"positionX"] != [NSNull null]) // json null values are presented as [NSNull null]
        {
           place.xPos = [[currRawPlace valueForKey:@"positionX"] floatValue];
        }
        else place.xPos=0.0;
        
        if ([currRawPlace valueForKey:@"positionY"] != [NSNull null]) // json null values are presented as [NSNull null]
        {
            place.yPos = [[currRawPlace valueForKey:@"positionY"] floatValue];
        }else place.yPos=0.0;
        
        [self.placeIdToPlaceMapping setObject:place forKey:[NSNumber numberWithInt:place.placeId]];
        
        [place release];
    }
    
    placesLoaded = YES;
}

- (void) loadDays
{
    if (daysLoaded)
    {
        return;
    }
    
    NSArray *days = [self tblDays];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:[days count]];
    self.dayIdToDayMapping = dict;
    [dict release];
    
    for (NSDictionary *currRawDay in days)
    {
        ConfDay *day = [[ConfDay alloc] init];
        //NSLog(@"The day is %d",[[currRawDay valueForKey:@"id"] intValue]);
        day.dayId = [[currRawDay valueForKey:@"primaryKey"] intValue];
        day.dateStr = [ConferenceController safeStringValue:[currRawDay valueForKey:@"date"]];
        day.name = [ConferenceController safeStringValue:[currRawDay valueForKey:@"name"]];
        day.descr = [ConferenceController safeStringValue:[currRawDay valueForKey:@"info"]];
        
        [self.dayIdToDayMapping setObject:day forKey:[NSNumber numberWithInt:day.dayId]];
        
        [day release];
    }
    
    daysLoaded = YES;
}

-(void)loadTracks
{
    if (tracksLoaded)
    {
        return;
    }
    
    NSArray *tracks = [self tblTracks];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:[tracks count]];
    self.trackIdToTrackMapping = dict;
    [dict release];
    
    for (NSDictionary *currRawTrack in tracks)
    {
        ConfTrack *track = [[ConfTrack alloc] init];
        track.trackId = [[currRawTrack valueForKey:@"primaryKey"] intValue];
        track.description = [ConferenceController safeStringValue:[currRawTrack valueForKey:@"trackDescription"]];
        [self.trackIdToTrackMapping setObject:track forKey:[NSNumber numberWithInt:track.trackId]];
        
        [track release];
    }
    
    tracksLoaded = YES;
}


- (void) loadSessions
{
    if (sessionsLoaded)
    {
        return;
    }
    
    [self loadDays];
    [self loadTracks];
    [self loadPlaces];
    [self loadAuthors];
    
    NSArray *sessions = [self tblSessions];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:[sessions count]];
    self.sessionIdToSessionMapping = dict;
    [dict release];
    for (NSDictionary *currRawSession in sessions)
    {
        ConfSession *session = [[ConfSession alloc] init];
        session.sessionId = [[currRawSession valueForKey:@"primaryKey"] intValue];
        session.name = [ConferenceController safeStringValue:[currRawSession valueForKey:@"name"]];
        session.placeId = [[currRawSession valueForKey:@"place"] intValue];
        session.sessionType=[ConferenceController safeStringValue:[currRawSession valueForKey:@"sessionType"]];
        
        NSInteger trackId;
        NSString *str=[NSString stringWithFormat:@"%@", [currRawSession valueForKey:@"trackID"]];
        if([str isEqualToString:@"<null>"])
            trackId=0;
        else trackId = [str intValue];
        
        session.trackId = trackId;
        session.timeStr = [ConferenceController safeStringValue:[currRawSession valueForKey:@"time"]];
        session.type=[ConferenceController safeStringValue:[currRawSession valueForKey:@"type"]];
        session.place = [self.placeIdToPlaceMapping objectForKey:[NSNumber numberWithInt:session.placeId]];
        
        NSString *strChair = [NSString stringWithFormat:@"%@", [currRawSession valueForKey:@"chair"]];
        if([strChair isEqualToString:@"<null>"]){
            session.chair=nil;
        }
        else{
            NSInteger strInt=[strChair intValue];
            session.chair = [self.authorIdToAuthorMapping objectForKey:[NSNumber numberWithInt:strInt]];
        }
        NSString *strCoChair = [NSString stringWithFormat:@"%@", [currRawSession valueForKey:@"coChair"]];
        if([strCoChair isEqualToString:@"<null>"]){
            session.coChair=nil;
        }
        else{
             NSInteger strIntCo=[strCoChair intValue];
             session.coChair = [self.authorIdToAuthorMapping objectForKey:[NSNumber numberWithInt:strIntCo]];
        }

        session.description=[ConferenceController safeStringValue:[currRawSession valueForKey:@"sessionDescription"]];
        session.dayId = [[currRawSession valueForKey:@"day"] intValue];
        session.sessionNumber =  [ConferenceController safeStringValue:[currRawSession valueForKey:@"sessionNumber"]];    
        ConfDay *day = [self.dayIdToDayMapping objectForKey:[NSNumber numberWithInt:session.dayId]];
        session.day = day;
        
        if(session.trackId != 0)
        {
         ConfTrack *track=[self.trackIdToTrackMapping objectForKey:[NSNumber numberWithInt:session.trackId]];
         session.track = track;
        }
        if (day.sessions == nil)
        {
            day.sessions = [NSMutableArray array];
        }
        [(NSMutableArray *)day.sessions addObject:session];
        
        [self.sessionIdToSessionMapping setObject:session forKey:[NSNumber numberWithInt:session.sessionId]];
        
        [session release];
    }
    //sort the sssions array for key timeStr.     
    for (ConfDay *currDay in [self.dayIdToDayMapping allValues])
    {
       [(NSMutableArray*)currDay.sessions sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            ConfSession *sess1 = (ConfSession*)obj1;
            ConfSession *sess2 = (ConfSession*)obj2;
            return [sess1.timeStr compare:sess2.timeStr];
        }];
    }


    sessionsLoaded = YES;
}

NSComparisonResult compareObjects(id obj1, id obj2,void *context)
{
    ConfSession *sess1 = (ConfSession*)obj1;
    ConfSession *sess2 = (ConfSession*)obj2;
    return [sess1.timeStr compare:sess2.timeStr];
}

- (void) loadAuthors
{
    if (authorsLoaded)
    {
        return;
    }
    
    [self loadInstitutions];
    
    NSArray *tbl = [self tblPeople];
    //NSLog(@"author table = %@", tbl); 
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:[tbl count]];
    self.authorIdToAuthorMapping = dict;
    [dict release];
    
    for (NSDictionary *currRawAuthor in tbl)
    {
        Author *author = [[Author alloc] init];
        
        NSString *stringWithoutSpaces = [[currRawAuthor valueForKey:@"lastName"] stringByReplacingOccurrencesOfString:@" " withString:@""];
        author.authorId = [[currRawAuthor valueForKey:@"primaryKey"] intValue];
        author.firstName = [ConferenceController safeStringValue:[currRawAuthor valueForKey:@"firstName"]];
        author.lastName =  [ConferenceController safeStringValue:stringWithoutSpaces];
        author.name = [ConferenceController safeStringValue:[currRawAuthor valueForKey:@"name"]];
        author.instituteId = [[currRawAuthor valueForKey:@"institution"] intValue];
        author.institution = [self.institutionIdToInstitutionMapping objectForKey:[NSNumber numberWithInt:author.instituteId]];
        author.title= [ConferenceController safeStringValue:[currRawAuthor valueForKey:@"title"]];
        NSString *smallUrl = [ConferenceController safeStringValue:[currRawAuthor valueForKey:@"photo"]];
        author.image=[NSURL URLWithString:smallUrl];
        
    
        //little fix in case last name is empty, we get the names from name variable.
        if([author.lastName isEqualToString:@""])
        {
            if(![author.name isEqualToString:@""])
            {
                NSArray *authNames = [[currRawAuthor valueForKey:@"name"]  componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                author.firstName = [authNames objectAtIndex:0];
                author.lastName = [authNames objectAtIndex:1];
            }
        }

        [self.authorIdToAuthorMapping setObject:author forKey:[NSNumber numberWithInt:author.authorId]];
        
        [author release];
    }
    
    authorsLoaded = YES;
}

- (void) loadInstitutions
{
    if (institutionsLoaded)
    {
        return;
    }
    
    NSArray *tbl = [self tblInstitutions];
    //NSLog(@"The institutions tabkle is:%@",tbl);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:[tbl count]];
    self.institutionIdToInstitutionMapping = dict;
    [dict release];
    
    for (NSDictionary *currRawInstitution in tbl)
    {
        Institution *inst = [[Institution alloc] init];
        
        inst.instituteId = [[currRawInstitution valueForKey:@"primaryKey"] intValue];
        inst.city = [ConferenceController safeStringValue:[currRawInstitution valueForKey:@"city"]];
        inst.country = [ConferenceController safeStringValue:[currRawInstitution valueForKey:@"country"]];
        inst.descr = [ConferenceController safeStringValue:[currRawInstitution valueForKey:@"description"]];
        inst.name = [ConferenceController safeStringValue:[currRawInstitution valueForKey:@"name"]];
        
        [self.institutionIdToInstitutionMapping setObject:inst forKey:[NSNumber numberWithInt:inst.instituteId]];
        
        [inst release];
    }
    
    institutionsLoaded = YES;
}

- (void) loadExhibitors
{
    if (exhibitorsLoaded)
    {
        return;
    }
    
    NSArray *tbl = [self tblExhibitors];
    //NSLog(@"The exibitors table is :%@",tbl);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:[tbl count]];
    self.exhibitorIdToExhibitorMapping = dict;
    [dict release];
    
    for (NSDictionary *currRawExhibitor in tbl)
    {
        Exhibitor *ex = [[Exhibitor alloc] init];
        
        ex.exhibitorId = [[currRawExhibitor valueForKey:@"primaryKey"] intValue];
        ex.name = [ConferenceController safeStringValue:[currRawExhibitor valueForKey:@"name"]];
        ex.descr = [ConferenceController safeStringValue:[currRawExhibitor valueForKey:@"info"]];
        ex.urlAddress = [ConferenceController safeStringValue:[currRawExhibitor valueForKey:@"webSite"]];
        ex.logoUrlAddress = [ConferenceController safeStringValue:[currRawExhibitor valueForKey:@"logo"]];
        ex.place = [self.placeIdToPlaceMapping objectForKey:[NSNumber numberWithInt:[[currRawExhibitor valueForKey:@"place"] intValue]]];
        
        [self.exhibitorIdToExhibitorMapping setObject:ex forKey:[NSNumber numberWithInt:ex.exhibitorId]];

        [ex release];
    }
    
    exhibitorsLoaded = YES;
}

- (void) loadSponsors
{
    if (sponsorsLoaded)
    {
        return;
    }
    
    NSArray *tbl = [self tblSponsors];
    
    //NSLog(@"sponsors table = %@", tbl);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:[tbl count]];
    self.sponsorIdToSponsorMapping = dict;
    [dict release];
    
    for (NSDictionary *currRawSponsor in tbl)
    {
        Sponsor *sponsor = [[Sponsor alloc] init];
        
        sponsor.sponsorId = [[currRawSponsor valueForKey:@"primaryKey"] intValue];
        sponsor.name = [ConferenceController safeStringValue:[currRawSponsor valueForKey:@"name"]];
        sponsor.descr = [ConferenceController safeStringValue:[currRawSponsor valueForKey:@"info"]];
        sponsor.urlAddress = [ConferenceController safeStringValue:[currRawSponsor valueForKey:@"webSite"]];
        sponsor.logoUrlAddress = [ConferenceController safeStringValue:[currRawSponsor valueForKey:@"logo"]];
        sponsor.ranking = [[currRawSponsor valueForKey:@"ranking"] intValue];
        
        [self.sponsorIdToSponsorMapping setObject:sponsor forKey:[NSNumber numberWithInt:sponsor.sponsorId]];
        
        [sponsor release];
    }
    
    sponsorsLoaded = YES;
}

- (void) loadTopics
{
    if (topicsLoaded)
    {
        return;
    }
    
    [self loadExtendedTopicInfo];
    
    NSArray *tbl = [self tblTopics];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:[tbl count]];
    self.topicIdToTopicMapping = dict;
    [dict release];
    
    for (NSDictionary *currRawTopic in tbl)
    {
        Topic *topic = [[Topic alloc] init];
        
        topic.topicId = [[currRawTopic valueForKey:@"primaryKey"] intValue];
        topic.name = [currRawTopic valueForKey:@"name"];
        
        NSMutableDictionary *extInfo = [self.topicIdToExtendedInfoMapping objectForKey:[NSNumber numberWithInt:topic.topicId]];
        topic.marked = [[extInfo valueForKey:@"marked"] boolValue];
        
        [self.topicIdToTopicMapping setObject:topic forKey:[NSNumber numberWithInt:topic.topicId]];
        
        [topic addObserver:self forKeyPath:@"marked" options:0 context:nil];
        
        [topic release];
    }
    
    topicsLoaded = YES;
}

- (void) bindAuthorsToInstitutions
{
    if (bindAuthToInstCalled)
    {
        return;
    }
    
    [self loadInstitutions];
    [self loadAuthors];
    
    NSArray *allAuths = [self authors];
    for (Author *auth in allAuths)
    {
        Institution *inst = auth.institution;
        //NSLog(@"The author institution form bindAuthorsToInstitutions is :%@",auth.institution);
        if (inst.people == nil)
        {
            inst.people = [NSMutableArray array];
        }
        [(NSMutableArray *)inst.people addObject:auth];
    }
    
    bindAuthToInstCalled = YES;
}

//
//Bind authors to institutions and vice versa to model relation N:N in json 
//
- (void)  bindInstitutionsToAuthors
{
    [self loadAuthors];
    [self loadInstitutions];
    if(bindInstToAuthorsCalled)
    {
        return;
    }
    
    NSArray *tbl = [self tblInstitutionsAuthors];
    for(NSDictionary *currRawInstAuth in tbl)
    {
        
        NSNumber *instId=[currRawInstAuth valueForKey:@"institution"];
        NSNumber *authId=[currRawInstAuth valueForKey:@"people"];
        
        Institution *institution=[self.institutionIdToInstitutionMapping objectForKey:instId];
        Author *author= [self.authorIdToAuthorMapping objectForKey:authId];
        
        if(institution == nil || author == nil)
            continue;
        
        if(institution.people == nil){
            institution.people = [NSMutableArray array];
        }
        [(NSMutableArray *) institution.people addObject:author];
        
        if(author.institutions == nil){
            author.institutions=[NSMutableArray array];
        }
        //NSLog(@"The institution is:%@",institution.name);
        [(NSMutableArray *)author.institutions addObject:institution];
        //Institution *inst=[author.institutions objectAtIndex:0];
        //NSLog(@"The author institution is:%@",inst.name);
    }
    
    bindInstToAuthorsCalled=YES;
}

- (void) bindAuthorsToPresentations
{
    [self loadAuthors];
    [self loadSessionPapers];
    
    if (bindAuthToPresenationCalled)
    {
        return;
    }
    //NSArray* unsortedAuthors;

    NSArray *tbl = [self tblPresentationAuthor];
    for (NSDictionary *currRawPresAuth in tbl)
    {
        NSNumber *presId = [currRawPresAuth valueForKey:@"paper"];
        NSNumber *authId = [currRawPresAuth valueForKey:@"people"];
        NSNumber *order = [currRawPresAuth valueForKey:@"order"];
        //NSLog(@"Order: %@", order);
	    //NSNumber *order = [currRawPresAuth valueForKey:@"order"];

        SessionPaper *pres=[self.sessionToPaperMapping objectForKey:presId];
        //NSLog(@"The presID is:%d",pres.pressId);
        Author *auth = [self.authorIdToAuthorMapping objectForKey:authId];
        //NSLog(@"The author id is :%d",auth.authorId);     
        if (pres == nil || auth == nil)
        {
            continue;
        }
        
        if (pres.authors == nil)
        {
            pres.authors = [NSMutableArray array];
            //NSLog(@"In authors not null");
        }
        
        if (pres.dictOrderAuth == nil)
        {
            pres.dictOrderAuth = [NSMutableDictionary dictionary];
            //NSLog(@"In dictOrderAuth not null");
        }

        [(NSMutableArray *)pres.authors addObject:auth];
        //[(NSMutableDictionary *)pres.dictOrderAuth setObject:order forKey:[NSValue valueWithNonretainedObject:auth]];
        //[(NSMutableDictionary *)pres.dictOrderAuth setObject:auth forKey:order];
	    [(NSMutableDictionary *)pres.dictOrderAuth setObject:auth forKey:order];

        // RESORT pres.authors by order
        //[(NSMutableArray*)pres.authors sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
        //{
        //    NSNumber *order1 = (NSNumber*)[pres.dictOrderAuth objectForKey:obj1];
        //    NSNumber *order2 = (NSNumber*)[pres.dictOrderAuth objectForKey:obj2];
        //    return order1 < order2;

        //    //Author *auth1 = (Author*)obj1;
        //    //Author *auth2 = (Author*)obj2;
        //    //return [auth1.lastName compare:auth2.lastName];
        //}];

        //[unsortedArray sortUsingComparator:^ NSComparisonResult(SearchResultItem *d1, SearchResultItem *d2) {
        //NSInteger doorID1 = d1.doorID;
        //NSInteger doorID2 = d2.doorID;
        //if (doorID1 > doorID2)
        //    return NSOrderedAscending;
        //if (doorID1 < doorID2)
        //    return NSOrderedDescending;
        //return [d1.handel localizedCompare: d2.handel];
        //};

        if (auth.presentations == nil)
        {
            auth.presentations = [NSMutableArray array];
        }
        
        [(NSMutableArray *)auth.presentations addObject:pres];
    }
    
    //for (pres.authors)
    
    bindAuthToPresenationCalled = YES;
}

- (void) bindPresentationsToTopics
{
    if (bindPresentationsToTopicsCalled)
    {
        return;
    }
    
    NSArray *tbl = [self tblPresentationTopic];
    
    for (NSDictionary *currRawPresTopic in tbl)
    {
        NSNumber *presId = [currRawPresTopic valueForKey:@"papers"];
        NSNumber *topicId = [currRawPresTopic valueForKey:@"keywords"];
        
        Presentation *pres = [self.presentationIdToPresentationMapping objectForKey:presId];
        Topic *topic = [self.topicIdToTopicMapping objectForKey:topicId];
        
        if (pres == nil || topic == nil)
        {
            continue;
        }
        
        if (pres.topics == nil)
        {
            pres.topics = [NSMutableArray array];
        }
        [(NSMutableArray *)pres.topics addObject:topic];
        
        if (topic.presentations == nil)
        {
            topic.presentations = [NSMutableArray array];
        }
        [(NSMutableArray *)topic.presentations addObject:pres];
    }
    
    bindPresentationsToTopicsCalled = NO;
}

- (void) loadExtendedPresentationInfo
{
    if (loadExtendedPresentationInfoCalled)
    {
        return;
    }
    
    AllConfsController *confsController = [AllConfsController sharedConferencesController];
    NSString *folderPath = [confsController folderPathForConference:confInfo];
    NSString *confDataPath = [folderPath stringByAppendingPathComponent:PRESENTATION_EXTENDED_INFO_FILE_NAME];
    NSMutableDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:confDataPath];
    if (dict == nil)
    {
        self.presIdToExtendedInfoMapping = [NSMutableDictionary dictionary];
    }
    else
    {
        self.presIdToExtendedInfoMapping = dict;
    }
    
    loadExtendedPresentationInfoCalled = YES;
}

- (void) saveExtendedPresentationInfo
{
    AllConfsController *confsController = [AllConfsController sharedConferencesController];
    NSString *folderPath = [confsController folderPathForConference:confInfo];
    NSString *confDataPath = [folderPath stringByAppendingPathComponent:PRESENTATION_EXTENDED_INFO_FILE_NAME];
    BOOL success = [NSKeyedArchiver archiveRootObject:self.presIdToExtendedInfoMapping toFile:confDataPath];
    if (!success)
    {
        NSLog(@"not saved successfully!!! to: %@", confDataPath);
    }
}

- (void) loadExtendedTopicInfo
{
    if (loadExtendedTopicInfoCalled)
    {
        return;
    }
    
    AllConfsController *confsController = [AllConfsController sharedConferencesController];
    NSString *folderPath = [confsController folderPathForConference:confInfo];
    NSString *confDataPath = [folderPath stringByAppendingPathComponent:TOPIC_EXTENDED_INFO_FILE_NAME];
    NSMutableDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:confDataPath];
    if (dict == nil)
    {
        self.topicIdToExtendedInfoMapping = [NSMutableDictionary dictionary];
    }
    else
    {
        self.topicIdToExtendedInfoMapping = dict;
    }
    
    loadExtendedTopicInfoCalled = YES;
}

- (void) saveExtendedTopicInfo
{
    AllConfsController *confsController = [AllConfsController sharedConferencesController];
    NSString *folderPath = [confsController folderPathForConference:confInfo];
    NSString *confDataPath = [folderPath stringByAppendingPathComponent:TOPIC_EXTENDED_INFO_FILE_NAME];
    BOOL success = [NSKeyedArchiver archiveRootObject:self.topicIdToExtendedInfoMapping toFile:confDataPath];
    if (!success)
    {
        NSLog(@"not saved successfully!!! to: %@", confDataPath);
    }
}
- (NSArray*)  tblPresentationsSessions
{
    return [[conferenceData valueForKey:@"SessionPaper"] objectAtIndex:0];
}

- (NSArray*)  tblInstitutionsAuthors
{    
    return [[conferenceData valueForKey:@"InstitutionPeople"] objectAtIndex:0];
}

- (NSDictionary *) tblConference
{
    return [[[conferenceData valueForKey:@"Conference"] objectAtIndex:0] objectAtIndex:0];
}

- (NSArray *) tblExhibitors
{
    return [[conferenceData valueForKey:@"Exhibitor"] objectAtIndex:0];
}

- (NSArray *) tblPlaces
{
    return [[conferenceData valueForKey:@"Place"] objectAtIndex:0];
}

- (NSArray *) tblInstitutions
{
    return [[conferenceData valueForKey:@"Institution"] objectAtIndex:0];
}

- (NSArray *) tblPeople
{
    return [[conferenceData valueForKey:@"People"] objectAtIndex:0];
}

- (NSArray *) tblPresentations
{
    return [[conferenceData valueForKey:@"Paper"] objectAtIndex:0];
}

- (NSArray *) tblPresentationAuthor
{
    return [[conferenceData valueForKey:@"PaperAuthor"] objectAtIndex:0];
}

- (NSArray *) tblSessions
{
    return [[conferenceData valueForKey:@"Session"] objectAtIndex:0];
}

- (NSArray *) tblDays
{
    return [[conferenceData valueForKey:@"Day"] objectAtIndex:0];
}

- (NSArray *) tblTopics
{
    return [[conferenceData valueForKey:@"Keyword"] objectAtIndex:0];
}

- (NSArray *) tblPresentationTopic
{
    return [[conferenceData valueForKey:@"PapersList"] objectAtIndex:0];
}
- (NSArray *) tblSponsors
{
    return [[conferenceData valueForKey:@"Sponsor"] objectAtIndex:0];
}

-(NSArray*) tblTracks
{
    return [[conferenceData valueForKey:@"Track"] objectAtIndex:0];
}

- (NSString *) conferenceLongName
{
    return [[self tblConference] valueForKey:@"longName"];
}

- (NSString *) conferenceShortName
{
    return [[self tblConference] valueForKey:@"shortName"];
}

- (NSString *) conferenceDates
{
    return [[self tblConference] valueForKey:@"dates"];
}

- (NSString *) conferencePlace
{
    return [[self tblConference] valueForKey:@"place"];
}

- (NSString *) conferenceVersion
{
    return [[self tblConference] valueForKey:@"version"];
}

- (NSString *) conferenceTrackName
{
    //NSLog(@"The track name is:%@",[[self tblConference] valueForKey:@"trackName"]);
   return [ConferenceController safeStringValue:[[self tblConference] valueForKey:@"trackName"]];
}
- (NSString*) conferenceModeratorName
{
     //NSLog(@"The moderator name is:%@",[[self tblConference] valueForKey:@"moderatorName"]);
    return [ConferenceController safeStringValue:[[self tblConference] valueForKey:@"moderatorName"]];
}
- (NSString *) practicalInfoHtml
{
    return [[self tblConference] valueForKey:@"practicalInfo"];
}

- (NSArray *) exhibitors
{
    [self loadExhibitors];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.exhibitorIdToExhibitorMapping allValues]];
    
    [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Exhibitor *ex1 = (Exhibitor *)obj1;
        Exhibitor *ex2 = (Exhibitor *)obj2;
        return [ex1.name compare:ex2.name options:NSCaseInsensitiveSearch];
    }];
    
    return arr;
}

- (NSArray *) institutions
{
    [self loadInstitutions];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.institutionIdToInstitutionMapping allValues]];
    
    [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Institution *inst1 = (Institution *)obj1;
        Institution *inst2 = (Institution *)obj2;
        return [inst1.name compare:inst2.name options:NSCaseInsensitiveSearch];
    }];
    
    return arr;
}

- (NSArray *) authors
{
    [self loadAuthors];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.authorIdToAuthorMapping allValues]];
    
    [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Author *auth1 = (Author *)obj1;
        Author *auth2 = (Author *)obj2;
        return [auth1.lastName compare:auth2.lastName options:NSCaseInsensitiveSearch];
    }];
    
    return arr;
}

- (NSArray *) sessions
{
    [self loadSessions];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.sessionIdToSessionMapping allValues]];
    
    [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ConfSession *sess1 = (ConfSession *)obj1;
        ConfSession *sess2 = (ConfSession *)obj2;
        return [sess1.name compare:sess2.name options:NSCaseInsensitiveSearch];
    }];
    
    return arr;
}

- (NSArray *) days
{
    [self loadDays];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.dayIdToDayMapping allValues]];
    
    [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ConfDay *day1 = (ConfDay *)obj1;
        ConfDay *day2 = (ConfDay *)obj2;
        return [day1.dateStr compare:day2.dateStr];
    }];
    
    return arr;
}

- (NSArray *) topics
{
    [self loadTopics];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.topicIdToTopicMapping allValues]];
    
    [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Topic *t1 = (Topic *)obj1;
        Topic *t2 = (Topic *)obj2;
        return [t1.name compare:t2.name options:NSCaseInsensitiveSearch];
    }];
    
    return arr;
}

- (NSArray *) sponsors
{
    [self loadSponsors];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.sponsorIdToSponsorMapping allValues]];
    
    [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Sponsor *sp1 = (Sponsor *)obj1;
        Sponsor *sp2 = (Sponsor *)obj2;
        return [[NSNumber numberWithInt:sp1.ranking] compare:[NSNumber numberWithInt:sp2.ranking]];
    }];
    
    return arr;
}

- (void) loadPresentations
{
    
    if (presentationsLoaded)
    {
        return;
    }
    
    [self loadAuthors];
    //[self loadSessions];
    [self loadExtendedPresentationInfo];
    
    NSArray *tbl = [self tblPresentations];
    
    //NSLog(@"The presentation table is:%@",tbl);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:[tbl count]];
    self.presentationIdToPresentationMapping = dict;
    [dict release];
    
    for (NSDictionary *currRawPresentation in tbl)
    {
        Presentation *presentation = [[Presentation alloc] init];
        
        presentation.presentationId = [[currRawPresentation valueForKey:@"primaryKey"] intValue];
        //NSLog(@"The id of presentation is %d",presentation.presentationId);
        presentation.title = [ConferenceController safeStringValue:[currRawPresentation valueForKey:@"title"]];
        presentation.descr = [ConferenceController safeStringValue:[currRawPresentation valueForKey:@"abstract"]];
        
        NSMutableDictionary *extInfo = [self.presIdToExtendedInfoMapping objectForKey:[NSNumber numberWithInt:presentation.presentationId]];
        presentation.comment = [extInfo valueForKey:@"comment"];
        [self.presentationIdToPresentationMapping setObject:presentation forKey:[NSNumber numberWithInt:presentation.presentationId]];
        [presentation addObserver:self forKeyPath:@"comment" options:0 context:nil];
        [presentation addObserver:self forKeyPath:@"score" options:0 context:nil];
        [presentation addObserver:self forKeyPath:@"marked" options:0 context:nil];
        
        [presentation release];
    }
    
    presentationsLoaded = YES;
}

-(void) loadSessionPapers{
    
    [self loadSessions];
    [self loadPresentations];
    
    if(sessionPapersLoaded)
    {
        return;
    }
    NSArray *tbl =[self tblPresentationsSessions];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:[tbl count]];
    self.sessionToPaperMapping = dict;
    [dict release];
    for(NSDictionary *rawSessionPaper in tbl)
    {
        SessionPaper *sessPaper=[[SessionPaper alloc]init];
        sessPaper.sessPaperId=[[rawSessionPaper valueForKey:@"primaryKey"] intValue];
        sessPaper.sessId=[[rawSessionPaper valueForKey:@"session"]intValue];
        sessPaper.pressId=[[rawSessionPaper valueForKey:@"paper"] intValue];
        sessPaper.presTime=[ConferenceController safeStringValue:[rawSessionPaper valueForKey:@"presentationTime"]];
        sessPaper.programNumber=[ConferenceController safeStringValue:[rawSessionPaper valueForKey:@"programNumber"]];
        sessPaper.boardNumber=[ConferenceController safeStringValue:[rawSessionPaper valueForKey:@"boardNumber"]];
        //NSLog(@"The programNumber is:%@",sessPaper.boardNumber);
                
        ConfSession *session = [self.sessionIdToSessionMapping objectForKey: [NSNumber numberWithInt:sessPaper.sessId]];
        sessPaper.session = session;

        if (session.presentations == nil)
        {
            session.presentations = [NSMutableArray array];
        }
        [(NSMutableArray *)session.presentations addObject:sessPaper];
        
        Presentation *presentation=[self.presentationIdToPresentationMapping objectForKey:[NSNumber numberWithInt:sessPaper.pressId]];
        sessPaper.presentation=presentation;
        sessPaper.title=presentation.title;
        sessPaper.description=presentation.descr;
        sessPaper.comment=presentation.comment;
        sessPaper.marked = NO;
        if (presentation.sessions == nil)
        {
            presentation.sessions = [NSMutableArray array];
        }
        [(NSMutableArray *)presentation.sessions addObject:presentation];
        [self.sessionToPaperMapping setObject:sessPaper forKey:[NSNumber numberWithInt:sessPaper.pressId]];
        
        [presentation addObserver:self forKeyPath:@"marked" options:NSKeyValueObservingOptionNew context:nil];
        [sessPaper release];
    }
    sessionPapersLoaded=YES;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[SessionPaper class]])
    {
       // NSLog(@"In observer method");
        SessionPaper *pres = (SessionPaper *)object;
        if ([keyPath isEqualToString:@"marked"])
        {
            [pres setValue:[NSNumber numberWithBool:YES] forKey:@"marked"];
        }
    }
}

- (NSArray *) presentations
{
    return [self.sessionToPaperMapping allValues];
}
- (BOOL) hasAuthors
{
    [self loadAuthors];
    
    return [self.authorIdToAuthorMapping count] > 0;
}

- (BOOL) hasExhibitors
{
    [self loadExhibitors];
    
    return [self.exhibitorIdToExhibitorMapping count] > 0;
}

- (BOOL) hasInstitutions
{
    [self loadInstitutions];
    
    return [self.institutionIdToInstitutionMapping count] > 0;
}

- (BOOL) hasSponsors
{
    [self loadSponsors];
    
    return [self.sponsorIdToSponsorMapping count] > 0;
}

- (BOOL) hasTopics
{
    [self loadTopics];
    
    return [self.topicIdToTopicMapping count] > 0;
}

- (void) dealloc
{
    [_queue cancelAllOperations];
    [_queue release];
    
    [confInfo release];
    [_placeIdToPlaceMapping release];
    
    for (Presentation *currPres in [self.presentationIdToPresentationMapping allValues])
    {
        [currPres removeObserver:self forKeyPath:@"comment"];
        [currPres removeObserver:self forKeyPath:@"score"];
        [currPres removeObserver:self forKeyPath:@"marked"];
    }
    
    for (Topic *currTopic in [self.topicIdToTopicMapping allValues])
    {
        [currTopic removeObserver:self forKeyPath:@"marked"];
    }
    
    [_presentationIdToPresentationMapping release];
    [_dayIdToDayMapping release];
    [_sessionIdToSessionMapping release];
    [_authorIdToAuthorMapping release];
    [_institutionIdToInstitutionMapping release];
    [_exhibitorIdToExhibitorMapping release];
    [_topicIdToTopicMapping release];
    [_presIdToExtendedInfoMapping release];
    [_topicIdToExtendedInfoMapping release];
    [_sponsorIdToSponsorMapping release];
    [_sessionToPaperMapping release];
    
    [super dealloc];
}

@end
