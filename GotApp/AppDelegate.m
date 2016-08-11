//
//  AppDelegate.m
//  GotApp
//
//  Created by Ola Skierbiszewska on 08.08.2016.
//  Copyright © 2016 Ola Skierbiszewska. All rights reserved.
//

#import "AppDelegate.h"
#import "GtMainViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) UINavigationController *navigationController;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    GtMainViewController *mainViewController = [[GtMainViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
