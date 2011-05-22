//
//  AppDelegate_iPad.m
//  NativeCal
//
//  Created by Andrew Shepard on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPad.h"

@implementation AppDelegate_iPad

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
	
	CGSize kalViewSize = CGSizeMake(768, 768);
	NSDate * today = [NSDate date];
	
	kal = [[KalLargeViewController alloc] initWithSelectedDate:today withSize:kalViewSize];
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


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}

// Action handler for the navigation bar's right bar button item.
- (void)showAndSelectToday
{
	[kal showAndSelectDate:[NSDate date]];
}

#pragma mark -
#pragma mark Delegates for the KalViewController

-(void) didSelectDate:(KalDate *)selectedDate {
	NSLog(@"didSelectDate: %@", selectedDate);
}

- (void)showPreviousMonth {
	NSLog(@"showPreviousMonth:");
}
- (void)showFollowingMonth {
	NSLog(@"showFollowingMonth:");
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
    [window release];
    [super dealloc];
}


@end
