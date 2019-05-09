#import "AppDelegate.h"
#import "RootViewController.h"
#import "DirectoryManager.h"
#import "Constants.h"
#import "SecondDetailViewController.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window, splitViewController,finished;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sdServerDefaultValue = [NSDictionary dictionaryWithObject:WEB_DAV_EXT_URL forKey:@"wdServer"];
        NSDictionary *wdPortDefaultValue = [NSDictionary dictionaryWithObject:EXT_PORT forKey:@"wdPort"];
        [defaults registerDefaults:sdServerDefaultValue];
        [defaults registerDefaults:wdPortDefaultValue];
   
	[window addSubview:splitViewController.view];
    [window makeKeyAndVisible];
	return YES;
    
}
-(BOOL)application:(UIApplication *)application 
           openURL:(NSURL *)url 
 sourceApplication:(NSString *)sourceApplication 
        annotation:(id)annotation {    
    if (url != nil && [url isFileURL]) {
        //[self handleDocumentOpenURL:url];
        //NSLog(@"Te file url:%@",url);
    }    
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url { 
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}

- (void)dealloc {
    [splitViewController release];
    [window release];
    [super dealloc];
}
@end