//
//  LaunchViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/19.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "LaunchViewController.h"
#import "UIColor+Hex.h"
#import "EMINavigationController.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setView{
    
    //
    self.imageArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"all_bg"],[UIImage imageNamed:@"all_bg"],[UIImage imageNamed:@"all_bg"],[UIImage imageNamed:@"all_bg"], nil];
    
    
    CGFloat x = 0;
    for (int i = 0 ; i < self.imageArray.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, screenWidth, screenHeight+64)];
        imgView.image = self.imageArray[i];
        x = x + screenWidth;
        [self.containView addSubview:imgView];
    }
    
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((screenWidth-100)/2,screenHeight-40,100,20)];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 4;
    [self.pageControl setPageIndicatorTintColor:[UIColor colorWithHexString:@"#D9D8D4"]];
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithHexString:@"#0000FF"]];
    
    [self.view addSubview:self.pageControl];
    
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth-80)/2,screenHeight-80,80,30)];
    [self.btn setTitle:@"立即进入" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(toLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.btn.hidden = YES;
    
    [self.view addSubview:self.btn];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int idx = round(scrollView.contentOffset.x/screenWidth);
    self.pageControl.currentPage = idx;
    
    //最后一页，立即使用按钮
    if (self.pageControl.currentPage == 3) {
        self.btn.hidden = NO;
        
    }else{
        self.btn.hidden = YES;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int idx = round(scrollView.contentOffset.x/screenWidth);
    self.pageControl.currentPage = idx;
    
    //最后一页，立即使用按钮
    if (self.pageControl.currentPage == 3) {
        self.btn.hidden = NO;
        
    }else{
        self.btn.hidden = YES;
    }
}

- (void)toLogin:(UIButton *)sender{
    //是否是第一次使用这个app
    [OperateNSUserDefault addUserDefaultWithKeyAndValue:@"isFirstUse" value:@"0"];
    
    
    UIStoryboard *login = [UIStoryboard storyboardWithName:@"login" bundle:nil];
    EMINavigationController *nav = [login instantiateViewControllerWithIdentifier:@"loginnav"];
    [self presentViewController:nav animated:YES completion:nil];
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
