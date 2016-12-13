//
//  MeSettingViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/14.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeSettingViewController.h"
#import "MeSettingTableViewCell.h"
#import "MeSettingSignOutTableViewCell.h"
#import "OperateNSUserDefault.h"
#import "LoginViewController.h"
#import "EMINavigationController.h"
#import "SDImageCache.h"

#define width [UIScreen mainScreen].bounds.size.width

@interface MeSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *array;

@end

@implementation MeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.contents = [UIColor whiteColor];
    
    
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
//    self.tableView.separatorColor = [UIColor colorWithHexString:@"F3F3F3"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    
   
}

-(NSArray *)array {
    if (!_array) {
        _array = @[@"意见反馈",@"关于我们",@"清除缓存"];
    }
    return _array;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if(section==0){
        return 68.f;
    }
    return 50.f;
}

//group_header
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section==0){
        return 0.1f;
    }
    return 45.f;
}

//group_footer
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 45)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return self.array.count;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(section==0){
        MeSettingTableViewCell *cell = [MeSettingTableViewCell cellWithTableView:tableView];
        UIView *backview = [[UIView alloc] init];
        backview.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = backview;
        
        NSString *title = self.array[row];
        cell.titleLabel.text = title;
        if(row<2){
            cell.descLabel.hidden = YES;
        }else{
            NSUInteger size = [[SDImageCache sharedImageCache] getSize];
            cell.descLabel.text = size < 1024*1024 ? (size<1024 ? @"0":[NSString stringWithFormat:@"%luK",size/1024]):[NSString stringWithFormat:@"%luM",size/1024/1024];
        }
        return cell;
    }else{
        MeSettingSignOutTableViewCell *cell = [MeSettingSignOutTableViewCell cellWithTableView:tableView];
        UIView *backview = [[UIView alloc] init];
        backview.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = backview;
        cell.backgroundView = backview;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section==0){
        if(row==0){
            [self performSegueWithIdentifier:@"metofeedback" sender:nil];
        }
        if(row==1){
            [self performSegueWithIdentifier:@"metoabout" sender:nil];
        }
        if(row==2){
            //删除缓存数据
            [[SDImageCache sharedImageCache] clearDisk];
            [self.tableView reloadData];
        }
    }
    if(section==1){
        if(row==0){
            //退出登录
            //先把存在NSUseDefault中的一些信息删除
            [OperateNSUserDefault removeUserDefaultWithKey:@"user"];
//            [OperateNSUserDefault removeUserDefaultWithKey:@"isFirstUse"];
            [OperateNSUserDefault removeUserDefaultWithKey:@"password"];
            UIStoryboard *login = [UIStoryboard storyboardWithName:@"login" bundle:nil];
            LoginViewController *loginvc = [login instantiateViewControllerWithIdentifier:@"login"];
            EMINavigationController *loginnav = [[EMINavigationController alloc] initWithRootViewController:loginvc];
            [self presentViewController:loginnav animated:NO completion:nil];
            
        }
    }
    
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
