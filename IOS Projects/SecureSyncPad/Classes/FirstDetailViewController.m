

#import "FirstDetailViewController.h"
#import "FileModel.h"
#import "SecondDetailViewController.h"
#import "DirectoryManager.h"
#import "ThirdViewController.h"
#import "AppDelegate.h"
#import "WebDavWrapper.h"
#import "Constants.h"
#import "FMWebDavRequest.h"


@implementation FirstDetailViewController

@synthesize toolbar,tableViewFirst,dirPath,dirs,waitingOnAuthentication;


- (id) initWithDirPath:(NSString *)dpath
{
    if ((self = [super initWithNibName:@"FirstDetailView" bundle:[NSBundle mainBundle]]))
    {
       // NSLog(@"dpath from init method is:%@",dpath);
        self.dirPath = dpath;
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidUnload {
	[super viewDidUnload];
	self.toolbar = nil;
    //self.title=@"First";
}
- (void)viewDidLoad {
	[super viewDidLoad];
	self.toolbar = nil;
    self.title=@"First";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *server = [defaults stringForKey:@"wdServer"];
    NSString *port=[defaults stringForKey:@"wdPort"];
    DirectoryManager *dirM=[DirectoryManager managerWithValues:server:[port intValue]];
    dirs=[[NSMutableArray alloc]init];
    dirs=[dirM putDirStructureInFileModelForPath:self.dirPath];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    
    // Two sections, one for each detail view controller.
    return [self.dirs count];
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"FirstViewControllerCellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set appropriate labels for the cells.
    FileModel *fm = [dirs objectAtIndex:indexPath.row];
    cell.textLabel.text = fm.fileName;
                                   
    //NSLog(@"is directory:%@",fm.filePath);
    if(fm.directory != 1){
        cell.imageView.image = [UIImage imageNamed:@"file2.png"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"leopard-folder.png"];
    }
  
    //    if (indexPath.row == 0) {
    //        cell.textLabel.text = @"First Detail View Controller";
    //    }
    //    else {
    //        cell.textLabel.text = @"Second Detail View Controller";
    //    }
    
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
        SecondDetailViewController *secondDetailViewController = [[SecondDetailViewController alloc]initWithFile:fm];
        detailViewController = secondDetailViewController;
    }else{
        FirstDetailViewController *firstDetailViewController = [[FirstDetailViewController alloc] initWithDirPath:fm.filePath];
        [self.navigationItem setTitle:fm.fileName];
        [self.navigationController pushViewController:firstDetailViewController animated:YES];
        [firstDetailViewController toolbar].hidden=YES;
        [firstDetailViewController release];        
    }
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UISplitViewController *split = del.splitViewController;
    
    if(fm.directory != 1){
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, detailViewController, nil];
        split.viewControllers = viewControllers;
        [viewControllers release];
    
    }else{
        
        ThirdViewController *firstDetailViewController = [[ThirdViewController alloc] initWithNibName:@"ThirdViewController" bundle:nil];      
        // Update the split view controller's view controllers array.
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, firstDetailViewController, nil];
        split.splitViewController.viewControllers = viewControllers;
        //[firstDetailViewController toolbar].hidden=YES;
        [viewControllers release];
        [firstDetailViewController release];
    }
    [detailViewController release];
}



#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Add the popover button to the toolbar.
    [toolbar.topItem setLeftBarButtonItem:barButtonItem animated:NO];
//    NSMutableArray *itemsArray = [toolbar.items mutableCopy];
//    [itemsArray insertObject:barButtonItem atIndex:0];
//    [toolbar setItems:itemsArray animated:NO];
//    [itemsArray release];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Remove the popover button from the toolbar.
      [toolbar.topItem setLeftBarButtonItem:nil animated:NO];
//    NSMutableArray *itemsArray = [toolbar.items mutableCopy];
//    [itemsArray removeObject:barButtonItem];
//    [toolbar setItems:itemsArray animated:NO];
//    [itemsArray release];
}


#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [toolbar release];
    [dirs release];
    [tableViewFirst release];
    [dirPath release];
    [super dealloc];
}	
@end