

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "WebDavWrapper.h"


@class FileModel;
@class DataModelManager;
typedef enum FStatus{
    success = 0,
    noencrypted = 1,
    nonetwork = 2
}FileStatus;

@interface SecondDetailViewController : UIViewController <SubstitutableDetailViewController,UIDocumentInteractionControllerDelegate,UIAlertViewDelegate> {
    UINavigationBar *navigationBar;
    NSString *fileName;
    NSString* fileURL;
    UILabel *fileLabel;
    UIButton *encryptButton;
    UIButton *decryptButton;
    UIButton *syncButton;
    UIButton *pushButton;
    UIButton *getButton;
    UIButton *openButton;
    UIDocumentInteractionController *docInteractionController;
    NSError *error;
    NSString *sess_id;    
    NSString *encryptionPass;
    NSString *encryptionIV;
    NSData* passDecoded;
    NSData* ivDecoded; 
    NSString *manString;
    NSString *udid;
    DirectoryManager *dirManager;
    FileModel *fileModel;
    NSString *wdServer;
    NSInteger wdPort;    
    NSManagedObjectContext *managedObjectContext;
}

@property(nonatomic,retain) IBOutlet UINavigationBar *navigationBar;
@property(nonatomic,retain) NSString* fileName;
@property(nonatomic,retain) NSString* fileURL;
@property(nonatomic,retain) IBOutlet UILabel* fileLabel;
@property(nonatomic,retain) FileModel *fileModel;
@property(nonatomic,retain) DataModelManager *dataModel;
@property(nonatomic,retain) IBOutlet UIButton *encryptButton;
@property(nonatomic,retain) IBOutlet UIButton *decryptButton;
@property(nonatomic,retain) IBOutlet UIButton *syncButton;
@property(nonatomic,retain) IBOutlet UIButton *pushButton;
@property(nonatomic,retain) IBOutlet UIButton *getButton;
@property(nonatomic,retain) IBOutlet UIButton *openButton;
@property(nonatomic,retain) UIDocumentInteractionController *docInteractionController;
@property(nonatomic,retain) NSString *sess_id;    
@property(nonatomic,retain) NSString *encryptionPass;
@property(nonatomic,retain) NSString *encryptionIV;
@property(nonatomic,retain) NSData *passDecoded;
@property(nonatomic,retain) NSData *ivDecoded;
@property(nonatomic,retain) NSString *manString;
@property(nonatomic,retain) NSString *udid;
@property(nonatomic,retain) NSString *wdServer;
@property(nonatomic) NSInteger wdPort;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(id)initWithFile:(FileModel*)file;
- (NSString *)applicationDocumentsDirectory;
-(IBAction)encryptionButtonClicked:(id)sender;
-(IBAction)decryptionButtonClicked:(id)sender;
-(IBAction)synchronizeButtonClicked:(id)sender;
-(IBAction)pushButtonClicked:(id)sender;
-(IBAction)pullButtonClicked:(id)sender;
-(IBAction)openButtonClicked:(id)sender;
@end
