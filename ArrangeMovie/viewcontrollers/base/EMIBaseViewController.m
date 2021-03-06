//
//  EMIBaseViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/9.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "EMIBaseViewController.h"

@interface EMIBaseViewController ()

@end

@implementation EMIBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.layer.contents = (__bridge id _Nullable)(([UIImage imageNamed:@"all_bg"].CGImage));
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    //user
    self.user = [User mj_objectWithKeyValues:(NSMutableDictionary *)([OperateNSUserDefault readUserDefaultWithKey:@"user"])];
    if (self.user.nickname == nil) {
        self.user.nickname = @"";
    }
    self.headimg = [OperateNSUserDefault readUserDefaultWithKey:@"headimg"];
    
    self.dn = [OperateNSUserDefault readUserDefaultWithKey:@"dn"];
    
    self.isFirstUse = [OperateNSUserDefault readUserDefaultWithKey:@"isFirstUse"];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    //user
    self.user = [User mj_objectWithKeyValues:(NSMutableDictionary *)([OperateNSUserDefault readUserDefaultWithKey:@"user"])];
    
    self.headimg = [OperateNSUserDefault readUserDefaultWithKey:@"headimg"];
    
    self.dn = [OperateNSUserDefault readUserDefaultWithKey:@"dn"];
    
    self.isFirstUse = [OperateNSUserDefault readUserDefaultWithKey:@"isFirstUse"];
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
