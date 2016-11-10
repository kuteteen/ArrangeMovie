//
//  WelcomeBackViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/10.
//  Copyright © 2016年 EMI. All rights reserved.
//  欢迎回来过度页面

#import "WelcomeBackViewController.h"

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
