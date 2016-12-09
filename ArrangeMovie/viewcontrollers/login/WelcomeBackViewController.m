//
//  WelcomeBackViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/10.
//  Copyright © 2016年 EMI. All rights reserved.
//  欢迎回来过度页面

#import "WelcomeBackViewController.h"
#import "AppDelegate.h"
#import "PFHomeViewController.h"
#import "EMINavigationController.h"
#import "EMIRootViewController.h"
#import "LoginSuccessViewController.h"
#import "LoginWebInterface.h"
#import "SCHttpOperation.h"
#import "OperateNSUserDefault.h"
#import "ManagerIndexViewController.h"

@interface WelcomeBackViewController ()<UIGestureRecognizerDelegate>


@end

@implementation WelcomeBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    //禁止返回
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    
    //按比例布局
    [AppDelegate storyBoradAutoLay:self.view];
    //字体大小
    [AppDelegate storyBoardAutoLabelFont:self.view];

    
    
    //使线程睡眠4秒，页面跳转
    double delayInSeconds = 4.0;
    __block WelcomeBackViewController* bself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
            
            if (bself.user.usertype == 0) {
                UIStoryboard *pfhome = [UIStoryboard storyboardWithName:@"pfhome" bundle:nil];
                PFHomeViewController *viewController = [pfhome instantiateViewControllerWithIdentifier:@"pfhome"];
                EMINavigationController *nav = [[EMINavigationController alloc] initWithRootViewController:viewController];
                
                [bself presentViewController:nav animated:YES completion:nil];
            }
            if (bself.user.usertype == 1) {
                UIStoryboard *manager = [UIStoryboard storyboardWithName:@"manager" bundle:nil];
                ManagerIndexViewController *managerIndexVC = [manager instantiateViewControllerWithIdentifier:@"manager"];
                EMINavigationController *managerNav = [[EMINavigationController alloc] initWithRootViewController:managerIndexVC];
                [bself presentViewController:managerNav animated:YES completion:nil];
            }
        });
        
        
        
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"tologinsuccess"]) {
//        LoginSuccessViewController *losVC = segue.destinationViewController;

    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return NO;
}

@end
