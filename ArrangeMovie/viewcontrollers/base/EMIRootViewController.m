//
//  EMIRootViewController.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/7.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "EMIRootViewController.h"

@interface EMIRootViewController ()

@end

@implementation EMIRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizerEnabled = NO;//如果中间的contentViewController是NavigationController，让它继续执行手势的滑动，而不是NavigationController自带的滑动返回(本应用中，刚好就是)
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disableRESideMenu)
                                                 name:@"disableRESideMenu"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enableRESideMenu)
                                                 name:@"enableRESideMenu"
                                               object:nil];
}

- (void)enableRESideMenu {
    self.panGestureEnabled = YES;
}

- (void)disableRESideMenu {
    self.panGestureEnabled = NO;
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
