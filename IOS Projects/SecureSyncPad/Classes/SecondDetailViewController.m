#import "SecondDetailViewController.h"
#import "FileModel.h"
#import "CryptManager.h"
#import "DirectoryManager.h"
#import "Reachability.h"
#import "Constants.h"
#import "UIDevice+UIDevice_IdentifierAddition.h"
#import "NSString+NSString__MD5Addition.h"
#include "base64.h"
#import "FMWebDavRequest.h"
#import "Entity.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "DataModelManager.h"

@interface SecondDetailViewController()
    
-(BOOL)isReachable;
 
-(FileStatus)pushFileToServer:(NSString*)fName:(NSString*)fPath;
-(FileStatus) pullFileFromServer;
-(void)showMessage:(NSString*)message;
-(void)checkPushStatusAndShowMessage:(FileStatus)status;
@end   

@implementation SecondDetailViewController

@synthesize navigationBar,fileURL,fileName,fileLabel,fileModel;
@synthesize encryptButton;
@synthesize decryptButton;
@synthesize syncButton;
@synthesize pushButton;
@synthesize getButton;
@synthesize openButton;
@synthesize docInteractionController;
@synthesize sess_id,encryptionPass,encryptionIV,passDecoded,ivDecoded;
@synthesize  udid,manString;
@synthesize managedObjectContext;
@synthesize wdServer=_wdServer;
@synthesize wdPort=_wdPort;
@synthesize dataModel;

#pragma mark -
#pragma mark View lifecycle

-(id)initWithFile:(FileModel *)file{
    if ((self = [super initWithNibName:@"SecondDetailView" bundle:[NSBundle mainBundle]]))
    {
        self.fileModel = file;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* server = [defaults stringForKey:@"wdServer"];
        NSString* port=[defaults stringForKey:@"wdPort"];
        self.wdServer=server;
        self.wdPort=[port intValue];
        dirManager = [[DirectoryManager alloc] initialize:self.wdServer:self.wdPort];
        self.dataModel=[[DataModelManager alloc]init];
        self.managedObjectContext=[DataModelManager getObjectModel];
        //get the file if it is modified and copied in /Inbox directory from outher program.
        [dirManager getModifiedFileIfExist:fileModel.fileName];
        
        NSMutableString* encKeys = [dirManager getEncryptionKeys];
        NSArray *temparray = [encKeys componentsSeparatedByString:@"##"];
        self.sess_id = [temparray objectAtIndex:0];
        self.encryptionPass = [temparray objectAtIndex:1];
        self.encryptionIV = [temparray objectAtIndex:2];
        
        self.passDecoded = [base64 decodeBase64FromString:ENC_PASS];
        self.ivDecoded=[base64 decodeBase64FromString:ENC_IV];

    }
    return self;
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self.fileLabel setText:self.fileModel.fileName];
    
//    dirManager=[[DirectoryManager alloc]initialize];
//    
//    NSMutableString* encKeys = [dirManager getEncryptionKeys];
//    NSArray *temparray = [encKeys componentsSeparatedByString:@"##"];
//    self.sess_id = [temparray objectAtIndex:0];
//    self.encryptionPass = [temparray objectAtIndex:1];
//    self.encryptionIV = [temparray objectAtIndex:2];
//    self.passDecoded = [base64 decodeBase64FromString:ENC_PASS];
//    self.ivDecoded=[base64 decodeBase64FromString:ENC_IV];
    
    if (fileModel.encrypted) {
        [encryptButton setEnabled:NO];
        [decryptButton setEnabled:YES];
        [syncButton setEnabled:YES];
        [pushButton setEnabled:YES];
        [getButton setEnabled:YES];
        [openButton setEnabled:NO];
    } else {
        [encryptButton setEnabled:YES];
        [decryptButton setEnabled:NO];
        [openButton setEnabled:YES];
        [getButton setEnabled:YES];
        [pushButton setEnabled:NO];
        [syncButton setEnabled:NO];
    }
}

-(void) viewDidUnload {
	[super viewDidUnload];
	self.navigationBar = nil;
}


-(IBAction)encryptionButtonClicked:(id)sender{
    
    if (fileModel.decrypted == 1) 
    {
        NSLog(@"In encryption");
        [dirManager getModifiedFileIfExist:fileModel.fileName];
        NSData *decryptData = [NSData dataWithContentsOfFile:fileModel.filePath];
        NSData *encryptedData = [CryptManager encryptData:decryptData key:self.passDecoded iv:self.ivDecoded];
        if (encryptedData != nil) {
            NSFileManager *fileManager=[[NSFileManager alloc]init];
           //NSLog(@"File encrypted data is:%@",encryptedData);
        
            [fileManager createFileAtPath:fileModel.filePath contents:encryptedData attributes:nil];  
            NSString *msg = @"File encrypted successfully.";
            [self showMessage:msg];
            [fileManager release];
            
            fileModel.encrypted=YES;
            fileModel.decrypted=NO;
            
            [encryptButton setEnabled:NO];
            [decryptButton setEnabled:YES];
            [openButton setEnabled:NO];
            [pushButton setEnabled:YES];
            [syncButton setEnabled:YES];
        }
    }
    else
    {
        NSString *msg = @"File is encrypted already.";
        [self showMessage:msg];
    }
}
 

-(IBAction)decryptionButtonClicked:(id)sender{
    
    if(fileModel.encrypted == 1)
    {
        NSData *encryptData = [NSData dataWithContentsOfFile:fileModel.filePath];
        NSData *decryptedData = [CryptManager decryptData:encryptData key:self.passDecoded iv:self.ivDecoded];
        if (decryptedData != nil) {
            NSFileManager *fileManager=[[NSFileManager alloc]init];
            //NSLog(@"File decrypted data is:%@",decryptedData);
            [fileManager createFileAtPath:fileModel.filePath contents:decryptedData attributes:nil];
            NSString *msg = @"File decrypted successfully.";
            [self showMessage:msg];
            [fileManager release];

            fileModel.encrypted=NO;
            fileModel.decrypted=YES;
            [encryptButton setEnabled:YES];
            [decryptButton setEnabled:NO];
            [openButton setEnabled:YES];
            [pushButton setEnabled:NO];
            [syncButton setEnabled:NO];
        }
    }
    else
    {
        NSString *msg = @"File is decrypted already.";
        [self showMessage:msg];
    }
}

-(FileStatus)pushFileToServer:(NSString*)fName:(NSString*)fPath{
    
    if([self isReachable]) 
    {
        if(fileModel.encrypted == 1)
        {
            NSLog(@"self.encryptionPass is:%@",self.encryptionPass);
            NSLog(@"self.encryptionIV is:%@",self.encryptionIV);
            NSString *filePutURL = [self.wdServer stringByAppendingPathComponent:fName];
            NSData *fileData = [NSData dataWithContentsOfFile:fPath];
            NSData* encKeyDecoded = [base64 decodeBase64FromString:self.encryptionPass];
            NSData* ivKeyDecoded=[base64 decodeBase64FromString:self.encryptionIV]; 
            
            NSData *encryptedData = [CryptManager encryptData:fileData 
                                                          key:encKeyDecoded 
                                                           iv:ivKeyDecoded];
            NSLog(@"File encrypted");
            [[dirManager getDavWrapper] callPutRequest:encryptedData:filePutURL:self.sess_id];

            return success;
        }
        else return noencrypted; 
    }
    else return nonetwork;
    
}

-(FileStatus) pullFileFromServer{
    
    if ([self isReachable]) 
    {
        NSString *fileGetURL = [self.wdServer stringByAppendingPathComponent:fileModel.fileName];
        NSData *fileData = [[dirManager getDavWrapper]callGetRequest:fileGetURL:self.sess_id];
        NSData* encKeyDecoded = [base64 decodeBase64FromString:self.encryptionPass];
        NSData* ivKeyDecoded=[base64 decodeBase64FromString:self.encryptionIV];
        
        NSData *decryptedData = [CryptManager decryptData:fileData key:encKeyDecoded iv:ivKeyDecoded];
        
        NSFileManager *localFileManager=[[NSFileManager alloc]init];
        [localFileManager createFileAtPath:fileModel.filePath contents:decryptedData attributes:nil];
        [localFileManager release];
        fileModel.encrypted=YES;
        fileModel.decrypted=NO;
        [encryptButton setEnabled:NO];
        [decryptButton setEnabled:YES];
        [openButton setEnabled:NO];
        [pushButton setEnabled:YES];
        [syncButton setEnabled:YES];
        return success;
    }
    else return nonetwork;
    
}

-(void)showMessage:(NSString*)message{
    
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" 
                                                    message:message
                                                   delegate:nil 
                                                cancelButtonTitle:@"OK" 
                                                otherButtonTitles:nil];
    [alert show];

    [alert release];
    
}

-(IBAction)pushButtonClicked:(id)sender{
    
#ifdef __BLOCKS__
    // No need to retain (just a local variable)
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Pushing file...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do a taks in the background.
       FileStatus status=[self pushFileToServer:fileModel.fileName:fileModel.filePath];
        // Hide the HUD in the main tread 
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self checkPushStatusAndShowMessage:status];
        });
    });
#endif
}

-(IBAction)pullButtonClicked:(id)sender{
#ifdef __BLOCKS__
    // No need to retain (just a local variable)
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Getting file...";
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do a task in the background.
         FileStatus status=[self pullFileFromServer];
        // Hide the HUD in the main tread 
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            switch (status) {
                case success:
                {
                    NSString *msg=[NSString stringWithFormat:@"%@ file get successfully",fileModel.fileName];
                    [self showMessage:msg];
                }break;
                case nonetwork:
                {
                    NSString *msg = @"There are no network connection to get the file.";
                    [self showMessage:msg]; 
                }break;
                default:
                    break;
            }
        });
    });
#endif
}

- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    if (self.docInteractionController == nil)
    {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }
    else
    {
        self.docInteractionController.URL = url;
    }
}

-(IBAction)openButtonClicked:(id)sender{
    
    if(fileModel.decrypted == 1)
    {
        NSLog(@"File path from open file is:%@",fileModel.filePath);
        NSURL *url = [NSURL fileURLWithPath:fileModel.filePath];
        NSLog(@"The file url is:%@",url);
        [self setupDocumentControllerWithURL:url];
        [docInteractionController presentOptionsMenuFromRect:[sender bounds] inView:self.view animated:YES];
    }
    else
    {
        NSString *msg = @"To open the file you should first decrypt it.";
        [self showMessage:msg];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSMutableArray* fetchRecords = [dataModel fetchRecords];
        #ifdef __BLOCKS__
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Synchronizing files..";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do a task in the background.
            BOOL flag =  FALSE;
            for(Entity *entity in fetchRecords)
            {
                //push the file to server except the current file (it is already pushed).
                if(![entity.fileName isEqualToString:fileModel.fileName])
                {      
                      flag = TRUE;
                      [self pushFileToServer:entity.fileName:entity.filePath];
                }
            }
            // Hide the HUD in the main tread 
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if(flag){
                    NSString* msg=@"All files are synchronized.";
                    [self showMessage:msg];
                }
                //reset the cash.
                [dataModel deleteAllObjects:@"Entity"];
          });
        });
#endif
    }
}

-(void) checkPushStatusAndShowMessage:(FileStatus)status{
    
    NSMutableArray* fetchRecords = [dataModel fetchRecords];
    if([fetchRecords count] == 0)
    {
        switch (status) {
            case success:
            {
                NSString *msg=[NSString stringWithFormat:@"%@ file pushed successfully",fileModel.fileName];
                [self showMessage:msg];
            }break;
            case noencrypted:
            {
                NSString *msg = @"To push the file, you should first encrypt the file.";
                [self showMessage:msg]; 
            }break;
            case nonetwork:
            {
                NSString *msg = @"There are no network connection to push the file.";
                [self showMessage:msg]; 
            }break;
            default:
                break;
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"There are files waiting for synchronization,do you want to synchronize these files also?"
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"Yes"
                              otherButtonTitles:@"No", nil];
        [alert show];
        [alert release];
    }
    
}

-(IBAction)synchronizeButtonClicked:(id)sender{
    
    if ([self isReachable]) 
    {
        if(fileModel.encrypted == 1)
        {
            #ifdef __BLOCKS__
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Pushing file...";
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Do a taks in the background.
                 FileStatus status = [self pushFileToServer:fileModel.fileName:fileModel.filePath];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self checkPushStatusAndShowMessage:status];
                });
            });
            #endif
        }
    }
    else
    {   
         NSString *msg = @"File save will be pushed next time when the device is online.";
        
         if([dataModel findCurrentObjectWithName:fileModel.fileName]){
             
             [dataModel deleteCurrentObjectWithName:fileModel.fileName];
             [dataModel saveFileToModel:fileModel.fileName:fileModel.filePath];
             [self showMessage:msg]; 
         }
         else{
             [dataModel saveFileToModel:fileModel.fileName:fileModel.filePath];
             [self showMessage:msg]; 
         }
    }
}

-(BOOL)isReachable{
   Reachability *reachability = [Reachability 
                                 reachabilityForInternetConnection:self.wdServer:self.wdPort];  
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus != NotReachable) 
    {
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller 
       willBeginSendingToApplication:(NSString *)application {
    
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller 
          didEndSendingToApplication:(NSString *)application {
    
}

-(void)documentInteractionControllerDidDismissOpenInMenu:
(UIDocumentInteractionController *)controller {
    
}

#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Add the popover button to the left navigation item.
    [navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:NO];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Remove the popover button.
    [navigationBar.topItem setLeftBarButtonItem:nil animated:NO];
}


#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [navigationBar release];
    [managedObjectContext release];
    [dataModel release];
    [fileURL release];
    [fileName release];
    [dirManager release];
    [super dealloc];
}	

@end