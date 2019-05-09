

#import <Foundation/Foundation.h>

#import "Facebook.h"

//#import "User.h"

typedef void(^SuccessHandler)();

@interface FacebookManager : NSObject

@property (strong, nonatomic) Facebook *facebook;

+ (FacebookManager*) sharedManager;

//- (User *) activeUser;

- (void) sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error handler:(SuccessHandler)handler;

- (BOOL) openSessionWithAllowLoginUI:(BOOL)allowLoginUI handler:(SuccessHandler)handler;

- (BOOL) isSessionActive;
- (void) closeSession;
- (void) closeAndClearTokenInformation;

- (void) handleDidBecomeActive;
- (BOOL) handleOpenURL:(NSURL*) url;

@end
