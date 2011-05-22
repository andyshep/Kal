//
//  AppDelegate_iPad.h
//  NativeCal
//
//  Created by Andrew Shepard on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventKitDataSource.h"


@interface AppDelegate_iPad : NSObject <UIApplicationDelegate, UITableViewDelegate> {
    UIWindow *window;
	UINavigationController *navController;
	KalViewController *kal;
	id dataSource;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

