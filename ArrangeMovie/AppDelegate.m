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
#import "LoginViewController.h"
#import "LaunchViewController.h"
#import "Test.h"
#import "MeViewController.h"
#import "RESideMenu.h"
#import "EMIRootViewController.h"
#import "SCFadeSlideView.h"

@interface AppDelegate ()<RESideMenuDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.




    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    
    
    
//    UIStoryboard *login = [UIStoryboard storyboardWithName:@"login" bundle:nil];
//    LoginViewController *loginvc = [login instantiateViewControllerWithIdentifier:@"login"];
//    EMINavigationController *loginnav = [[EMINavigationController alloc] initWithRootViewController:loginvc];
//    [self.window setRootViewController:loginnav];
    
    
    UIStoryboard *manager = [UIStoryboard storyboardWithName:@"manager" bundle:nil];
    ManagerIndexViewController *managerIndexVC = [manager instantiateViewControllerWithIdentifier:@"manager"];
    //假数据 用户
    User *user = [[User alloc] init];
    
    user.name = @"冯小刚";
    user.dn = @"1577470000";
    user.usertype = 0;
    user.sex = 1;
    user.headimg = @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580";
    user.gradename = @"A级影院";
    managerIndexVC.user = user;
    EMINavigationController *managerNav = [[EMINavigationController alloc] initWithRootViewController:managerIndexVC];
    
    
    UIStoryboard *me = [UIStoryboard storyboardWithName:@"me" bundle:nil];
    MeViewController *meVC = [me instantiateViewControllerWithIdentifier:@"me"];
    EMINavigationController *meNav = [[EMINavigationController alloc] initWithRootViewController:meVC];
    
    EMIRootViewController *sideMenuViewController = [[EMIRootViewController alloc] initWithContentViewController:managerNav
                                                                    leftMenuViewController:nil
                                                                   rightMenuViewController:meNav];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"all_bg"];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    
    
    sideMenuViewController.scaleContentView = NO;
    sideMenuViewController.scaleMenuView = NO;
    sideMenuViewController.panGestureEnabled = YES;
    sideMenuViewController.contentViewInPortraitOffsetCenterX = screenWidth;


    UIImage *image = [UIImage imageNamed:@"navigation"];
    CGSize titleSize = managerNav.navigationBar.bounds.size;
    titleSize.height = titleSize.height+20;
    image = [self scaleToSize:image size:titleSize];
    [[UINavigationBar appearance] setBackgroundImage:image
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];

    [self.window setRootViewController:sideMenuViewController];

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

+ (void)storyBoradAutoLay:(UIView *)allView
{
    for (UIView *temp in allView.subviews) {

        //SCFadeSlideView不要对其子view进行布局
        if (![temp isKindOfClass:[SCFadeSlideView class]]) {
            temp.frame = CGRectMake1(temp.frame.origin.x, temp.frame.origin.y, temp.frame.size.width, temp.frame.size.height);
            if (temp.subviews.count > 0) {
                [AppDelegate storyBoradAutoLay:temp];
            }
        }
        
        


    }
}

CG_INLINE CGRect//注意：这里的代码要放在.m文件最下面的位置
CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x * autoSizeScaleX; rect.origin.y = y * autoSizeScaleY;
    rect.size.width = width * autoSizeScaleX; rect.size.height = height * autoSizeScaleY;
    return rect;
}
@end
