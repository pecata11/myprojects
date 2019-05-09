

#import "RootViewController.h"
#import "FirstDetailViewController.h"
#import "SecondDetailViewController.h"
#import "UIDevice+UIDevice_IdentifierAddition.h"
#import "NSString+NSString__MD5Addition.h"
#import <Foundation/Foundation.h>
#import "FileModel.h"
#import "DirectoryManager.h"
#import "ThirdViewController.h"
#import "Constants.h"
#import "WebDavWrapper.h"
#import "AppDelegate.h"
#import "FMWebDavRequest.h"
#import "base64.h"
#import "CryptManager.h"
#import "Reachability.h"
#import "Entity.h"
#import "MBProgressHUD.h"

@interface RootViewController()

-(void) getWdServerFileList;
-(NSString *)formattedFileSize:(unsigned long long)size;
-(IBAction)loadFilesClicked:(id)sender;
-(IBAction)clearCashe:(id)sender;
- (void)createLocalDirStructure:
                (NSString *)serializedDataPath wdDirList:(NSMutableArray *)wdDirList;
- (void)readServerAndPortFromBundle; 

@end   

@implementation RootViewController

@synthesize popoverController,splitViewController, rootPopoverButtonItem,tableViewMain;
@synthesize wdServer=_wdServer;
@synthesize wdPort=_wdPort;
@synthesize dirs=_dirs;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //self.title=@"Root";
    
    UIButton *dButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    dButton.frame=CGRectMake(0,120,100,35);
    [dButton setTitle:@"Load files" forState:UIControlStateNormal];
    [dButton addTarget:self action:@selector(loadFilesClicked:)
      forControlEvents:UIControlEventTouchUpInside];

    UIButton *btnChange = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnChange.frame = CGRectMake(0, 50, 100, 35);
    [btnChange setTitle:@"ClearCashe" forState:UIControlStateNormal];
    [btnChange addTarget:self action:@selector(clearCashe:) forControlEvents:UIControlEventTouchUpInside];

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 300, 220)];
    [footerView addSubview:dButton];
    [footerView addSubview:btnChange];
    
    tableViewMain.tableFooterView = footerView; 
    
   
    
    [footerView release];

}

-(IBAction)clearCashe:(id)sender
{
    NSError *error=nil;
    NSString *docsFolder = [DirectoryManager documentsDirectory];
    NSString *serializedDataPath = [docsFolder stringByAppendingPathComponent:SERIALIZED_DATA_FILE_NAME];
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if([fileManager fileExistsAtPath:serializedDataPath])
    {
        [fileManager removeItemAtPath:serializedDataPath error:&error];
        NSLog(@"cashe cleared.");
    }
    [fileManager release];
}

-(IBAction)loadFilesClicked:(id)sender
{
      NSString *docsFolder = [DirectoryManager documentsDirectory];
      NSString *serializedDataPath = [docsFolder stringByAppendingPathComponent:SERIALIZED_DATA_FILE_NAME];
      NSFileManager *fileManager = [[NSFileManager alloc]init];
     [self readServerAndPortFromBundle];
    #ifdef __BLOCKS__
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if(![fileManager fileExistsAtPath:serializedDataPath])
        {
            hud.labelText = @"Getting files from server...";
        }
        else{
            hud.labelText = @"Getting files from cash...";
        }
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do a task in the background.
            
            [self getWdServerFileList];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                  [tableViewMain reloadData];
            });
        });
    #endif
    [fileManager release];
    
}


- (void)createLocalDirStructure:(NSString *)serializedDataPath wdDirList:(NSMutableArray *)wdDirList
{

    NSMutableString* encKeys = [dirManager getEncryptionKeys];
    if(encKeys != nil)
    {
        NSArray *encryptionKeys = [encKeys componentsSeparatedByString:@"##"];
        NSString *sessionId = [encryptionKeys objectAtIndex:0];
        
        if ([encryptionKeys count] == 3) 
        {
            NSString *encryptionPass = [encryptionKeys objectAtIndex:1];
            NSString *encryptionIV = [encryptionKeys objectAtIndex:2];
            
            [dirManager createRealDirectoryStructure:wdDirList:sessionId:encryptionPass:encryptionIV];
            self.dirs = [dirManager putDirStructureInFileModelForPath:MAIN_DIR];
            [NSKeyedArchiver archiveRootObject:self.dirs toFile:serializedDataPath];

        } 
    }
    else 
    {
        NSLog(@"Error reading encryption keys.");
    }
}

- (void)readServerAndPortFromBundle 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *server = [defaults stringForKey:@"wdServer"];
    NSString *port=[defaults stringForKey:@"wdPort"];
    self.wdServer=server;
    self.wdPort=[port intValue];
    NSLog(@"The read wdServer from appBundle is:%@",server);
    NSLog(@"The read wdPort from appBundle is:%d",[port intValue]);
}

-(void)getWdServerFileList{
    
    dirManager=[DirectoryManager managerWithValues:self.wdServer:self.wdPort];
    Reachability *reachability = 
                [Reachability reachabilityForInternetConnection:self.wdServer:self.wdPort];   
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSString *docsFolder = [DirectoryManager documentsDirectory];
    NSString *serializedDataPath = [docsFolder stringByAppendingPathComponent:SERIALIZED_DATA_FILE_NAME];
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    
    if (internetStatus != NotReachable) 
    {
        if(![fileManager fileExistsAtPath:serializedDataPath])
        {
            NSMutableArray* wdDirList = [dirManager downloadWebDavDirectory];
            [self createLocalDirStructure:serializedDataPath wdDirList:wdDirList];
        }
        else{
            self.dirs = [NSKeyedUnarchiver unarchiveObjectWithFile:serializedDataPath];
        }
    } 
    else
    {
        NSString *message = @"Server is not reachable.";
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Message" 
                              message:message
                              delegate:nil 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    [fileManager release];
}

- (NSURL *)applicationDocumentsDirectory
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths lastObject];
    
    return [NSURL fileURLWithPath:documentPath];
}
-(void) viewDidUnload {
	[super viewDidUnload];
	
	self.splitViewController = nil;
	self.rootPopoverButtonItem = nil;
}

#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
-(UISplitViewController*) getSplitViewController{
    return self.splitViewController;
}
- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc {
    
    // Keep references to the popover controller and the popover button, and tell the detail view controller to show the button.
    barButtonItem.title = @"Documents";
    self.popoverController = pc;
    self.rootPopoverButtonItem = barButtonItem;
    UIViewController <SubstitutableDetailViewController> *detailViewController = [splitViewController.viewControllers objectAtIndex:1];
    [detailViewController showRootPopoverButtonItem:rootPopoverButtonItem];
}

- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
 
    // Nil out references to the popover controller and the popover button, and tell the detail view controller to hide the button.
    UIViewController <SubstitutableDetailViewController> *detailViewController = [splitViewController.viewControllers objectAtIndex:1];
    [detailViewController invalidateRootPopoverButtonItem:rootPopoverButtonItem];
    self.popoverController = nil;
    self.rootPopoverButtonItem = nil;
}

- (NSString *)formattedFileSize:(unsigned long long)size
{
	NSString *formattedStr = nil;
    if (size == 0) 
		formattedStr = @"Empty";
	else 
		if (size > 0 && size < 1024) 
			formattedStr = [NSString stringWithFormat:@"%qu bytes", size];
        else 
            if (size >= 1024 && size < pow(1024, 2)) 
                formattedStr = [NSString stringWithFormat:@"%.1f KB", (size / 1024.)];
            else 
                if (size >= pow(1024, 2) && size < pow(1024, 3))
                    formattedStr = [NSString stringWithFormat:@"%.2f MB", (size / pow(1024, 2))];
                else 
                    if (size >= pow(1024, 3)) 
                        formattedStr = [NSString stringWithFormat:@"%.3f GB", (size / pow(1024, 3))];
	
	return formattedStr;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    
    // Two sections, one for each detail view controller.
    return [self.dirs count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RootViewControllerCellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set appropriate labels for the cells.
    FileModel *fm = [self.dirs objectAtIndex:indexPath.row];
    cell.textLabel.text = fm.fileName;

    if(fm.directory != 1){
        cell.imageView.image = [UIImage imageNamed:@"file2.png"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"leopard-folder.png"];
    }

    return cell;
}


#pragma mark -
#pragma mark Table view selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     Create and configure a new detail view controller appropriate for the selection.
     */
    //NSUInteger row = indexPath.row;
    UIViewController <SubstitutableDetailViewController> *detailViewController = nil;
    
    FileModel *fm = [self.dirs objectAtIndex:indexPath.row];
    
    if(fm.directory != 1){
        SecondDetailViewController *secondDetailViewController = [[SecondDetailViewController alloc] initWithFile:fm];
        detailViewController = secondDetailViewController;
    }
    else{
        //NSLog(@"Absolute path is:%@",[fm.filePath absoluteString]);
        NSString *strPath=[fm.filePath lastPathComponent];
        FirstDetailViewController *firstDetailViewController = 
        [[FirstDetailViewController alloc] initWithDirPath:strPath];
        [self.navigationItem setTitle:fm.fileName];
        [self.navigationController pushViewController:firstDetailViewController animated:YES];
        [firstDetailViewController toolbar].hidden=YES;
        [firstDetailViewController release];
        //detailViewController = newDetailViewController;

    }
    if(fm.directory != 1)
    {
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, detailViewController, nil];
        splitViewController.viewControllers = viewControllers;
        [viewControllers release];
    }
    else
    {
    ThirdViewController *firstDetailViewController = [[ThirdViewController alloc] initWithNibName:@"ThirdViewController" bundle:nil];

    // Update the split view controller's view controllers array.
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, firstDetailViewController, nil];
    splitViewController.viewControllers = viewControllers;
        //[firstDetailViewController toolbar].hidden=YES;
    [viewControllers release];
        if (rootPopoverButtonItem != nil) {
            [firstDetailViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
        }
        [firstDetailViewController release];
    }
    if(fm.directory != 1){
    // Dismiss the popover if it's present.
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }
    }

    // Configure the new view controller's popover button (after the view has been displayed and its toolbar/navigation bar has been created).
    if (rootPopoverButtonItem != nil) {
        [detailViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
    }

    [detailViewController release];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [popoverController release];
    [rootPopoverButtonItem release];
    [_dirs release];
    [_wdServer release];
    [super dealloc];
}

@end
