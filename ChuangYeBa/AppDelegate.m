//
//  AppDelegate.m
//  ChuangYeBa
//
//  Created by Developer on 15/4/2.
//  Copyright (c) 2015年 Su Ziming. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 此为找到plist文件中得版本号所对应的键
    //NSString *key = @"CFBundleShortVersionString";
    NSString *key = @"CFBundleShortVersionString";
    // 从plist中取出版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    // 从沙盒中取出上次存储的版本号
    NSString *saveVersion = [[NSUserDefaults  standardUserDefaults] objectForKey:key];
    if([version isEqualToString:saveVersion]) {
#ifdef STUDENT_VERSION
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStudent" bundle:nil];
#elif TEACHER_VERSION
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainTeacher" bundle:nil];
#endif
        UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        self.window.rootViewController = rootViewController;
        [self.window makeKeyAndVisible];
    } else {
        //application.statusBarHidden = NO;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"WelcomeScreen" bundle:nil];
        UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeScreenViewController"];
        self.window.rootViewController = rootViewController;
        [self.window makeKeyAndVisible];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
