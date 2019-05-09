//
//  MainViewController.m
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "MainViewController.h"
#import "Constants.h"
#import "config.h"
#import "Debug.h"
#import <Facebook.h>
#import "HolidayAppDelegate.h"
#import "DataModelManager.h"
#import "UserData.h"
#import "ManageBirthdayViewController.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "MBProgressHUD.h"
#import "Utils.h"
#import "BirthdayCoreDataSource.h"
#import "KalViewController.h"
#import "EditBirthdayViewController.h"
#import "ContactsViewController.h"
#import <AddressBook/AddressBook.h>
#import "ContactInfo.h"
#import "Reachability.h"
#import "NSDate+Helper.h"

#import "ContactsData.h"
#import <Facebook.h>
#import "FBRequest.h"

#import "FacebookManager.h"

#define SECTION_ADD 0
#define SECTION_MANAGE 1

#define ADD_ROW_FB 0
#define ADD_ROW_CON 1
#define ADD_ROW_NEW 2
#define sendLimit 50
#define SERIAL_PATH @"serial.dat"

#define EMAIL_AT_ONCE   98

@interface MainViewController ()

@property (nonatomic, retain) NSMutableArray *emailMemorize;
@property (nonatomic, assign) NSUInteger fbFriendsCount;

- (void)fromContacts;
- (void)getContacts:(NSMutableArray *)ff;
- (void)sendLogicHelper:(NSMutableArray *)nextUsers;
- (void)sendMessage:(NSMutableArray *)recTen;
- (void)sendLogic;
- (void) readAddressBook;
- (NSString*)getUserPhone:(ABRecordRef)ref;
- (NSString *)getPersonName:(NSString *)lastName firstName:(NSString *)firstName;
- (void)getFacebookPhoto:(id)photoObject :(NSString**)photo;
- (void)findEmptyPhotoUsers;
@end


@implementation MainViewController

@synthesize tableViewMain=_tableViewMain;
@synthesize managedObjectContext;
@synthesize dataModel;
@synthesize markedMemorize;
@synthesize mapOfUsers;
@synthesize activeUser;
@synthesize emailMemorize;
@synthesize fbFriendsCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.tag=3;
        [self.tabBarItem setTitle:@"Add"];
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"AddD-selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"AddD.png"]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserFriends) name:@"FBDidLogin" object:nil];
        emailMemorize=[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.trackedViewName = @"MainViewController";
    //NSLog(@"%f,%f", self.tabBarController.view.frame.origin.y, self.tabBarController.view.frame.size.height);
    //NSLog(@"%f,%f", self.tabBarController.tabBar.frame.origin.y, self.tabBarController.tabBar.frame.size.height);
    //NSLog(@"%f,%f", self.view.frame.origin.y, self.view.frame.size.height);
    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    //bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
#ifdef __DISPLAY_BANNER__
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            self.view.frame.size.height -
                                            GAD_SIZE_320x50.height,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];
#endif /* __DISPLAY_BANNER__ */
    
    self.managedObjectContext=[DataModelManager getObjectModel];
    dataModel = [[DataModelManager alloc]init];
    mapOfUsers=[[NSMutableDictionary alloc]init];
    tableViewMain.backgroundColor = [UIColor clearColor];
    [tableViewMain setBackgroundColor:[UIColor clearColor]];
    [tableViewMain setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    markedMemorize=[[NSMutableArray alloc]init];
    
    NSMutableArray* ar=[dataModel fetchRecords];
    if([ar count] == 0)
    {
        NSString* mes=@"Begin by importing friends whose birthdays you want to remember.";
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Welcome!" message:mes delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Import", nil];
        [alert show];
        alert.tag=2;
        [alert release];
    }
}

/**
 * load User's friends. Session should be active
 */
- (void) loadMe {
    FBRequestConnection *reqCon = [[[FBRequestConnection alloc]init] autorelease];
    
    FBRequestHandler handler = ^(FBRequestConnection *connection, id result, NSError *error)
    {
        // output the results of the request
        //[self requestCompleted:connection result:result error:error];
        if (error) {
            //NSLog(@"Error Code [error code] = %d", [[[error userInfo] objectForKey:@"com.facebook.sdk:ErrorInnerErrorKey"] code]);
            
            int innerError = [[[error userInfo] objectForKey:FBErrorInnerErrorKey] code];
            NSString* loginFailedReason = [[error userInfo] objectForKey:FBErrorLoginFailedReason];
            
            if (innerError == -1009) {
                [Utils messageDisplay:@"Birthday Calendar" :@"Apologies. We're having trouble connecting to Facebook. Please check your internet connection and try again." :1];
            } else {
                if (loginFailedReason && loginFailedReason == FBErrorLoginFailedReason) {
                    [Utils messageDisplay:@"Birthday Calendar" :@"Apologies. Login to Facebook failed. Please make sure you've granted access to Birthdays in Settings->Facebook." :-1];
                } else {
                    [Utils messageDisplay:@"Birthday Calendar" :@"Apologies. We're having trouble connecting to Facebook. Please make sure you've granted Facebook account access to Birthday Calendar." :-1];
                }
            }
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:FB_LOAD_CANCEL object:nil];
            //[Utils messageDisplay:[Utils applicationDisplayName] :[error localizedDescription]];
        } else {
            activeUser = [[NSString alloc] initWithFormat:@"%@", [(NSDictionary*)result objectForKey:@"name"]];
            [self getUserFriends];
            //[self loadFriends];
            //NSDictionary *resultDictionary = (NSDictionary*)result;
            //
            //NSLog(@"%@", resultDictionary);
        }
    };
    FBRequest* request =  [[[FBRequest alloc] initWithSession:FBSession.activeSession
                                                    graphPath:@"me"
                                                   parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"id,name,first_name,last_name,username,birthday,picture,email", @"fields",
                                                               nil]
                                                   HTTPMethod:nil] autorelease];
    
    [reqCon addRequest:request completionHandler:handler];
    [reqCon start];
}

/**
 * load User's friends. Session should be active
 */
- (void) loadFriends {
    FBRequestConnection *reqCon = [[[FBRequestConnection alloc]init] autorelease];
    
    FBRequestHandler handler = ^(FBRequestConnection *connection, id result, NSError *error)
    {
        // output the results of the request
        //[self requestCompleted:connection result:result error:error];
        if (error) {
            //NSLog(@"Error Code [error code] = %d", [[[error userInfo] objectForKey:@"com.facebook.sdk:ErrorInnerErrorKey"] code]);
            
            int innerError = [[[error userInfo] objectForKey:FBErrorInnerErrorKey] code];
            NSString* loginFailedReason = [[error userInfo] objectForKey:FBErrorLoginFailedReason];
            
            if (innerError == -1009) {
                [Utils messageDisplay:@"Birthday Calendar" :@"Apologies. We're having trouble connecting to Facebook. Please check your internet connection and try again." :1];
            }  else {
                if (loginFailedReason && loginFailedReason == FBErrorLoginFailedReason) {
                    [Utils messageDisplay:@"Birthday Calendar" :@"Apologies. Login to Facebook failed. Please make sure you've granted access to Birthdays in Settings->Facebook." :-1];
                } else {
                    [Utils messageDisplay:@"Birthday Calendar" :@"Apologies. We're having trouble connecting to Facebook. Please make sure you've granted Facebook account access to Birthday Calendar." :-1];
                }
            }
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:FB_LOAD_CANCEL object:nil];
            //[Utils messageDisplay:[Utils applicationDisplayName] :[error localizedDescription]];
        } else {
            //NSDictionary *resultDictionary = (NSDictionary*)result;
            
            //MBProgressHUD *hud =
            //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            ////hud.minShowTime = 2;
            //hud.labelText = @"Importing birthdays...";
            [self findEmptyPhotoUsers];
            [self deleteUserIfPresentInModel:result];
            //[dataModel deleteAllObjects:@"ContactsData"];
            
            [emailMemorize removeAllObjects];
            
            HolidayAppDelegate *appDelegate = (HolidayAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            dispatch_async(dispatch_get_global_queue
                           ( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                               
                               [self saveFriendsToDataModel:result];
                               
                               dispatch_sync(dispatch_get_main_queue(), ^{
                                   
#ifdef SEND_APP_REQUESTS
                                   [self sendLogic];
#endif
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                   
                                   // UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Import of Facebook contacts complete." message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                   //                        [alert show];
                                   //                        alert.tag = 1;
                                   //                        [alert release];
                                   //
                                   NSLog(@"EMAIL LOOP - %d Users", emailMemorize.count);
                                   self.fbFriendsCount = emailMemorize.count;
                                   
                                   if (self.fbFriendsCount > 0) {
                                       NSMutableArray *recipientMails = [[[NSMutableArray alloc] init] autorelease];
                                       //NSString* body = [NSString stringWithFormat:@"%@ I made you a card. Hope you like it!\n\nhttps://apps.facebook.com/myholidaycards/?card_id=%@\n\n- %@", @"Hello!", @"TEST", @"sender_first_name"];
                                       NSString* body = [NSString stringWithFormat:@"Hi,\n\nI want to add your birthday to my 2013 calendar on Facebook. Here is a direct link to accept the request: https://apps.facebook.com/davia_calendar/\n\nThanks!\n\n%@", (activeUser && [activeUser rangeOfString:@"(null)"].location == NSNotFound)?activeUser:@""];
                                       int i = 0;
                                       for (NSDictionary *friend in emailMemorize) {
                                           i++;
                                           if (friend) {
                                               //NSLog(@"User: %@", fbUser);
                                               NSLog(@"The username is:%@", [friend objectForKey:@"username"]);
                                               if (friend) {
                                                   [recipientMails addObject:[NSString stringWithFormat:@"%@@facebook.com", [friend objectForKey:@"username"]]];
                                                   //[emailMemorize removeObjectAtIndex:0];
                                                   //[emailMemorize removeObject:friend];
                                               }
                                           }
                                           if (i >= EMAIL_AT_ONCE) {
                                               break;
                                           }
                                       }
                                       
                                       while (i--) {
                                           [emailMemorize removeObjectAtIndex:0];
                                       }
                                       
                                       NSLog(@"EMAIL LOOP - %d Users", emailMemorize.count);
                                       
                                       [self sendEmail:@"Updating my calendar" recipients:[NSArray arrayWithObject:@"Selected Friends <postman@daviacalendar.com>"/*sender_email*/]  bcc:recipientMails body:body image:nil];
                                       //[[self sendEmail]self subject:@"Birthday Calendar" recipients:[NSArray arrayWithObject:@"Selected Recipients <sendmycard@postman@daviacalendar.com>"/*sender_email*/] bcc:recipientMails body:body image:nil];
                                       
                                       //for (NSDictionary<FBGraphUser> *fbUser in [sendCandidates allValues]) {
                                       //    if (fbUser) {
                                       //        //NSLog(@"User: %@", fbUser);
                                       //        if (fbUser.username) {
                                       //            [recipientMails addObject:[NSString stringWithFormat:@"%@@facebook.com", fbUser.username]];
                                       //        }
                                       //    }
                                       //}
                                   }
                                   tapCount = 0;
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"FacebookDownloadComplete" object:@""];
                                   [NSThread sleepForTimeInterval:1.5];
                                   appDelegate.tabBarController.selectedIndex = 1;
                                   [appDelegate startNotifications];
                               });
                           });
            
            //for (NSDictionary<FBGraphUser> *facebookUser in [resultDictionary objectForKey:@"data"]) {
            //    NSLog(@"%@", facebookUser.name);
            //}
            //NSLog(@"FB Users import done.");
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:FB_LOAD_DONE object:[resultDictionary objectForKey:@"data"]];
        }
        //MBProgressHUD *hud = [MBProgressHUD hideHUDAddedTo:self.view animated:YES];
    };
    
    FBRequest* request =  [[[FBRequest alloc] initWithSession:FBSession.activeSession
                                                   graphPath:@"me/friends"
                                                  parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"id,name,first_name,last_name,username,birthday,picture,email", @"fields",
                                                              nil]
                                                  HTTPMethod:nil] autorelease];
    
    [reqCon addRequest:request completionHandler:handler];
    [reqCon start];
    
}

-(void) getUserFriends{
    
    if (FBSession.activeSession.isOpen) {
        [self loadFriends];
    } else {
        [[FacebookManager sharedManager] openSessionWithAllowLoginUI:YES handler:^{
            [self loadFriends];
        }];
    }
}

- (void)getFacebookPhoto :(id)photoObject :(NSString**)photo{
  
    if([photoObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *photoDict = photoObject;
        //NSDictionary* internalDict = [photoDict objectForKey:@"data"];
        //photo = [internalDict objectForKey:@"url"];
        for (id key in photoDict){
            NSDictionary* internalDict = [photoDict objectForKey:key];
            for(id key1 in internalDict){
                if([key1 isEqual:@"url"])
                {
                    (*photo) = [internalDict objectForKey:key1];
                    break;
                }
            }
        }
    }
    else if([photoObject isKindOfClass:[NSString class]])
    {
        (*photo) = photoObject;
    }

}

- (void)saveFriendsToDataModel:(id)result {
    
    NSArray *resultData = [result objectForKey:@"data"];
    
    NSUserDefaults *standardUserDefaults =
                        [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* serializedUsers = [standardUserDefaults objectForKey:@"mapOfUsers"];
    //NSLog(@"Thej serializedUsers are:%@",serializedUsers);
    if ([resultData count] > 0) 
    {
        
        for (NSDictionary *friend in resultData) 
        {
            NSString *uid=[friend objectForKey:@"id"];
            NSString *name = [friend objectForKey:@"name"];
            NSString *birthday = [friend objectForKey:@"birthday"];
            id photoObject=[friend objectForKey:@"picture"];
            NSString *photo;
            [self getFacebookPhoto:photoObject:&photo];
            if ([friend objectForKey:@"username"]) {
                [emailMemorize addObject:friend];
            }
#ifdef DEBUG
            NSLog(@"The id is:%@",uid);
            NSLog(@"The name is:%@",name);
            NSLog(@"The birthday is:%@",birthday);
            NSLog(@"The photo is:%@",photo);
            NSLog(@"The username is:%@", [friend objectForKey:@"username"]);
            NSLog(@"The email is:%@", [friend objectForKey:@"email"]);
#endif
            [markedMemorize addObject:uid];
            
            if(birthday != nil)
            {
                NSString *dateText = [Utils formatFaceBookDateString:birthday];
#ifdef DEBUG
                NSLog(@"The dateText is:%@",dateText);
#endif
                if(dateText != nil && photo != nil)
                {
                    NSData* thumb = nil;
                    if(serializedUsers != nil)
                    {
                        for(NSString *uidFromMap in [serializedUsers allKeys])
                        {
                          if([uid isEqualToString:uidFromMap]){
                            //if we have empty image from FB, change with the remembered in the mapOfUsers.
                            
                              //if ([photo rangeOfString:@"static-ak"].location !=                                   NSNotFound){
                                    uid = uidFromMap;
                                    thumb = [serializedUsers objectForKey:uidFromMap];
                              //  }
                            }
                        }
                    }
                    [dataModel saveUserToModel:uid:name:dateText:photo:thumb];
                }
            }
        }
        [dataModel savingContext];
    } 
    else
    {
        NSLog(@"You have no friends.");
    }
}

- (void)findEmptyPhotoUsers {
    
    NSMutableArray *currentRecords = [dataModel fetchRecords];
     NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
     //NSMutableDictionary* serializedUsers = [[standardUserDefaults objectForKey:@"mapOfUsers"]mutableCopy];
    
    for(UserData *uData in currentRecords)
    {
        if ([uData.photo isEqualToString:@"empty"])
        {
            if(uData.thumbimage != nil)
            {
                [mapOfUsers setObject:uData.thumbimage
                                     forKey:uData.userID];
            }
        }
    }
    
    NSArray * ar = [mapOfUsers allKeys];
    if([ar count] > 0){
        [standardUserDefaults setObject:mapOfUsers forKey:@"mapOfUsers"];
        
        //if we have a edit user photo serialize it.
//        if(serializedUsers != nil)
//        {
//          [serializedUsers addEntriesFromDictionary:mapOfUsers];
//          [standardUserDefaults setObject:serializedUsers forKey:@"mapOfUsers"];
//        }
//        else
//        {
//            [standardUserDefaults setObject:mapOfUsers forKey:@"mapOfUsers"];
//        }
    }
}

- (void)deleteUserIfPresentInModel:(id)result {
    
    NSArray *resultData = [result objectForKey:@"data"];
    if ([resultData count] > 0)
    {
        for (NSDictionary *friend in resultData)
        {
            NSString *uid = [friend objectForKey:@"id"];
            NSString *name = [friend objectForKey:@"name"];
            [dataModel deleteCurrentObjectWithNameAndID:name:uid];
        }
    }
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    return;
    
    //NSLog(@"activeUser: %@", request.url);
    if ([request.url rangeOfString:@"/me/friends"].location == NSNotFound) {
        activeUser = [[NSString alloc] initWithFormat:@"%@", [(NSDictionary*)result objectForKey:@"name"]];
        return;
    }
    
    activeUser = [[[NSString alloc] initWithFormat:@"%@", [(NSDictionary*)result objectForKey:@"name"]] autorelease];
    
    return;
    
    //MBProgressHUD *hud =
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ////hud.minShowTime = 2;
    //hud.labelText = @"Importing birthdays...";
    [self findEmptyPhotoUsers];
    [self deleteUserIfPresentInModel:result];
    //[dataModel deleteAllObjects:@"ContactsData"];
    
    [emailMemorize removeAllObjects];
    
    HolidayAppDelegate *appDelegate = (HolidayAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    dispatch_async(dispatch_get_global_queue
                   ( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                       
        [self saveFriendsToDataModel:result];

        dispatch_sync(dispatch_get_main_queue(), ^{
        
#ifdef SEND_APP_REQUESTS
        [self sendLogic];
#endif
           [MBProgressHUD hideHUDForView:self.view animated:YES];
        
            // UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Import of Facebook contacts complete." message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //                        [alert show];
            //                        alert.tag = 1;
            //                        [alert release];
            //
            NSLog(@"EMAIL LOOP - %d Users", emailMemorize.count);
            self.fbFriendsCount = emailMemorize.count;
            
            if (self.fbFriendsCount > 0) {
                NSMutableArray *recipientMails = [[[NSMutableArray alloc] init] autorelease];
                //NSString* body = [NSString stringWithFormat:@"%@ I made you a card. Hope you like it!\n\nhttps://apps.facebook.com/myholidaycards/?card_id=%@\n\n- %@", @"Hello!", @"TEST", @"sender_first_name"];
                NSString* body = [NSString stringWithFormat:@"Hi,\n\nI want to add your birthday to my 2013 calendar on Facebook. Here is a direct link to accept the request: https://apps.facebook.com/davia_calendar/\n\nThanks!\n\n%@", (activeUser && [activeUser rangeOfString:@"(null)"].location == NSNotFound)?activeUser:@""];
                int i = 0;
                for (NSDictionary *friend in emailMemorize) {
                    i++;
                    if (friend) {
                        //NSLog(@"User: %@", fbUser);
                        NSLog(@"The username is:%@", [friend objectForKey:@"username"]);
                        if (friend) {
                            [recipientMails addObject:[NSString stringWithFormat:@"%@@facebook.com", [friend objectForKey:@"username"]]];
                            //[emailMemorize removeObjectAtIndex:0];
                            //[emailMemorize removeObject:friend];
                        }
                    }
                    if (i >= EMAIL_AT_ONCE) {
                        break;
                    }
                }
            
                while (i--) {
                    [emailMemorize removeObjectAtIndex:0];
                }
            
                NSLog(@"EMAIL LOOP - %d Users", emailMemorize.count);
            
                [self sendEmail:@"Updating my calendar" recipients:[NSArray arrayWithObject:@"Selected Friends <postman@daviacalendar.com>"/*sender_email*/]  bcc:recipientMails body:body image:nil];
                //[[self sendEmail]self subject:@"Birthday Calendar" recipients:[NSArray arrayWithObject:@"Selected Recipients <sendmycard@postman@daviacalendar.com>"/*sender_email*/] bcc:recipientMails body:body image:nil];
            
                //for (NSDictionary<FBGraphUser> *fbUser in [sendCandidates allValues]) {
                //    if (fbUser) {
                //        //NSLog(@"User: %@", fbUser);
                //        if (fbUser.username) {
                //            [recipientMails addObject:[NSString stringWithFormat:@"%@@facebook.com", fbUser.username]];
                //        }
                //    }
                //}
            }
            tapCount = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FacebookDownloadComplete" object:@""];
            [NSThread sleepForTimeInterval:1.5];
            appDelegate.tabBarController.selectedIndex = 1;
            [appDelegate startNotifications];
        });
    });
}

- (void)sendMessage:(NSMutableArray *)recTen
{
    
    NSMutableString *mes = [[NSMutableString alloc]init];
    for(int i = 0; i < [recTen count]; i++)
    {        
        [mes appendString:[recTen objectAtIndex:i]];
        if(i == [recTen count]-1)
        {
            [mes appendString:@" "];
        }
        else
        {
            [mes appendString:@","];
        }
    }
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"I'd like to add your birthday to my calendar on my mobile phone.",  @"message",
                                   mes,@"to",
                                   nil];
    [[FacebookManager sharedManager].facebook dialog:@"apprequests"
                    andParams:params
                  andDelegate:self];
    [mes release];
}

- (void)sendLogicHelper:(NSMutableArray *)nextUsers
{
    NSMutableArray *recTen=[[NSMutableArray alloc]init];
    int recCount=[nextUsers count];
    
    if([nextUsers count] >= sendLimit)
    {
        for(int i = 0,j = sendLimit - 1; i < sendLimit || j >= 0; i++, j--)
        {
            [recTen addObject:[nextUsers objectAtIndex:i]];
            [markedMemorize removeObjectAtIndex:j];
        }
        [self sendMessage:recTen];
    }
    else
    {
        if(recCount != 0)
        {
            for(int i = 0; i < recCount; i++)
            {
                [recTen addObject:[nextUsers objectAtIndex:i]];
                [markedMemorize removeLastObject];
            }
            [self sendMessage:recTen];
        }
    }
    [recTen release];
}

- (void)sendLogic
{
    NSMutableArray *recUsers = [[NSMutableArray alloc]init];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for(NSString *val in markedMemorize)
        {
            [recUsers addObject:val];
        }  
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self sendLogicHelper:recUsers];
            [recUsers release];  
        });
    });       

}

-(void) dialogDidComplete:(FBDialog *)dialog{

    NSInteger markedCount = [markedMemorize count];
    if(markedCount != 0)
    {   
        [self sendLogic];
    }
    else
    {
        HolidayAppDelegate *appDelegate = (HolidayAppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.tabBarController.selectedIndex=2;
    }
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    if(alertView.tag == 1)
    {
        if(buttonIndex == 0)
        {
            HolidayAppDelegate *appDelegate = (HolidayAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.kalVC clearTable];
            [appDelegate.kalVC reloadData];
            [appDelegate.kalVC redrawEntireMonth];
            [appDelegate.kalVC showAndSelectDate:[NSDate date]];
            appDelegate.tabBarController.selectedIndex=2;
        }
    }
    else if(alertView.tag == 2){
        
        if(buttonIndex == 1)
        {
            Reachability* wifiReach = [Reachability reachabilityWithHostName: @"www.facebook.com"];
            NetworkStatus netStatus =
            [wifiReach currentReachabilityStatus];
            //if(netStatus == ReachableViaWWAN)
            //{
            //    netStatus = NotReachable;
            //}
            
            MBProgressHUD *hud =
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Importing birthdays...";
            
            if (netStatus != NotReachable)
            {
                if (!activeUser) {
                    if (FBSession.activeSession.isOpen) {
                        [self loadMe];
                    } else {
                        [[FacebookManager sharedManager] openSessionWithAllowLoginUI:YES handler:^{
                            [self loadMe];
                        }];
                    }
                } else {
                    [self getUserFriends];
                }
            }
            else{
                NSString* mes=@"There is no Internet connectivity.";
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:mes delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                tapCount=0;
                return;

            }
        } else {
            // TODO: Load Create Account View
            //NSLog(@"TODO: Load Create Account View");
            //HolidayAppDelegate *appDelegate = (HolidayAppDelegate *)[[UIApplication sharedApplication] delegate];
            //appDelegate.window.rootViewController = appDelegate.createAccountViewController;
            //[appDelegate.navController pushViewController:appDelegate.createAccountViewController animated:YES];
            
            //CreateAccountViewController *createAccountViewController = [[CreateAccountViewController alloc]initWithNibName:@"CreateAccountViewController" bundle:nil];
            //[self.navigationController pushViewController:appDelegate.createAccountViewController animated:YES];
            //[createAccountViewController release];
        }
    }
    else if(alertView.tag == 1000){
        NSLog(@"EMAIL LOOP - %d Users", emailMemorize.count);
        
        if (self.fbFriendsCount > 0) {
            NSMutableArray *recipientMails = [[[NSMutableArray alloc] init] autorelease];
            //NSString* body = [NSString stringWithFormat:@"%@ I made you a card. Hope you like it!\n\nhttps://apps.facebook.com/myholidaycards/?card_id=%@\n\n- %@", @"Hello!", @"TEST", @"sender_first_name"];
            NSString* body = [NSString stringWithFormat:@"Hi,\n\nI want to add your birthday to my 2013 calendar on Facebook. Here is a direct link to accept the request: https://apps.facebook.com/davia_calendar/\n\nThanks!\n\n%@", (activeUser && [activeUser rangeOfString:@"(null)"].location == NSNotFound)?activeUser:@""];
            int i = 0;
            for (NSDictionary *friend in emailMemorize) {
                i++;
                if (friend) {
                    //NSLog(@"User: %@", fbUser);
                    NSLog(@"The username is:%@", [friend objectForKey:@"username"]);
                    if (friend) {
                        [recipientMails addObject:[NSString stringWithFormat:@"%@@facebook.com", [friend objectForKey:@"username"]]];
                        //[emailMemorize removeObjectAtIndex:0];
                        //[emailMemorize removeObject:friend];
                    }
                }
                if (i >= EMAIL_AT_ONCE) {
                    break;
                }
            }
            
            while (i--) {
                [emailMemorize removeObjectAtIndex:0];
            }
            
            NSLog(@"EMAIL LOOP - %d Users", emailMemorize.count);
            
            [self sendEmail:@"Updating my calendar" recipients:[NSArray arrayWithObject:@"Selected Friends <postman@daviacalendar.com>"/*sender_email*/]  bcc:recipientMails body:body image:nil];
            //[[self sendEmail]self subject:@"Birthday Calendar" recipients:[NSArray arrayWithObject:@"Selected Recipients <sendmycard@postman@daviacalendar.com>"/*sender_email*/] bcc:recipientMails body:body image:nil];
            
            //for (NSDictionary<FBGraphUser> *fbUser in [sendCandidates allValues]) {
            //    if (fbUser) {
            //        //NSLog(@"User: %@", fbUser);
            //        if (fbUser.username) {
            //            [recipientMails addObject:[NSString stringWithFormat:@"%@@facebook.com", fbUser.username]];
            //        }
            //    }
            //}
        }
    }
}

-(void) viewWillAppear:(BOOL)animated {
    /*
    if (!activeUser) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"id,picture,name,birthday,username,email",@"fields",nil];
#ifdef DEBUG
        NSLog(@"%@", [[Facebook shared] accessToken]);
#endif
        if ([[FacebookManager sharedManager].facebook accessToken]) {
            [[FacebookManager sharedManager].facebook requestWithGraphPath:@"me" andParams:params andHttpMethod:@"GET" andDelegate:self];
        } else {
            //[[[FacebookManager sharedManager].facebook authorize];
        }
    }
    */
    
    /*
    if (!activeUser) {
        if (FBSession.activeSession.isOpen) {
            [self loadMe];
        } else {
            [[FacebookManager sharedManager] openSessionWithAllowLoginUI:YES handler:^{
                [self loadMe];
            }];
        }
    }
    */
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    UIImage *backgroundImage = [UIImage imageNamed:@"AddC"];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675311];
    }
    
    //bannerView_.frame = CGRectOffset(bannerView_.frame, 0, -bannerView_.frame.size.height);
#ifdef __DISPLAY_BANNER__
    bannerView_.frame = CGRectMake(0.0,
                                    self.view.frame.size.height -
                                    GAD_SIZE_320x50.height,
                                    GAD_SIZE_320x50.width,
                                    GAD_SIZE_320x50.height);
#endif /* __DISPLAY_BANNER__ */
    
    //NSLog(@"%f,%f", self.tabBarController.view.frame.origin.y, self.tabBarController.view.frame.size.height);
    //NSLog(@"%f,%f", self.tabBarController.tabBar.frame.origin.y, self.tabBarController.tabBar.frame.size.height);
    //NSLog(@"%f,%f", self.view.frame.origin.y, self.view.frame.size.height);

}

-(void) viewWillDisappear:(BOOL)animated {
   // HolidayAppDelegate *appDelegate = (HolidayAppDelegate *)[[UIApplication sharedApplication] delegate];
    //[appDelegate startNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FBDidLogin" object:nil];
    [[self.navigationController navigationBar] resetBackground:8765311];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = 0;
    if(section == SECTION_ADD){
        rowCount = 3;
    }else if(section == SECTION_MANAGE){
        rowCount = 1;
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSString *text = nil;
    if(indexPath.section == SECTION_ADD)
    {
        if(indexPath.row == ADD_ROW_FB){
            text=@"From Facebook";
        }else if(indexPath.row == ADD_ROW_CON){
            text=@"From Contacts";
        }else{
            text=@"Custom Birthday";
        }
    }
    else if(indexPath.section == SECTION_MANAGE){
        text=@"Manage Birthdays";
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];

    cell.textLabel.text = text;
    cell.textLabel.textColor=[UIColor colorWithRed:92.0/255 green:72.0/255 blue:22.0/255 alpha:1.0];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ResetButton.png"]];
    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ResetButton.png"]] autorelease];
    //cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ResetButton_Selected.png"]] autorelease];
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:92.0/255 green:72.0/255 blue:22.0/255 alpha:1.0];

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
	UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)]autorelease];
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor colorWithRed:92.0/255 green:72.0/255 blue:22.0/255 alpha:1.0];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:17];
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
    
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
    NSString *text=nil;
    if(section == SECTION_ADD)
         text=@"Add Friends' Birthdays";
    else
        text= @"Manage";
	headerLabel.text = text; // i.e. array element
	[customView addSubview:headerLabel];
    [headerLabel release];
    
	return customView;
}
#pragma mark - Table view delegate


- (void)getContacts:(NSMutableArray *)ff
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.minShowTime = 2;
    hud.labelText = @"Reading contacts...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //NSMutableArray[self readAddressBook];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSMutableArray *ff = [dataModel fetchContactsRecords];
            ContactsViewController *conVC =
            [[ContactsViewController alloc]initWithContacts:ff];
            [self.navigationController pushViewController:conVC animated:YES];
            [conVC release];
        });
    });
}

- (void)fromContacts
{
    //NSMutableArray *ff = [dataModel fetchContactsRecords];
    //NSMutableArray *ff = [self readAddressBook];
    ContactsViewController *conVC =
        [[ContactsViewController alloc]initWithContacts:nil/*ff*/];
        [self.navigationController pushViewController:conVC animated:YES];
    [conVC release];
    
    //[dataModel deleteAllObjects:@"ContactsData"];
    //NSMutableArray *ff = [dataModel fetchContactsRecords];
    //for(ContactsData *con in ff) {
    //    NSLog(@"%@", con.userID);
    //}
    
    //if([ff count] == 0)
    //{
    //    [self getContacts:ff];
    //}
    //else
    //{
    //    ContactsViewController *conVC =
    //    [[ContactsViewController alloc]initWithContacts:ff];
    //    [self.navigationController pushViewController:conVC animated:YES];
    //    [conVC release];
    //
    //    //[dataModel deleteAllObjects:@"ContactsData"];
    //    //[self getContacts:ff];
    //
    //}
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ResetButton_Selected.png"]] autorelease];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == SECTION_ADD)
    {
        if (indexPath.row == ADD_ROW_FB)
        {
            tapCount++;
            Reachability* wifiReach = [Reachability reachabilityWithHostName: @"www.facebook.com"];
            NetworkStatus netStatus =
                                    [wifiReach currentReachabilityStatus];
            //if(netStatus == ReachableViaWWAN)
            //{
            //    netStatus = NotReachable;
            //}

            if (netStatus != NotReachable)
            {
                if(tapCount == 1)
                {
                    MBProgressHUD *hud =
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    //hud.minShowTime = 2;
                    hud.labelText = @"Importing birthdays...";
                    if (!activeUser) {
                        if (FBSession.activeSession.isOpen) {
                            [self loadMe];
                        } else {
                            [[FacebookManager sharedManager] openSessionWithAllowLoginUI:YES handler:^{
                                [self loadMe];
                            }];
                        }
                    } else {
                        [self getUserFriends];
                    }
                }
                HolidayAppDelegate *appDelegate = (HolidayAppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate.kalVC clearTable];
                [appDelegate.kalVC redrawEntireMonth];
            }
            else{
                NSString* mes=@"There is no Internet connectivity.";
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:mes delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                tapCount = 0;
                return;
            }
        }
        else if(indexPath.row == ADD_ROW_CON)
        {   
#ifdef FROM_CONTACTS
            [self fromContacts];
#else
            NSString* mes=@"We're working on upgrading this feature. Stay tuned for updates!";
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Coming Soon" message:mes delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
#endif
        }
        else
        {
            EditBirthdayViewController *mBirthdayVC =[[EditBirthdayViewController alloc]initWithAddController:TRUE:dataModel:managedObjectContext];
            [self.navigationController pushViewController:mBirthdayVC animated:YES];
            [mBirthdayVC release];
        }
    }
    if(indexPath.section == SECTION_MANAGE)
    {
        if(indexPath.row == 0)
        {
            ManageBirthdayViewController *mBirthdayVC=[[ManageBirthdayViewController alloc]initWithNibName:@"ManageBirthdayViewController" bundle:nil];
            [self.navigationController pushViewController:mBirthdayVC animated:YES];
            [mBirthdayVC release];
            
            //NSLog(@"Manage existing birthdays");
        }
    }
}


- (NSString*)getUserPhone:(ABRecordRef)ref
{
    NSString *phoneNumber = nil;
    ABMultiValueRef phones = ABRecordCopyValue(ref, kABPersonPhoneProperty);
    for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
    {
        CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
        phoneNumber = (NSString *)phoneNumberRef;
        //[phoneNumber initWithString:(NSString *)phoneNumberRef];
        CFRelease(phoneNumberRef);
        break;
    }
    CFRelease(phones);
    //NSLog(@"%@", phoneNumber);
    return phoneNumber;
}

- (NSString *)getPersonName:(NSString *)lastName firstName:(NSString *)firstName
{
    NSString* personName = nil;
    if(firstName != nil)
    {
        personName = [firstName stringByAppendingString:@" "];
        if(lastName != nil)
        {
            personName = [personName stringByAppendingString:lastName];
        }
    } 
    else 
    {
        if(lastName != nil)
        {
            personName = [@"" stringByAppendingString:lastName];
        }
    }
    return personName;
}

- (BOOL)isABAddressBookCreateWithOptionsAvailable
{
    return &ABAddressBookCreateWithOptions != NULL;
}

-(void) readAddressBook
{
    //NSMutableArray *addressBookUsers;
    ABAddressBookRef addressBook;
    if ([self isABAddressBookCreateWithOptionsAvailable]) {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    } else {
        addressBook = ABAddressBookCreate();
    }
    
    //NSMutableArray *array = nil;
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if  (accessGranted) {
        CFArrayRef all = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex personCount = ABAddressBookGetPersonCount(addressBook);
        
        //addressBookUsers = [[NSMutableArray alloc] initWithCapacity:personCount];
    
        for(int i = 0 ; i < personCount ; i++)
        {
            ABRecordRef ref = CFArrayGetValueAtIndex(all, i);
            //ABRecordID recordID = ABRecordGetRecordID(kABPersonFirstNameProperty);
            NSString *firstName = (NSString *)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
            NSString *lastName = (NSString *)ABRecordCopyValue(ref, kABPersonLastNameProperty);
            NSDate *birthday =(NSDate*)ABRecordCopyValue(ref,kABPersonBirthdayProperty);
            NSData *personPhoto=(NSData*)ABPersonCopyImageDataWithFormat(ref,kABPersonImageFormatThumbnail);
        
            NSString *stringFromDate=nil;
            if(birthday != nil)
            {
                stringFromDate=[NSDate stringFromDate:birthday withFormat:@"yyyy-MM-dd"];
            }
            [birthday release];

            NSString *personName = [self getPersonName:lastName firstName:firstName];
            NSString *phoneNumber =  [self getUserPhone:ref];
        
            NSNumber *numberID=[NSNumber numberWithInt:i];
            NSNumber *numberChecked=[NSNumber numberWithInt:1];
        
            /*
            if(personName != nil && phoneNumber != nil)
            {
                [dataModel saveContactsToModel:numberID:personName:phoneNumber:numberChecked];
            }
               
            if(stringFromDate != nil && personPhoto != nil)
            {
                NSString* numberIDString=[numberID stringValue];
                [dataModel saveUserToModel:numberIDString:personName:stringFromDate:@"":personPhoto];
            }
            */
            
            if(personName != nil && phoneNumber != nil)
            {
                [dataModel saveContactsToModel:numberID:personName:phoneNumber:numberChecked];
                
                NSString* numberIDString=[numberID stringValue];
                if (personPhoto != nil) {
                    [dataModel saveUserToModel:numberIDString:personName:stringFromDate:nil:personPhoto];
                } else {
                    [dataModel saveUserToModel:numberIDString:personName:stringFromDate:@"":personPhoto];
                }
            }
            
            //if(stringFromDate != nil) {
            //    NSString* numberIDString=[numberID stringValue];
            //    [dataModel saveUserToModel:numberIDString:personName:stringFromDate:@"":personPhoto];
            //}
            [personPhoto release];
            [lastName release];
            [firstName release];
        }
        CFRelease(all);
        CFRelease(addressBook);
        [dataModel savingContext];
    } else {
        [Utils messageDisplay:@"Birthday Calendar" :@"Access to the Address Book Not Granted" :-1];
        if (addressBook) {
            CFRelease(addressBook);
        }
    }
}


-(void)dealloc
{
    [_tableViewMain release];
    [dataModel release];
    [managedObjectContext release];
    [markedMemorize release];
    [emailMemorize release];
    [mapOfUsers release];
    [activeUser release];
    
#ifdef __DISPLAY_BANNER__
    [bannerView_ release];
#endif /* __DISPLAY_BANNER__ */
    
    [super dealloc];
}

#pragma mark Email Support Routines

- (BOOL) canSendEmail {
    return [MFMailComposeViewController canSendMail];
}

- (void) sendEmail:(NSString*)subject recipients:(NSArray*)recipients bcc:(NSArray*)bcc body:(NSString*)body image:(UIImage*)image;
{
    //int recipientCount = [bcc count];
    
    //[[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Email Manager"
    //                                                 withAction:@"Send Mail"
    //                                                  withLabel:@"Recipients Count"
    //                                                  withValue:[NSNumber numberWithInt:recipientCount]];
    
    return;
    
    //self.card_id = cardID;
    if ([self canSendEmail]) {
        MFMailComposeViewController *mailer = [[[MFMailComposeViewController alloc] init] autorelease];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:subject];
        NSArray *toRecipients = recipients;
        [mailer setToRecipients:toRecipients];
        if (bcc) {
            [mailer setBccRecipients:bcc];
        }
        
        if (image) {
            //NSData *imageData = UIImagePNGRepresentation([Utils fixOrientation:image]);
            //[mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"HolidayCards"];
            //NSData *imageData = UIImageJPEGRepresentation([Utils fixOrientation:image], 1.0f);
            //[mailer addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"HolidayCards"];
        }
        
        NSString *emailBody = body;
        [mailer setMessageBody:emailBody isHTML:NO];
        //[self performSelector:@selector(doit:) withObject:mailer afterDelay:0.1];
        //[owner presentModalViewController:mailer animated:YES];
        
        //Check if the app is ignoring interatctions, if so, add a delay for 0.5 sec
        if([[UIApplication sharedApplication] isIgnoringInteractionEvents]==TRUE) {
            [self performSelector:@selector(presentModalViewController:animated:) withObject:mailer afterDelay:0.5];
        } else {
            [self presentModalViewController:mailer animated:YES];
        }
    } else {
        [Utils messageDisplay:@"Birthday Calendar" :@"Oops. Your email account is not yet setup on your iPhone. Email is required to send mails from your Birthday Calendar. Visit Settings > Mail, Contacts, Calendars to setup your email." :-1];
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    if (alertView.tag == 1000) {
        UIButton* button = nil;
        UILabel* message = nil;
        //NSLog(@"UIAlertView subviews: %@", alertView.subviews);
        for (UIView *view in alertView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                NSLog(@"Button: %@", view);
                button = (UIButton*)view;
                button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y + 50
                                          ,button.frame.size.width, button.frame.size.height);
            }
            if ([view isKindOfClass:[UILabel class]]) {
                NSLog(@"Label: %@", view);
                
                if ([((UILabel*)view).text rangeOfString:@"Keep sending"].location != NSNotFound) {
                    message = (UILabel*)view;
                    message.frame = CGRectMake(message.frame.origin.x, message.frame.origin.y + 55
                                               ,message.frame.size.width, message.frame.size.height);
                    
                }
            }
        }
        alertView.frame = CGRectMake(alertView.frame.origin.x, alertView.frame.origin.y -35
                                     ,alertView.frame.size.width, alertView.frame.size.height + 70);
        //alertView.frame = CGRectMake(alertView.frame.origin.x, alertView.frame.origin.y -50
        //                         ,alertView.frame.size.width, 300);
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //UIAlertView *alert;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            //[Utils messageDisplay:[Utils applicationDisplayName] :@"Cards Not Sent"];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            //[Utils messageDisplay:[Utils applicationDisplayName] :@"Cards Not Sent"];
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            if (emailMemorize.count > 0) {
                // Display Progress
                UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Add Birthdays" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease];
                //UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
                //[myTextField setBackgroundColor:[UIColor whiteColor]];
                //CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 130.0);
                //[alertView setTransform:myTransform];
                //[alertView addSubview:myTextField];
                
                //alertView.frame = CGRectMake(20, 20, 200, 150);
                UILabel *percentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(130, 30, 60, 50)] autorelease];
                percentLabel.backgroundColor = [[[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0] autorelease];
                percentLabel.textColor = [[[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:1] autorelease];
                percentLabel.font = [[UIFont boldSystemFontOfSize:20.0f] autorelease];
                //percentLabel.text = @"100%";
                UIProgressView *pv = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
                pv.frame = CGRectMake(40, 70, 200, 50);
                pv.progressViewStyle = UIProgressViewStyleBar;
                //pv.backgroundColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:1];
                pv.trackTintColor = [[[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:1] autorelease];
                pv.progressTintColor = [[[UIColor alloc] initWithRed:0 green:0.5 blue:0 alpha:0.7] autorelease];
                pv.progress = 1 - (float)emailMemorize.count / self.fbFriendsCount;
                NSLog(@"%d of %d", emailMemorize.count, self.fbFriendsCount);
                percentLabel.text = [NSString stringWithFormat:@"%d%%", (int)(pv.progress * 100)];
                [alertView addSubview:percentLabel];
                [alertView addSubview:pv];
                alertView.tag = 1000;
                alertView.message = @"Keep sending to be sure all your friends (100%) are added.";
                //UITextField *textField = [alertView textFieldAtIndex:0];
                //NSLog(@"UITextField: %@", textField);
                [alertView show];
            }
            //NSLog(@"Controller: %@", [[EmailManager sharedManager] card_id]);
            //[Utils messageDisplay:@"Success!" :@"Your card was sent." :@"Close"];
            //if ([Utils sendCard:[[EmailManager sharedManager] card_id]]) {
            //    alert=[[UIAlertView alloc] initWithTitle:@"Success!"
            //                                     message:@"Your card was sent."
            //                                    delegate:self
            //                           cancelButtonTitle:nil
            //                           otherButtonTitles:@"Close", nil];
            //    [alert show];
            //    alert.tag=3;
            //} else {
            //    [Utils messageDisplay:[Utils applicationDisplayName] :@"Cards Not Sent"];
            //}
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            //[Utils messageDisplay:[Utils applicationDisplayName] :@"Cards Not Sent"];
            break;
        default:
            NSLog(@"Mail not sent.");
            //[Utils messageDisplay:[Utils applicationDisplayName] :@"Cards Not Sent"];
            break;
    }
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];

}
@end