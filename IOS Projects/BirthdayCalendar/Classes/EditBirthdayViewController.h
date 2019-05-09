//
//  EditBirthdayViewController.h
//  BirthdayCalendar
//
//  Created by Petko Yanakiev on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAITrackedViewController.h"

#import "config.h"

#ifdef __DISPLAY_BANNER__
#import "GADBannerView.h"
#endif /* __DISPLAY_BANNER__ */

@class DataModelManager;
@interface EditBirthdayViewController : GAITrackedViewController <UITextFieldDelegate,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
    //UIActionSheet *birthSheet;
    UIActionSheet *actionSheet;
    //NSString *userImageURL;
    UITextField *firstNameTextField;
    UITextField *lastNameTextField;
    UITextField *birthdayTextField;
    NSString *userName;
    NSString* userDate;
    NSDate *birthDate;
    NSString* userID;
    UIImage *pickedImage;
    NSString* photo;
    id datasource;
    NSManagedObjectContext *managedObjectContext;
    DataModelManager *dataModel;
    BOOL addBirthday;
    UIButton *photoButton;
    NSMutableArray *editRecords;
#ifdef __DISPLAY_BANNER__
    GADBannerView *bannerView_;
#endif /* __DISPLAY_BANNER__ */
}

-(id)initWithUserData :(NSString*)auserID :(NSString*)auserName :(NSString*)auserDate :(NSData*)userImage :(NSString *)uPhoto :(DataModelManager*)p_dataModel :(NSManagedObjectContext *)p_managedObjectContext;
-(id)initWithAddController :(BOOL)add :(DataModelManager*)p_dataModel :(NSManagedObjectContext*)p_managedObjectContext;

@property(nonatomic,retain)IBOutlet UIActionSheet *actionSheet;
@property(nonatomic,retain)IBOutlet UITextField *firstNameTextField;
@property(nonatomic,retain)IBOutlet UITextField *lastNameTextField;
@property(nonatomic,retain)IBOutlet UITextField *birthdayTextField;
@property(nonatomic,retain) NSDate *birthDate;
@property(nonatomic,retain)NSData *userImageData;
@property(nonatomic,retain)NSString *userName;
@property(nonatomic,retain)NSString *userDate;
@property(nonatomic,retain)NSString *userID;
@property(nonatomic,retain)NSString *photo;
@property(nonatomic,retain) UIImage *pickedImage;
@property(nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,retain) DataModelManager *dataModel;
@property(nonatomic) BOOL addBirthday;
@property(nonatomic,retain) IBOutlet UIButton *photoButton;
@property(nonatomic,retain) NSMutableArray *editRecords;

-(void)setBirth;
-(void)cancelDateSet;
-(void)dismissDateSet;
-(IBAction)saveUser:(id)sender;
-(IBAction)cancelUser:(id)sender;
- (IBAction)photoTapped;
@end
