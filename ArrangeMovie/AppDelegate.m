//
//  AppDelegate.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/8.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "AppDelegate.h"
#import "EMINavigationController.h"
#import "UIColor+Hex.h"
#import "UIImage+SCUtil.h"
#import "ManagerIndexViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    [self.window setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"all_bg"]]];
//    self.window.layer.contents = (__bridge id _Nullable)(([UIImage imageNamed:@"all_bg"].CGImage));
    self.window.backgroundColor = [UIColor clearColor];
//
//    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
//     UIStoryboard *me = [UIStoryboard storyboardWithName:@"me" bundle:nil];
//     MeViewController *viewController = [me instantiateViewControllerWithIdentifier:@"me"];
//     EMINavigationController *nav = [[EMINavigationController alloc] initWithRootViewController:viewController];
    
    EMINavigationController *nav;
    
    NSString *isFirstUse = [OperateNSUserDefault readUserDefaultWithKey:@"isFirstUse"];
    
    if ([isFirstUse isEqualToString:@"0"]) {
        //不是第一次登录，首页为登录页
        //CK--LoginNav为根视图
        
        UIStoryboard *login = [UIStoryboard storyboardWithName:@"login" bundle:nil];
        nav = [login instantiateViewControllerWithIdentifier:@"loginnav"];
    }else{
        //欢迎页为根视图
        UIStoryboard *launch = [UIStoryboard storyboardWithName:@"launch" bundle:nil];
        nav = [launch instantiateViewControllerWithIdentifier:@"launchnav"];
    }
//     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"manager" bundle:nil];
//     ManagerIndexViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"manager"];
//     EMINavigationController *nav = [[EMINavigationController alloc] initWithRootViewController:viewController];
    
    
    
    UIImage *image = [UIImage imageNamed:@"navigation"];
    CGSize titleSize = nav.navigationBar.bounds.size;
    titleSize.height = titleSize.height+20;
    image = [self scaleToSize:image size:titleSize];
    [[UINavigationBar appearance] setBackgroundImage:image
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
        
    [self.window setRootViewController:nav];
    
    return YES;
}

//图片缩放
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
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
