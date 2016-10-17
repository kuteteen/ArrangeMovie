//
//  PFHomeViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "PFHomeViewController.h"

@interface PFHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initView{
    
    //rightNavBtn  &&  leftNavBtn
    
    UIBarButtonItem *rightNavBtn = [UIBarButtonItem itemWithImageName:@"film_index_add" highImageName:@"film_index_add" target:self action:@selector(rightNavBtnClicked:)];
    UIBarButtonItem *leftNavBtn = [UIBarButtonItem itemWithImageName:@"film_index_my" highImageName:@"film_index_my" target:self action:@selector(leftNavBtnClicked:)];
    self.navigationController.navigationItem.rightBarButtonItem = rightNavBtn;
    self.navigationController.navigationItem.leftBarButtonItem = leftNavBtn;
    //加载头像
    [self.headImgView setShadowWithType:EMIShadowPathCircle shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.5 shadowRadius:5 image:@"miller" placeholder:@"miller"];
    //片方姓名
    self.nameLab.text = @"王小二";
    
    //tabelview尾部视图
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//无分割线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

//新增拍片任务
- (void)rightNavBtnClicked:(UIBarButtonItem *)sender{

}
//我的资料
- (void)leftNavBtnClicked:(UIBarButtonItem *)sender{
    
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//}
//
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//}
//
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 106;
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
