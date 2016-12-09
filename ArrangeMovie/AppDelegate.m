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
#import "MeViewController.h"
#import "RESideMenu.h"
#import "EMIRootViewController.h"
#import "SCFadeSlideView.h"
#import "LFLUISegmentedControl.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "PFHomeViewController.h"


@interface AppDelegate ()<RESideMenuDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.



    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    
    
    User *appuser = [User mj_objectWithKeyValues:(NSMutableDictionary *)([OperateNSUserDefault readUserDefaultWithKey:@"user"])];
    if (appuser == nil) {
        UIStoryboard *login = [UIStoryboard storyboardWithName:@"login" bundle:nil];
        LoginViewController *loginvc = [login instantiateViewControllerWithIdentifier:@"login"];
        EMINavigationController *loginnav = [[EMINavigationController alloc] initWithRootViewController:loginvc];
        [self.window setRootViewController:loginnav];
    }else{
        if (appuser.usertype == 0) {
            UIStoryboard *pfhome = [UIStoryboard storyboardWithName:@"pfhome" bundle:nil];
            PFHomeViewController *pfhomevc = [pfhome instantiateViewControllerWithIdentifier:@"pfhome"];
            EMINavigationController *pfhomenav = [[EMINavigationController alloc] initWithRootViewController:pfhomevc];
            [self.window setRootViewController:pfhomenav];
        }
        if (appuser.usertype ==1) {
            UIStoryboard *manager = [UIStoryboard storyboardWithName:@"manager" bundle:nil];
            ManagerIndexViewController *managervc = [manager instantiateViewControllerWithIdentifier:@"manager"];
            EMINavigationController *managernav = [[EMINavigationController alloc] initWithRootViewController:managervc];
            [self.window setRootViewController:managernav];
        }
    }
    
    
    
   
    



    
    //微信支付
    //向微信注册wxd930ea5d5a258f4f
    [WXApi registerApp:WX_APP_ID withDescription:@"爱排片积分充值"];
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        
        return YES;
    }else{
        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    
    
    
    
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    
    
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }else{
        //微信
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    
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

        //SCFadeSlideView不进行比例布局
        if (![temp isKindOfClass:[SCFadeSlideView class]]) {
            temp.frame = CGRectMake1(temp.frame.origin.x, temp.frame.origin.y, temp.frame.size.width, temp.frame.size.height);
            if (temp.subviews.count > 0) {
                [AppDelegate storyBoradAutoLay:temp];
            }
        }
        
        


    }
}


//动态改变字体大小
+ (void)storyBoardAutoLabelFont:(UIView *)allView
{
    for (UIView *temp in allView.subviews) {
        
        
        if ([temp isKindOfClass:[LFLUISegmentedControl class]]) {
            return;
        }
        
        
        //label
        if ([temp isKindOfClass:[UILabel class]]) {
            CGFloat fontSize = ((UILabel *)(temp)).font.pointSize;
            NSString *fontName = ((UILabel *)(temp)).font.fontName;
            ((UILabel *)(temp)).font = [UIFont fontWithName:fontName size:fontSize*autoSizeScaleY];
        }
        //UITextField
        if ([temp isKindOfClass:[UITextField class]]) {
            CGFloat fontSize = ((UITextField *)(temp)).font.pointSize;
            NSString *fontName = ((UITextField *)(temp)).font.fontName;
            ((UITextField *)(temp)).font = [UIFont fontWithName:fontName size:fontSize*autoSizeScaleY];
            [((UITextField *)(temp)) setValue:[UIFont fontWithName:fontName size:fontSize*autoSizeScaleY] forKeyPath:@"_placeholderLabel.font"];
        }
        //UITextView
        if ([temp isKindOfClass:[UITextView class]]) {
            CGFloat fontSize = ((UITextView *)(temp)).font.pointSize;
            NSString *fontName = ((UITextView *)(temp)).font.fontName;
            ((UITextView *)(temp)).font = [UIFont fontWithName:fontName size:fontSize*autoSizeScaleY];
        }
        //button
        if ([temp isKindOfClass:[UIButton class]]) {
            CGFloat fontSize = ((UIButton *)(temp)).titleLabel.font.pointSize;
            NSString *fontName = ((UIButton *)(temp)).titleLabel.font.fontName;
            ((UIButton *)(temp)).titleLabel.font = [UIFont fontWithName:fontName size:fontSize*autoSizeScaleY];
        }
        if (temp.subviews.count > 0) {
            [AppDelegate storyBoardAutoLabelFont:temp];
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
