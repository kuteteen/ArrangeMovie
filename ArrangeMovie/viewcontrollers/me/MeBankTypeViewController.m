//
//  MeBankTypeViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/12/1.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeBankTypeViewController.h"
#import "UIImage+GIF.h"
#import "MBProgressHUD.h"
#import "GetBankTypeListWebInterface.h"
#import "SCHttpOperation.h"
#import "MeBankTypeTableViewCell.h"

@interface MeBankTypeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSArray *dataArray;

@property (strong,nonatomic) MBProgressHUD *HUD;
@end

@implementation MeBankTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择银行";
    
    self.dataArray = [[NSArray alloc] init];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)fetchData{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage sd_animatedGIFNamed:@"loading_120"]];
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.2];
    self.HUD.bezelView.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:0.8];
    //        HUD.bezelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_bj"]];
    //        HUD.bezelView.tintColor = [UIColor clearColor];
    
    self.HUD.bezelView.layer.cornerRadius = 16;
    self.HUD.mode = MBProgressHUDModeCustomView;
    //        HUD.mode = MBProgressHUDModeIndeterminate;
    self.HUD.customView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    self.HUD.customView = imageView;
    self.HUD.margin = 5;
    NSLog(@"HUD的margin:%f",self.HUD.margin);
    //    HUD.delegate = self;
    self.HUD.square = YES;
    [self.HUD showAnimated:YES];
    
    //请求到数据之后才initView
    __unsafe_unretained typeof(self) weakself = self;
    GetBankTypeListWebInterface *banktypeInterface = [[GetBankTypeListWebInterface alloc] init];
    NSDictionary *param = [banktypeInterface inboxObject:@[@(self.user.userid),@(self.user.usertype)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:banktypeInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [banktypeInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            weakself.dataArray = result[1];
            [weakself.tableView reloadData];
            [weakself.HUD hideAnimated:YES];
        }else{
            [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
            [weakself.HUD hideAnimated:YES];
        }
    } WithErrorCodeBlock:^(id errorCode) {
        [weakself.view makeToast:@"请求出错" duration:2.0 position:CSToastPositionCenter];
        [weakself.HUD hideAnimated:YES];
    } WithFailureBlock:^{
        [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
        [weakself.HUD hideAnimated:YES];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeBankTypeTableViewCell *cell = [MeBankTypeTableViewCell cellWithTableView:tableView];
    [cell setViewValues:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MeNewCardViewController *VC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    VC.bankTypeDic = self.dataArray[indexPath.row];
    [self.navigationController popToViewController:VC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
