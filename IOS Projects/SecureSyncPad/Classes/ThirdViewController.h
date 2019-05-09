//
//  ThirdViewController.h
//  SecureSync
//
//  Created by Petko Yanakiev on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface ThirdViewController : UIViewController<SubstitutableDetailViewController> {
    
    UINavigationBar *navigationBar;
    UIButton *loadfiles;
    UIButton *clearCashe;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property(nonatomic,retain) IBOutlet UIButton *loadFiles;
@property(nonatomic,retain) IBOutlet UIButton *clearCashe;
@end
