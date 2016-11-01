//
//  Test.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/1.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "Test.h"
#import "AppDelegate.h"

@interface Test ()

@end

@implementation Test

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [AppDelegate storyBoradAutoLay:self.view];
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
