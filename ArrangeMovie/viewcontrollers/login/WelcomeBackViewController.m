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

@interface WelcomeBackViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *backLab;

@end

@implementation WelcomeBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //禁止返回
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    
    //按比例布局
    [AppDelegate storyBoradAutoLay:self.view];
    //字体大小
    [AppDelegate storyBoardAutoLabelFont:self.view];

    
    //欢迎回来 渐变
    [UIView animateWithDuration:3.0 animations:^{
        self.backLab.alpha = 1;
    }];
    //todo此处暂无请求，使线程睡眠5秒，页面跳转
    double delayInSeconds = 3.0;
    __block WelcomeBackViewController* bself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [bself performSegueWithIdentifier:@"tologinsuccess" sender:self];
    });
    
    
    
    //进行网络请求，请求成功跳至登陆成功页面
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"tologinsuccess"]) {
        LoginSuccessViewController *losVC = segue.destinationViewController;
        losVC.tempuserType = self.tempuserType;
    }
}


@end
