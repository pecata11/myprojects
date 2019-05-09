//
//  PostToWallSMSViewController.m
//  BirthdayCalendar
//
//  Created by Dimitar Kamenov on 2/11/13.
//
//

#import "PostToWallSMSViewController.h"

@interface PostToWallSMSViewController ()

@end

@implementation PostToWallSMSViewController

@synthesize alertView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BlackScreen"]];
        self.view.alpha = 1;
        [self.alertView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Post_PopUp_Base"]]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setHandler:(SelectDoneHandler) dh {
    doneHandler = dh;
}

- (IBAction) closeDialogWithButton:(id)sender {
    UIButton *button = (UIButton*) sender;
    [self dismissViewControllerAnimated:YES completion:^{
        doneHandler(self, button.tag);
    }];
}

@end
