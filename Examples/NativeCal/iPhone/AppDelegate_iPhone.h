/* 
 * Copyright (c) 2010 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

//
//  AppDelegate_iPhone.h
//  NativeCal
//
//  Created by Andrew Shepard on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 *    NativeCalAppDelegate
 *    --------------------
 *
 *  This demo app shows how to use Kal to display events
 *  from EventKit (Apple's native calendar database).
 *
 */

#import "EventKitDataSource.h"


@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate, UITableViewDelegate> {
    UIWindow *window;
	UINavigationController *navController;
	KalViewController *kal;
	id dataSource;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

