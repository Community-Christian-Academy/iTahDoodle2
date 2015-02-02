//
//  AppDelegate.m
//  iTahDoodle
//
//  Created by Jay Campbell on 1/30/15.
//  Copyright (c) 2015 CCA. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>


// Helper function to fetch the path to our to-do data stored on disk
NSString *BNRDocPath()
{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            YES);
    return [pathList[0] stringByAppendingPathComponent:@"data.td"];
}


@interface BNRAppDelegate ()
@end
@implementation BNRAppDelegate

#pragma mark - Application delegate callbacks

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Attempt to load an existing to-do dataset from an aray stored to disk.
    NSArray *plist = [NSArray arrayWithContentsOfFile:BNRDocPath()];
    if (plist) {
        // If there was a dataset available, copy it into our instance variable.
        self.tasks = [plist mutableCopy];
    } else {
        // Otherwise, just create an empty one to get us started.
        self.tasks = [NSMutableArray array];
    }
    
    // Is tasks empty?
    if ([self.tasks count] == 0) {
        // Put some strings in it
        [self.tasks addObject:@"Walk the dogs"];
        [self.tasks addObject:@"Feed the hogs"];
        [self.tasks addObject:@"Chop the logs"];
    }
    
    // Create and configure the UIWindow instance
    // A CGRect is a struct with an origin (x,y) and a size (width,height)
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    UIWindow *theWindow = [[UIWindow alloc] initWithFrame:windowFrame];
    self.window = theWindow;
    // Define the frame rectangles of the three UI elements
    // CGRectMake() creates a CGRect from (x, y, width, height)
    CGRect tableFrame = CGRectMake(0, 80, 320, windowFrame.size.height - 100);
    CGRect fieldFrame = CGRectMake(20, 40, 200, 31);
    CGRect buttonFrame = CGRectMake(228, 40, 72, 31);
    // Create and configure the table view
    self.taskTable = [[UITableView alloc] initWithFrame:tableFrame
                                                  style:UITableViewStylePlain];
    self.taskTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    // Make this object the table view's dataSource
    self.taskTable.dataSource = self;
    // Tell the table view which class to instantiate whenever it
    // needs to create a new cell. This will come in handy if we ever
    // want to have different kinds of cells in our table.
    [self.taskTable registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"Cell"];
    
    
    // Create and configure the text field where new tasks will be typed
    self.taskField = [[UITextField alloc] initWithFrame:fieldFrame];
    self.taskField.borderStyle = UITextBorderStyleRoundedRect;
    self.taskField.placeholder = @"Type a task, tap Insert";
    // Create and configure a rounded rect Insert button
    self.insertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.insertButton.frame = buttonFrame;
    // Buttons behave using a target/action callback
    // Configure the Insert button's action to call this object's -addTask: method
    [self.insertButton addTarget:self
                          action:@selector(addTask:)
                forControlEvents:UIControlEventTouchUpInside];
    // Give the button a title
    [self.insertButton setTitle:@"Insert"
                       forState:UIControlStateNormal];
    // Add our three UI elements to the window
    [self.window addSubview:self.taskTable];
    [self.window addSubview:self.taskField];
    [self.window addSubview:self.insertButton];
    // Finalize the window and put it on the screen
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - Table View management
- (NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    // Because this table view only has one section,
    // the number of rows in it is equal to the number
    // of items in our tasks array
    return [self.tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // To improve performance, we reconfigure cells in memory
    // that have scrolled off the screen and hand them back
    // with new contents instead of always creating new cells.
    // We ask the table view to check for a reusable cell and,
    // if none are available, to create one for us to configure.
    UITableViewCell *c = [self.taskTable dequeueReusableCellWithIdentifier:@"Cell"];
    // Then we (re)configure the cell based on the model object,
    // in this case our todoItems array
    NSString *item = self.tasks[indexPath.row];
    c.textLabel.text = item;
    // and hand back to the table view the properly configured cell
    return c;
}

#pragma mark - Actions
- (void)addTask:(id)sender
{
    // Get the to-do item
    NSString *txt = [self.taskField text];
    // Quit here if taskField is empty
    if ([txt length] == 0) {
        return; }
    // Add it to our working array
    [self.tasks addObject:txt];
    // Refresh the table so that the new item shows up
    [self.taskTable reloadData];
    // And clear out the text field
    [self.taskField setText:@""];
    // Dismiss the keyboard
    [self.taskField resignFirstResponder];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Save our tasks array to disk
    [self.tasks writeToFile:BNRDocPath() atomically:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
