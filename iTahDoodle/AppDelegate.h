//
//  AppDelegate.h
//  iTahDoodle
//
//  Created by Jay Campbell on 1/30/15.
//  Copyright (c) 2015 CCA. All rights reserved.
//


#import "AppDelegate.h"
#import <UIKit/UIKit.h>


// Declare a helper function that we will use to get a path
// to the location on disk where we can save the to-do list
NSString *BNRDocPath(void);


@interface BNRAppDelegate : UIResponder
<UIApplicationDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITableView *taskTable;
@property (strong, nonatomic) UITextField *taskField;
@property (strong, nonatomic) UIButton *insertButton;

@property (strong, nonatomic) NSMutableArray *tasks; - (void)addTask:(id)sender;

@end