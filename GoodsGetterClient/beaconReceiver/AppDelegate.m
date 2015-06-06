//
//  AppDelegate.m
//  beaconReceiver
//
//  Created by hanks on 3/25/15.
//  Copyright (c) 2015 com.hanks. All rights reserved.
//

#import "AppDelegate.h"
#import "ItemDetailViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "ViewController.h"
#import "AFNetworkActivityLogger.h"
#import "APIManager.h"
#import "Item.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Register notification
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [application registerUserNotificationSettings:notificationSettings];
    [application registerForRemoteNotifications];
    
#ifdef DEBUG
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
#endif
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    // get goods info from local push
    NSDictionary* dic;
    dic = notification.userInfo;
    NSNumber *major = dic[@"major"];
    NSNumber *minor = dic[@"minor"];
    NSLog(@"major is %@", major);
    NSLog(@"minor is %@", minor);
    
    // set dialog with item and show it
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // sleep for 2 sencond to pop up
            [NSThread sleepForTimeInterval:2];
            
            ItemDetailViewController *detailViewController = [[ItemDetailViewController alloc] initWithNibName:@"ItemDetailViewController" bundle:nil];
            [detailViewController setMajor:major];
            [detailViewController setMinor:minor];
            ViewController* rootViewController = (ViewController*)self.window.rootViewController;
            [rootViewController presentPopupViewController:detailViewController animationType:MJPopupViewAnimationSlideBottomTop];
        });
    });
    
    // substract bager number by 1
    if (application.applicationIconBadgeNumber > 0) {
        application.applicationIconBadgeNumber -= 1;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    if (application.applicationIconBadgeNumber > 0) {
        application.applicationIconBadgeNumber -= 1;
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
