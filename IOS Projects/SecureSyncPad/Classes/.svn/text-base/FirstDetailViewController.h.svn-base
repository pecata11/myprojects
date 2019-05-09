

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface FirstDetailViewController : UIViewController <SubstitutableDetailViewController,UISplitViewControllerDelegate> {

    UINavigationBar *toolbar;
    UITableView *tableViewFirst;
    NSString *dirPath;
    NSArray *dirs;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *toolbar;
@property(nonatomic,retain) IBOutlet UITableView *tableViewFirst;
@property(nonatomic,retain) NSString *dirPath;
@property(nonatomic,retain) NSArray *dirs;
@property(nonatomic) BOOL waitingOnAuthentication;
- (id) initWithDirPath:(NSString *)dpath;
@end
