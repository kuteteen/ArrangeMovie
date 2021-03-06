//
//  MeViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/9.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeViewController.h"
#import "MeTableViewCell.h"
#import "UIBarButtonItem+Extension.h"
#import "UIViewController+RESideMenu.h"
#import "RESideMenu.h"
#import "MBProgressHUD.h"
#import "UIImage+GIF.h"
#import "MeProfileViewController.h"
#import "MePointViewController.h"
#import "MeBankCardViewController.h"
#import "MePwdViewController.h"
#import "MeSettingViewController.h"
#import "MeAuthViewController.h"
#import "MeMissionViewController.h"

@interface MeViewController ()<MBProgressHUDDelegate>
@property (nonatomic, strong) NSArray *array;//存放列表item

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back" highImageName:@"back_click" target:self action:@selector(showRootViewontroller:)];
        
    
    if (iPhone4S) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64) style:UITableViewStylePlain];
    }else {
        if(self.user.usertype==0){
            if ((screenHeight - 68 * 7)/2>64) {
                self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (screenHeight - 68 * 7)/2, screenWidth, 68*7) style:UITableViewStylePlain];
                self.tableView.scrollEnabled = NO;
            }else {
                self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64) style:UITableViewStylePlain];
            }
        }else {
            if ((screenHeight - 68 * 6)/2>64) {
                self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (screenHeight - 68 * 6)/2, screenWidth, 68*6) style:UITableViewStylePlain];
                self.tableView.scrollEnabled = NO;
            }else {
                self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64) style:UITableViewStylePlain];
            }
        }
    }
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.tableView.separatorColor = [UIColor colorWithHexString:@"4C6EAB"];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)showRootViewontroller:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSArray *)array {
    if (!_array) {
        if(self.user.usertype==0){
            _array = @[@"我的资料",@"任务历史",@"我的积分",@"我的银行卡",@"修改密码",@"资料审核",@"设置"];
        }else{
            _array = @[@"我的资料",@"我的积分",@"我的银行卡",@"修改密码",@"认证院线经理",@"设置"];
        }
    }
    return _array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.f;
}

#pragma mark - tableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self array].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeTableViewCell *cell = [MeTableViewCell cellWithTableView:tableView];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *backview = [[UIView alloc] init];
    backview.backgroundColor = [UIColor colorWithHexString:@"5473aa" alpha:0.7];
    cell.selectedBackgroundView = backview;
    
    NSString *title = self.array[indexPath.row];
    [cell setValue:title];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.array[indexPath.row];
//    NSLog(@"点击了:%@",title);
    UIStoryboard *me = [UIStoryboard storyboardWithName:@"me" bundle:nil];
    if([title isEqualToString:@"我的资料"]){
        MeProfileViewController *profileVC = [me instantiateViewControllerWithIdentifier:@"meprofile"];
        [self.navigationController pushViewController:profileVC animated:YES];
//        [self performSegueWithIdentifier:@"metoprofile" sender:nil];
    }else if([title isEqualToString:@"我的积分"]){
        MePointViewController *pointVC = [me instantiateViewControllerWithIdentifier:@"mepoint"];
        [self.navigationController pushViewController:pointVC animated:YES];
//        [self performSegueWithIdentifier:@"metopoint" sender:nil];
    }else if([title isEqualToString:@"我的银行卡"]){
        MeBankCardViewController *bankVC = [me instantiateViewControllerWithIdentifier:@"mebank"];
        [self.navigationController pushViewController:bankVC animated:YES];
//        [self performSegueWithIdentifier:@"metobank" sender:nil];
    }else if([title isEqualToString:@"修改密码"]){
        MePwdViewController *pwdVC = [me instantiateViewControllerWithIdentifier:@"mepwd"];
        [self.navigationController pushViewController:pwdVC animated:YES];
//        [self performSegueWithIdentifier:@"metopwd" sender:nil];
    }else if([title isEqualToString:@"设置"]){
        MeSettingViewController *settingVC = [me instantiateViewControllerWithIdentifier:@"mesetting"];
        [self.navigationController pushViewController:settingVC animated:YES];
//        [self performSegueWithIdentifier:@"metosetting" sender:nil];
    }else if([title isEqualToString:@"资料审核"]||[title isEqualToString:@"认证院线经理"]){
        MeAuthViewController *authVC = [me instantiateViewControllerWithIdentifier:@"meauth"];
        [self.navigationController pushViewController:authVC animated:YES];
//        [self performSegueWithIdentifier:@"metoauth" sender:nil];
    }else if([title isEqualToString:@"任务历史"]){
        MeMissionViewController *missionVC = [me instantiateViewControllerWithIdentifier:@"memission"];
        [self.navigationController pushViewController:missionVC animated:YES];
//        [self performSegueWithIdentifier:@"metomission" sender:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
}


-(void)hudWasHidden:(MBProgressHUD *)hud {
    
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
