//
//  AppDelegate_iPhone.m
//  NativeCal
//
//  Created by Andrew Shepard on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPhone.h"

@implementation AppDelegate_iPhone

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	/*
	 *    Kal Initialization
	 *
	 * When the calendar is first displayed to the user, Kal will automatically select today's date.
	 * If your application requires an arbitrary starting date, use -[KalViewController initWithSelectedDate:]
	 * instead of -[KalViewController init].
	 */
	kal = [[KalViewController alloc] init];
	kal.title = @"NativeCal";
	
	/*
	 *    Kal Configuration
	 *
	 */
	kal.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:self action:@selector(showAndSelectToday)] autorelease];
	kal.delegate = self;
	dataSource = [[EventKitDataSource alloc] init];
	kal.dataSource = dataSource;
	
	// Setup the navigation stack and display it.
	navController = [[UINavigationController alloc] initWithRootViewController:kal];
	[window addSubview:navController.view];
	[window makeKeyAndVisible];
	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Kal

// Action handler for the navigation bar's right bar button item.
- (void)showAndSelectToday
{
	[kal showAndSelectDate:[NSDate date]];
}

#pragma mark UITableViewDelegate protocol conformance

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Display a details screen for the selected event/row.
	EKEventViewController *vc = [[[EKEventViewController alloc] init] autorelease];
	vc.event = [dataSource eventAtIndexPath:indexPath];
	vc.allowsEditing = NO;
	[navController pushViewController:vc animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[kal release];
	[dataSource release];
    [window release];
    [super dealloc];
}


@end
