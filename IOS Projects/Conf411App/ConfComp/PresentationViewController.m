//
//  PresentationViewController.m
//  ConfComp
//
//  Created by Antoan Tateosian on 02.11.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "PresentationViewController.h"
#import "Presentation.h"
#import "ConferenceController.h"
#import "Author.h"
#import "Institution.h"
#import "AuthorViewController.h"
#import "UITableViewCell-Helpers.h"
#import "ConfSession.h"
#import "ConfTimeFrame.h"
#import "ConfDay.h"
#import "Place.h"
#import "ConferenceMapViewController.h"
#import "ServerShortConferenceInfo.h"
#import "Topic.h"
#import "Constants.h"
#import "Utils.h"
#import "TopicViewController.h"
#import "UINavigationBar+UINavigationBarCategory.h"
#import "PresentationTableViewCellInner.h"
#import "MainViewController.h"
#import "UIViewController+CommonClass.h"
#import "SessionPaper.h"
#import "AgendaPresentations.h"
#import "ConferenceGridViewController.h"

@interface PresentationViewController ()

- (NSString *) presAbstractText;
- (NSString *) presCommentText;
- (void)locationSection:(UITableViewCell **)cell_p;

- (void) btnMarkPressed:(id)sender;

@end

@implementation PresentationViewController

#define PRES_SECTION__PAPER 0
#define PRES_SECTION__PRESENTATION_NAME 1
#define PRES_SECTION__AUTHORS 2
#define PRES_SECTION__VENUE 3
#define PRES_BOARD_NUMBER 4
#define PRES_SECTION__INFO 5

@synthesize tableView,isChecked;
@synthesize sortedAuthors=_sortedAuthors;

- (id) initWithPresentation:(SessionPaper *)inPresentation conferenceController:(ConferenceController *)conferenceController
{
    if ((self = [super initWithNibName:@"Presentation" bundle:[NSBundle mainBundle]]))
    {
        presentation = [inPresentation retain];
        confController = conferenceController;
        
        //for (Author* a in presentation.authors) {
        //    NSLog(@"Author(%d): %@", a.authorId, a.name);
        //}
        
        //for (NSNumber* k in [presentation.dictOrderAuth allKeys]) {
        //    NSLog(@"Order(%@): Author:%@", k, ((Author*)[presentation.dictOrderAuth objectForKey:k]).name);
        //}
        
        NSArray *sortedKeys = [[presentation.dictOrderAuth allKeys] sortedArrayUsingSelector: @selector(compare:)];
        //if (_sortedAuthors == nil) {
        //    _sortedAuthors = [NSMutableArray array];
        //}
        _sortedAuthors = [[NSMutableArray alloc] init];
        for (NSString *key in sortedKeys)
            [(NSMutableArray*)_sortedAuthors addObject: [presentation.dictOrderAuth objectForKey: key]];
        
        //_sortedAuthors = [NSMutableArray array];
        
        //NSLog(@"Presentation Authors: %@", presentation.authors);
        //NSLog(@"Presentation Authors: %@", presentation.dictOrderAuth);
        
        //NSArray *tbl = confController.conference;
        //for (NSDictionary *currRawPresAuth in tbl) {
        //    NSLog(@"%d", presentation.pressId);
        //}
    }
    
    //NSLog(@"Sorted Authors: %@", _sortedAuthors);
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    if ([tableView respondsToSelector:@selector(setBackgroundView:)]) {
        [tableView setBackgroundView:nil];
    }
    tableView.backgroundColor = [UIColor clearColor];
    [self importCommonView:confController];
    
    //_sortedAuthors = [[NSMutableArray alloc] init];
}


-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[self.navigationController navigationBar] resetBackground:8675320];
    [[self.navigationController navigationBar] resetBackground:8675322];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    UIImage *backgroundImage = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        backgroundImage = [UIImage imageNamed:@"background_navbar_presentation_ipad"];
    }
    else
    {
        backgroundImage = [UIImage imageNamed:@"background_navbar_presentation"];
    }

    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        if(!presentation.isMarked){
        UIButton *dButton=[UIButton buttonWithType:UIButtonTypeCustom];
        dButton.frame=CGRectMake(10,0,40,25);
        [dButton setImage:[UIImage imageNamed:@"star_pres.png"]
                 forState:UIControlStateNormal];  
        [dButton addTarget:self action:@selector(btnMarkPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightButton=[[[UIBarButtonItem alloc] initWithCustomView:dButton]autorelease];
        self.navigationItem.rightBarButtonItem = rightButton;
        }else{
            UIButton *dButton=[UIButton buttonWithType:UIButtonTypeCustom];
            dButton.frame=CGRectMake(10,0,40,25);
            [dButton setImage:[UIImage imageNamed:@"star_pres_marked.png"]
                         forState:UIControlStateNormal];  
            [dButton addTarget:self action:@selector(btnMarkPressed:) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *rightButton=[[[UIBarButtonItem alloc] initWithCustomView:dButton]autorelease];
            self.navigationItem.rightBarButtonItem = rightButton;
            }
    }
    else
    {
        
        [[self.navigationController navigationBar] setBackgroundImage:backgroundImage withTag:8675320];
        if(!presentation.isMarked){
        UIButton *dButton=[UIButton buttonWithType:UIButtonTypeCustom];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                dButton.frame=CGRectMake(700,10,40,25);
                
            }
            else{
                dButton.frame=CGRectMake(270,10,40,25);
            }

        [dButton setImage:[UIImage imageNamed:@"star_pres.png"]
                 forState:UIControlStateNormal];  
        [dButton addTarget:self action:@selector(btnMarkPressed:) forControlEvents:UIControlEventTouchUpInside];
        [[self.navigationController navigationBar] 
         setRightButton:dButton withTag:8675322];
        }else{
            UIButton *dButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                dButton.frame=CGRectMake(700,10,40,25);
                
            }
            else{
                dButton.frame=CGRectMake(270,10,40,25);
            }

            [dButton setImage:[UIImage imageNamed:@"star_pres_marked.png"]
                     forState:UIControlStateNormal];  
            [dButton addTarget:self action:@selector(btnMarkPressed:) forControlEvents:UIControlEventTouchUpInside];
            [[self.navigationController navigationBar] 
             setRightButton:dButton withTag:8675323];
        }
    }
    
    [self.tableView reloadData];
    
}

- (void) btnMarkPressed:(id)sender
{
     //UIButton *theButton = (UIButton*)sender;
    //NSLog(@"In buttonMark pressed");
    presentation.marked=!presentation.marked;
    
    if(presentation.isMarked)
    {
        if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        {
            UIButton *dButton=[UIButton buttonWithType:UIButtonTypeCustom];
            dButton.frame=CGRectMake(10,0,40,25);
            [dButton setImage:[UIImage imageNamed:@"star_pres_marked.png"]
                     forState:UIControlStateNormal];  
            [dButton addTarget:self action:@selector(btnMarkPressed:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *rightButton=[[[UIBarButtonItem alloc] initWithCustomView:dButton]autorelease];
            self.navigationItem.rightBarButtonItem = rightButton;
        }
        else
        {
        UIButton *dButton=[UIButton buttonWithType:UIButtonTypeCustom];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                dButton.frame=CGRectMake(700,10,40,25);
                
            }
            else{
                dButton.frame=CGRectMake(270,10,40,25);
            }

        [dButton setImage:[UIImage imageNamed:@"star_pres_marked.png"]
                 forState:UIControlStateNormal];  
        [dButton addTarget:self action:@selector(btnMarkPressed:) forControlEvents:UIControlEventTouchUpInside];
        [[self.navigationController navigationBar] 
         setRightButton:dButton withTag:8675323];
        }
        
    }else{
        // NSLog(@"Unmarked");
        if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        {
            UIButton *dButton=[UIButton buttonWithType:UIButtonTypeCustom];
            dButton.frame=CGRectMake(10,0,40,25);
            [dButton setImage:[UIImage imageNamed:@"star_pres.png"]
                     forState:UIControlStateNormal];  
            [dButton addTarget:self action:@selector(btnMarkPressed:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *rightButton=[[[UIBarButtonItem alloc] initWithCustomView:dButton]autorelease];
            self.navigationItem.rightBarButtonItem = rightButton;

        }
        else
        {
        UIButton *dButton=[UIButton buttonWithType:UIButtonTypeCustom];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            dButton.frame=CGRectMake(700,10,40,25);
                
        }
        else
        {
            dButton.frame=CGRectMake(270,10,40,25);
        }

        [dButton setImage:[UIImage imageNamed:@"star_pres.png"]
                 forState:UIControlStateNormal];  
        [dButton addTarget:self action:@selector(btnMarkPressed:) forControlEvents:UIControlEventTouchUpInside];
        [[self.navigationController navigationBar] 
         setRightButton:dButton withTag:8675323];
        }
    }
 }

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) dealloc
{
    [presentation release];
    [_sortedAuthors release];
    [tableView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *) presAbstractText
{
    if ([presentation.description length] > 0)
    {
        return presentation.description;
    }
    else
    {
        return @"No abstract available";
    }
}

- (NSString *) presCommentText
{
    if ([presentation.comment length] == 0)
    {
        return @"Click to add comment";
    }
    else
    {
        return presentation.comment;
    }
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"The numbers of authors is:%d",[_sortedAuthors count]);
    if (section == PRES_SECTION__AUTHORS)
    {
        return [_sortedAuthors count];
    }
    else
    {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vv;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        vv=[[[UIView alloc]initWithFrame:CGRectMake(10,10,768,60)] autorelease];
    }else{
      vv=[[[UIView alloc]initWithFrame:CGRectMake(10,10,320,60)] autorelease];
    }
    
    //Author *auth = [_sortedAuthors objectAtIndex:section];
  
  if(section == PRES_SECTION__AUTHORS)
  {
      UILabel *label;
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        label=[[UILabel alloc]initWithFrame:CGRectMake(50,0,100,25)]; 
      }else{
         label=[[UILabel alloc]initWithFrame:CGRectMake(10,0,100,25)]; 
      }

   
    label.text=@"Author(s)";    
    label.textColor= [UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    label.backgroundColor=[UIColor clearColor];
      
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        label.font=[UIFont boldSystemFontOfSize:18.0];
      }else{
        label.font=[UIFont boldSystemFontOfSize:14.0];
      }
    [vv addSubview:label];
    [label release];
  }
    return vv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == PRES_SECTION__AUTHORS)
        return 25.0;
    
    return 20.0;
}


- (void)locationSection:(UITableViewCell **)cell_p
{
    static NSString *VenueCellIdentifer = @"VenueCellIdentifier";
    *cell_p = [self.tableView dequeueReusableCellWithIdentifier:VenueCellIdentifer];
    if (*cell_p == nil)
    {
        *cell_p = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:VenueCellIdentifer] autorelease];
    }
    UILabel *label;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        label=[[UILabel alloc]initWithFrame:CGRectMake(50,8,80,30)]; 
        label.font=[UIFont boldSystemFontOfSize:16.0]; 
    }else{
        label=[[UILabel alloc]initWithFrame:CGRectMake(20,8,70,30)]; 
          label.font=[UIFont boldSystemFontOfSize:14.0]; 
    }
    label.text=@"Location:";
    label.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
    
    label.backgroundColor=[UIColor clearColor];
    [*cell_p addSubview:label];
    [label release];
    
    UILabel *label1;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        label1 = [[UILabel alloc]initWithFrame:CGRectMake(label.frame.size.width + 50,8,100,30)];         
    }else{
        label1 = [[UILabel alloc]initWithFrame:CGRectMake(label.frame.size.width + 20,8,100,30)];           
    }
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        label1.font=[UIFont boldSystemFontOfSize:16.0];
    }else{label1.font=[UIFont boldSystemFontOfSize:14.0]; }
    
    label1.text=presentation.session.place.name;
    label1.backgroundColor=[UIColor clearColor];
    [*cell_p addSubview:label1];
    [label1 release];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"marker_map"];
    
    int offset=0;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        offset = 490;                
    } else{ offset = 100;  }
    
    CGFloat sizeWidth= label.frame.size.width + label1.frame.size.width + offset;
    UIImageView *imView =[[UIImageView alloc] initWithFrame:CGRectMake(sizeWidth, 8, backgroundImage.size.width, backgroundImage.size.height)]; 
    imView.image = backgroundImage;
    [*cell_p addSubview:imView];
    [imView release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    switch (indexPath.section)
    {
        case PRES_SECTION__PRESENTATION_NAME:
        {
            
            cell = [PresentationTableViewCellInner cellWithPresentation:presentation:self.tableView:indexPath.section:@"Title:":presentation.title];
                break;
        }
            
        case PRES_SECTION__AUTHORS:
        {
            static NSString *AuthCellIdentifier = @"AuthCellIdentifier";
            
            cell = [self.tableView dequeueReusableCellWithIdentifier:AuthCellIdentifier];
            if (cell == nil)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AuthCellIdentifier] autorelease];
            }
            Author *auth = [_sortedAuthors objectAtIndex:indexPath.row];
            cell.textLabel.text = auth.name;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                cell.textLabel.font=[UIFont boldSystemFontOfSize:18];
            }else{
                cell.textLabel.font=[UIFont boldSystemFontOfSize:14];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            break;
        }

        case PRES_SECTION__VENUE:
        {
            [self locationSection:&cell];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        }
            
        case PRES_BOARD_NUMBER:
        {
            static NSString *PaperCellIdentifer = @"BoardCellIdentifier";
            
            cell = [self.tableView dequeueReusableCellWithIdentifier:PaperCellIdentifer];
            if (cell == nil)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PaperCellIdentifer] autorelease];
            }
            UILabel *label;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
               label=[[UILabel alloc]initWithFrame:CGRectMake(50,8,150,30)]; 
                label.font=[UIFont boldSystemFontOfSize:16.0];
            }else{
                label=[[UILabel alloc]initWithFrame:CGRectMake(20,8,110,30)]; 
                label.font=[UIFont boldSystemFontOfSize:14.0];
            }
         
            label.text=@"Board Number:";
            label.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
            label.backgroundColor=[UIColor clearColor];
            [cell addSubview:label];
            [label release];
            
            UILabel *label1;
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
               label1=[[UILabel alloc]initWithFrame:CGRectMake(label.frame.size.width + 40,8,100,30)];  
                label1.font=[UIFont boldSystemFontOfSize:16.0];
            } else{ label1=[[UILabel alloc]initWithFrame:CGRectMake(label.frame.size.width + 20,8,100,30)]; 
                label1.font=[UIFont boldSystemFontOfSize:14.0];
            }
            if(presentation.boardNumber != nil)
            {
                label1.text=presentation.boardNumber;
            }else{
                label1.text=@"";
            }
            label1.backgroundColor=[UIColor clearColor];
            [cell addSubview:label1];
            [label1 release];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
            
        }
        case PRES_SECTION__PAPER:
        {
            static NSString *PaperCellIdentifer = @"PaperCellIdentifier";
            
            cell = [self.tableView dequeueReusableCellWithIdentifier:PaperCellIdentifer];
            if (cell == nil)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PaperCellIdentifer] autorelease];
            }
            UILabel *label;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
               label=[[UILabel alloc]initWithFrame:CGRectMake(50,8,130,30)]; 
                label.font=[UIFont boldSystemFontOfSize:16.0];
            }else{
               label=[[UILabel alloc]initWithFrame:CGRectMake(20,8,110,30)]; 
                label.font=[UIFont boldSystemFontOfSize:14.0];
            }
            
            label.text=@"Paper Number:";
            label.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
            label.backgroundColor=[UIColor clearColor];
            [cell addSubview:label];
            [label release];
            UILabel *label1;
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                label1=[[UILabel alloc]initWithFrame:CGRectMake(label.frame.size.width + 40,8,100,30)];  
                label1.font=[UIFont boldSystemFontOfSize:16.0];
            } else{ label1=[[UILabel alloc]initWithFrame:CGRectMake(label.frame.size.width + 20,8,100,30)]; 
                label1.font=[UIFont boldSystemFontOfSize:14.0];
            }
            if(presentation.programNumber != nil)
            {
                label1.text=presentation.programNumber;
            }else{
                label1.text=@"";
            }
            label1.backgroundColor=[UIColor clearColor];
            [cell addSubview:label1];
            [label1 release];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;

        }
        case PRES_SECTION__INFO:
        {
            static NSString *InfoCellIdentifer = @"InfoCellIdentifier";
            
            cell = [self.tableView dequeueReusableCellWithIdentifier:InfoCellIdentifer];
            if (cell == nil)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:InfoCellIdentifer] autorelease];
            }
            UILabel *label;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                label=[[UILabel alloc]initWithFrame:CGRectMake(50,10,100,30)]; 

                label.font=[UIFont boldSystemFontOfSize:16.0];
            }else{
                label=[[UILabel alloc]initWithFrame:CGRectMake(20,10,70,30)]; 
 
                label.font=[UIFont boldSystemFontOfSize:14.0];
            }

            label.text=@"Abstract:";
            label.textColor=[UIColor colorWithRed:9.0/255 green:93.0/255 blue:167.0/255 alpha:1.0];
            label.backgroundColor=[UIColor clearColor];
            [cell addSubview:label];
            [label release];
            UITextView *textView;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
               textView= [[UITextView alloc] initWithFrame:CGRectMake(50,label.frame.size.height+10,580,440)]; 
                
               textView.font=[UIFont systemFontOfSize:18.0];;
            }else{
                textView= [[UITextView alloc] initWithFrame:CGRectMake(15,label.frame.size.height+10,280,240)];
                
               textView.font=[UIFont systemFontOfSize:12.0];
            }

            textView.editable=NO;
            textView.scrollEnabled=YES;
            textView.showsVerticalScrollIndicator=NO;
            textView.showsHorizontalScrollIndicator=NO;
            textView.opaque=YES;
            textView.text=[self presAbstractText];
            textView.backgroundColor=[UIColor clearColor];
            [cell addSubview:textView];
            [textView release];
            
        break;
        }
              default:
        {
            break;
        }
    }
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case PRES_SECTION__AUTHORS:
            return @"Author(s)";
        case PRES_SECTION__INFO:
            return @"Abstract";
              default:
            return nil;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case PRES_SECTION__PRESENTATION_NAME:
        {
            return 90.0;
        }
        case PRES_SECTION__INFO:
        {
            return 280.0;
            
        }
           default:
        {
            return 44.0;
        }
    }
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section)
    {
        case PRES_SECTION__VENUE:
        {
            UIImage *image=[confController conference].mapImage;
            ConferenceMapViewController *mapVc = [[ConferenceMapViewController alloc] initWithMapImage:image:confController];
            [mapVc view];
            [mapVc markPlace:presentation.session.place];
            [self.navigationController pushViewController:mapVc animated:YES];
            [mapVc release];
            
            break;
        }
        case PRES_SECTION__AUTHORS:
        {
            Author *auth = [_sortedAuthors objectAtIndex:indexPath.row];
            AuthorViewController *authVc = [[AuthorViewController alloc] initWithAuthor:auth conferenceController:confController];
            [self.navigationController pushViewController:authVc animated:YES];
            [authVc release];
            
            break;
        }
        default:
        {
            break;
        }
    }
}


#pragma mark -
#pragma mark ScoreTableViewCellDelegate methods

- (void) scoreTableViewCellScoreChanged:(ScoreTableViewCell *)scoreTableViewCell
{
    //presentation.score = scoreTableViewCell.score;
}

@end
