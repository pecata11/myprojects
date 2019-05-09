//
//  ManageBirthday.m
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "ManageBirthdayViewController.h"
#import "DataModelManager.h"
#import "UserData.h"
#import "Utils.h"
#import "Debug.h"
#import "Constants.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "EditBirthdayViewController.h"
#import "UIAlertView+property.h"

#import "config.h"

@interface ManageBirthdayViewController ()

@property (nonatomic, retain) NSMutableArray *searchRecords;

- (void) searchRecords:(NSString*)searchString;
- (void) performSearch;
- (void)loadDataSource;

@end


@implementation ManageBirthdayViewController

@synthesize manageTableView = _manageTableView;
@synthesize friendsList=_friendsList;
@synthesize managedObjectContext;
@synthesize dataModel;
@synthesize searchBar = _searchBar;
@synthesize searchRecords=_searchRecords;
@synthesize edit;


- (id)initWithNibName :(NSString *)nibNameOrNil bundle :(NSBundle *)nibBundleOrNil :(NSMutableArray*)editRecords
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        searchPerformed = NO;
    }
    return self;
}
-(void) viewWillAppear:(BOOL)animated {

   [self.searchBar setTintColor:[UIColor colorWithRed:86.0/255 green:66.0/255 blue:16.0/255 alpha:1.0]];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    UIImage *backgroundImage = [UIImage imageNamed:@"AddC"];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675311];
    }
    [self.manageTableView reloadData];
    
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
    
    //NSLog(@"LOAD: %f", -[start timeIntervalSinceNow]);

}

-(void) viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FBDidLogin" object:nil];
    [[self.navigationController navigationBar] resetBackground:8765311];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    // [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
- (void) searchRecords:(NSString *)searchString
{
    NSMutableArray *foundPersons = [[NSMutableArray alloc] init];
    for (UserData *userData in self.friendsList)
    {
        if ([userData.name rangeOfString:searchString options:NSCaseInsensitiveSearch].length > 0)
        {
            [foundPersons addObject:userData];
            // NSLog(@"The author name is:%@",currAuthor.lastName);
        }
    }
    self.searchRecords = foundPersons;
    [foundPersons release];
}
- (void) performSearch
{
    NSString *searchString = self.searchBar.text;
    
    [self searchRecords:searchString];
    searchPerformed = YES;
    [self.manageTableView reloadData];
}

#pragma mark - View lifecycle

- (void)loadDataSource
{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    self.friendsList = [dataModel fetchRecords];
    [self.manageTableView reloadData];
    
    dispatch_async(queue, ^{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
        [self.friendsList sortUsingComparator:^NSComparisonResult(id obj1,id obj2) {
                UserData *inst1 = (UserData *)obj1;
                UserData *inst2 = (UserData *)obj2;
                return [inst1.name compare:inst2.name options:NSCaseInsensitiveSearch];
            }];
                [self.manageTableView reloadData];
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.trackedViewName = @"ManageBirthdayViewController";
    
    //NSLog(@"%f,%f", self.tabBarController.view.frame.origin.y, self.tabBarController.view.frame.size.height);
    //NSLog(@"%f,%f", self.tabBarController.tabBar.frame.origin.y, self.tabBarController.tabBar.frame.size.height);
    //NSLog(@"%f,%f", self.view.frame.origin.y, self.view.frame.size.height);
    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    
#ifdef __DISPLAY_BANNER__
    //bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
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
    self.friendsList=[NSArray array];
    self.manageTableView.delegate = self;
    [self loadDataSource];
    
    self.manageTableView.backgroundColor = [UIColor clearColor];
    
    //[manageTableView reloadInputViews];

    // Do any additional setup after loading the view from its nib.
    //CGRect _headerImageViewRect = self.view.frame;
    //_headerImageViewRect.size.height += [Utils retina4correction];
    //self.view.frame = _headerImageViewRect;
    
    //self.view.backgroundColor = [UIColor greenColor];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    //CGRect _headerImageViewRect = self.view.frame;
    //_headerImageViewRect.size.height += [Utils retina4correction];
    //self.view.frame = _headerImageViewRect;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(searchPerformed){
        return [self.searchRecords count];
    }else{
        return [self.friendsList count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
   
    UserData *uDatat;
    if(searchPerformed){
        uDatat = [self.searchRecords objectAtIndex:indexPath.row];
    }else{
        uDatat = [self.friendsList objectAtIndex:indexPath.row];
    }
   
    cell.textLabel.font=[UIFont boldSystemFontOfSize:17.0];
    cell.textLabel.textColor=BROWN_COLOR;
    NSString* uname=[uDatat.name stringByReplacingOccurrencesOfString:@"?" withString:@""];
    cell.textLabel.text = uname;
    
    NSString* dateText = nil;
    if([uDatat.birthday isEqualToString:@"no"]){
        dateText=@"not presented";
    }
    else
    {
       dateText = [Utils formatDateStringWithMonthAndDay:uDatat.birthday];
    }
    cell.detailTextLabel.font= [UIFont systemFontOfSize:15.0];
    cell.detailTextLabel.textColor=BROWN_COLOR;
    cell.detailTextLabel.text = dateText;
    
    if(uDatat.thumbimage != nil) {
        [cell.imageView stopAnimating];
        cell.imageView.image = [UIImage imageWithData:uDatat.thumbimage];
    } else {
        //NSLog(@"Dragging %d", tableView.dragging);
        //NSLog(@"Decelerating %d", tableView.decelerating);
        
        if (tableView.dragging == NO && tableView.decelerating == NO)
        {
            //[self startIconDownload:appRecord forIndexPath:indexPath];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
            dispatch_async(queue, ^{
                NSURL *imageURL = [NSURL URLWithString:uDatat.photo];
                NSData* imageD = [NSData dataWithContentsOfURL:imageURL];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [dataModel updateCurrentObject:uDatat.userID:uDatat.name:uDatat.birthday:uDatat.photo:imageD];
                    [cell.imageView stopAnimating];
                    cell.imageView.image = [[[UIImage alloc] initWithData:imageD] autorelease];
                    cell.imageView.contentMode = UIViewContentModeScaleToFill;
                    [cell setNeedsLayout];
                });
            });
        }
        // if a download is deferred or in progress, return a placeholder image
        //cell.imageView.image = [UIImage imageNamed:@"Spinner.png"];
        cell.imageView.animationImages = [Utils spinnerImages];
        cell.imageView.animationDuration = 1.1;
        //cell.imageView.contentMode = UIViewContentModeCenter;
        [cell.imageView startAnimating];
    }
    
    return cell;
}
#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    UserData *rowData = nil;
    if(searchPerformed){
        rowData = [self.searchRecords objectAtIndex:indexPath.row];
    }else{
        rowData = [self.friendsList objectAtIndex:indexPath.row];
    }
        NSString* uname = [rowData.name stringByReplacingOccurrencesOfString:@"?" withString:@""];
    
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:uname message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Edit",@"Delete", nil];
    [alert show];
    alert.tag=1;
    alert.property=rowData;
    [alert release];
    rowIndex=indexPath.row;

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 0)
        {
            [_manageTableView deselectRowAtIndexPath:[[_manageTableView indexPathsForSelectedRows] objectAtIndex:0] animated:NO];
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }        
        else if(buttonIndex == 1)
        {
            UserData *rowData = (UserData*)alertView.property;
            //NSLog(@"The data model is:%@",dataModel);
            //NSLog(@"The managedObejctContext is:%@",managedObjectContext);
            EditBirthdayViewController *mBirthdayVC =[[EditBirthdayViewController alloc]initWithUserData:rowData.userID:rowData.name:rowData.birthday:rowData.thumbimage:rowData.photo:dataModel:managedObjectContext];
            [self.navigationController pushViewController:mBirthdayVC animated:YES];
            [mBirthdayVC release];
            [self.manageTableView reloadData];
            //[self loadDataSource];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Are you sure you want to delete this friend?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
            alert.tag = 2;
            [alert release];
        }
    }
    if(alertView.tag == 2)
    {
        if(buttonIndex == 0)
        {
            [_manageTableView deselectRowAtIndexPath:[[_manageTableView indexPathsForSelectedRows] objectAtIndex:0] animated:NO];
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
        if(buttonIndex == 1)
        {
            UserData *uDatat = nil;
            if(searchPerformed){
                uDatat = [self.searchRecords objectAtIndex:rowIndex];
            }else{
                uDatat = [self.friendsList objectAtIndex:rowIndex];
            }
#ifdef DEBUG
            NSLog(@"userID: %@", uDatat.userID);
            NSLog(@"name: %@", uDatat.name);
            NSLog(@"birthday: %@", uDatat.birthday);
            NSLog(@"photo: %@", uDatat.photo);
            NSLog(@"thumbimage: %@", uDatat.thumbimage);
#endif
             if(searchPerformed)
             {
                 [self.searchRecords removeObjectAtIndex:rowIndex];
             }else{
                 [self.friendsList removeObjectAtIndex:rowIndex];
             }
            NSDictionary *customData = [NSDictionary dictionaryWithObjectsAndKeys:uDatat.userID, @"userID", uDatat.name, @"nname", nil];
            //NSLog(@"%@", customData);
            [dataModel deleteCurrentObjectWithNameAndID:uDatat.name:uDatat.userID];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDeleted" object:customData];
            [self.manageTableView reloadData];
            [self loadDataSource];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark UISearchBarDelegate methods

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    [self performSearch];
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    long count = searchPerformed?[self.searchRecords count]:[self.friendsList count];
    if (count > 0)
    {
        NSArray *visiblePaths = [_manageTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            //NSLog(@"%@", indexPath);
            
            UserData *uDatat;
            if(searchPerformed){
                uDatat = [self.searchRecords objectAtIndex:indexPath.row];
            }else{
                uDatat = [self.friendsList objectAtIndex:indexPath.row];
            }
            
            if (!uDatat.thumbimage)
            {
                //NSLog(@"%@", uDatat.name);
                
                UITableViewCell *cell = [_manageTableView cellForRowAtIndexPath:indexPath];
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
                dispatch_async(queue, ^{
                    NSURL *imageURL = [NSURL URLWithString:uDatat.photo];
                    NSLog(@"Image URL: %@", imageURL);
                    NSLog(@"name: %@", uDatat.name);
                    NSData* imageD = [NSData dataWithContentsOfURL:imageURL];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [dataModel updateCurrentObject:uDatat.userID:uDatat.name:uDatat.birthday:uDatat.photo:imageD];
                        
                        if(imageD == nil){
                            //cell.imageView.image = [UIImage imageNamed:@"Spinner.png"];
                            cell.imageView.animationImages = [Utils spinnerImages];
                            cell.imageView.animationDuration = 1.1;
                            //cell.imageView.contentMode = UIViewContentModeCenter;
                            [cell.imageView startAnimating];
                        }else{
                            cell.textLabel.text = uDatat.name;
                            //NSLog(@"name: %@", uDatat);
                            //NSLog(@"length: %d", [imageD length]);
                            [cell.imageView stopAnimating];
                            cell.imageView.image = [[[UIImage alloc] initWithData:imageD] autorelease];
                            cell.imageView.contentMode = UIViewContentModeScaleToFill;
                            //NSLog(@"imageView: %fx%f", cell.imageView.frame.size.width, cell.imageView.frame.size.height);
                            //NSLog(@"image: %fx%f", cell.imageView.image.size.width, cell.imageView.image.size.height);
                            //cell.imageView.frame = CGRectMake(0, 0, cell.imageView.image.size.width + 20, cell.imageView.image.size.height);
                            //NSLog(@"imageView: %fx%f", cell.imageView.frame.size.width, cell.imageView.frame.size.height);
                            //NSLog(@"image: %fx%f", cell.imageView.image.size.width, cell.imageView.image.size.height);
                        }
                        [cell setNeedsLayout];
                    });
                });
            }
        }
    }
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        //NSLog(@"scrollViewDidEndDragging");
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating");
    [self loadImagesForOnscreenRows];
}


-(void) dealloc{
    
    [_manageTableView release];
    [_friendsList release];
    [managedObjectContext release];
    [dataModel release];
    [_searchRecords release];
    [_searchBar release];
    //[uData release];
    
    [super dealloc];
}

@end
