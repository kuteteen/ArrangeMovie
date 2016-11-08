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
    self.view.layer.contents = (__bridge id _Nullable)(([UIImage imageNamed:@"all_bg"].CGImage));
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(disableRESideMenu)
//                                                 name:@"disableRESideMenu"
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(enableRESideMenu)
//                                                 name:@"enableRESideMenu"
//                                               object:nil];
}

//- (void)enableRESideMenu {
//    self.panGestureEnabled = YES;
//}
//
//- (void)disableRESideMenu {
//    self.panGestureEnabled = NO;
//}

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
