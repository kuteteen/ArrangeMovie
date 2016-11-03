//
//  CKAlertViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/19.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "CKAlertViewController.h"
#import "FXBlurView.h"


@interface CKAlertViewController ()
@property(nonatomic,strong)FXBlurView *darkView;
@end

@implementation CKAlertViewController


- (instancetype)initWithAlertView:(UIView *)alertView{
    self = [super init];
    if (self) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView:)];
        UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, screenWidth, screenHeight+64)];
        darkView.backgroundColor = [UIColor blackColor];
        darkView.alpha = 0.7;
        [self.view addSubview:darkView];
        [darkView addGestureRecognizer:gesture];
        [self.view addSubview:alertView];
        
        
        //初始化一个模态视图以备使用
        self.darkView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, -64, screenWidth, screenHeight+64)];
        self.darkView.tintColor = [UIColor blackColor];
        self.darkView.blurEnabled = YES;
        self.darkView.blurRadius = 5.6;
        self.darkView.dynamic = YES;
        self.darkView.iterations = 2;
        self.darkView.updateInterval =2.0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    self.view.backgroundColor = [UIColor clearColor];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIViewController *VC = self.presentingViewController;
    //添加毛玻璃效果
    [VC.view addSubview:self.darkView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIViewController *VC = self.presentingViewController;
    if (self.darkView != nil) {
        //判断是否是子势图
        if ([self.darkView isDescendantOfView:VC.view]) {
            [self.darkView removeFromSuperview];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//
- (void)disMissView:(UITapGestureRecognizer *)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"%@",@"dismiss");
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
