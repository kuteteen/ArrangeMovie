//
//  CKAlertViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/19.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "CKAlertViewController.h"

@interface CKAlertViewController ()

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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    self.view.backgroundColor = [UIColor clearColor];
    
    
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
