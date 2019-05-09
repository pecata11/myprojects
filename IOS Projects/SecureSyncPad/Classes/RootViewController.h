
/*
 SubstitutableDetailViewController defines the protocol that detail view controllers must adopt. The protocol specifies methods to hide and show the bar button item controlling the popover.

 */
@protocol SubstitutableDetailViewController
- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
@end
//
@class DirectoryManager;
@interface RootViewController : UIViewController <UISplitViewControllerDelegate> {
	UISplitViewController *splitViewController;
    UIPopoverController *popoverController;    
    UIBarButtonItem *rootPopoverButtonItem;
    NSMutableArray *dirs;
    UITableView *tableViewMain;
    NSString *wdServer;
    NSInteger wdPort;
    DirectoryManager *dirManager;

}

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;
@property (nonatomic, retain) NSMutableArray *dirs;
@property (nonatomic, retain) IBOutlet UITableView *tableViewMain;
@property(nonatomic,retain) NSString *wdServer;
@property(nonatomic) NSInteger wdPort;

-(UISplitViewController*) getSplitViewController;

@end