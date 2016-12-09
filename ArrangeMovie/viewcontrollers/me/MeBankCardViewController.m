//
//  MeBankCardViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/11.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeBankCardViewController.h"
#import "MeBankCardTableViewCell.h"
#import "MeBankAddTableViewCell.h"
#import "BankCard.h"
#import "MBProgressHUD.h"
#import "UIImage+GIF.h"
#import "GetBanksWebInterface.h"
#import "SCHttpOperation.h"
#import "AMAlertView.h"
#import "CKAlertViewController.h"
#import "SetDefaultBankWebInterface.h"
#import "MeNewCardViewController.h"



@interface MeBankCardViewController()<UITableViewDelegate,UITableViewDataSource>{
    CKAlertViewController *ckAlertVC;
}

@property (nonatomic,strong) NSArray <BankCard *> *array;

@property (nonatomic,strong) BankCard *selectedbankcard;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) MBProgressHUD *HUD;
@end

@implementation MeBankCardViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"我的银行卡";
    self.view.backgroundColor = [UIColor whiteColor];
    
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.array = [[NSArray alloc] init];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0.1)];
    
    [self fetchData];
}

//请求网络数据
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
    
    //请求到数据
    __unsafe_unretained typeof(self) weakself = self;
    GetBanksWebInterface *getbanksInterface = [[GetBanksWebInterface alloc] init];
    NSDictionary *param = [getbanksInterface inboxObject:@[@(self.user.userid),@(self.user.usertype)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:getbanksInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [getbanksInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            weakself.array = result[1];
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

#pragma mark tableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        return 127.f;
    }
    return 60.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

#pragma mark tableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.array.count;
            break;
        case 1:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section==0){
        MeBankCardTableViewCell *cell = [MeBankCardTableViewCell cellWithTableView:tableView];
        if(row!=0){
            cell.mainView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8" alpha:1];
        }else{
            cell.mainView.backgroundColor = [UIColor colorWithHexString:@"e7e7e7" alpha:1];
        }
        cell.viewController = self;
        [cell setViewValues:self.array[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        MeBankAddTableViewCell *cell = [MeBankAddTableViewCell cellWithTableView:tableView];
        UIView *backview = [[UIView alloc] init];
        backview.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = backview;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section==1&&row==0){
        //添加银行卡
        [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
        [self performSegueWithIdentifier:@"banktoadd" sender:nil];
    }else{
        
        
        if (row != 0) {
            self.selectedbankcard = self.array[indexPath.row];
            
            AMAlertView *amalertview = [[AMAlertView alloc] initWithconsFrame:CGRectMake(43.5*autoSizeScaleX, (667/2-95.5)*autoSizeScaleY, 288*autoSizeScaleX, 191*autoSizeScaleY)];
            [amalertview setTitle:@"设置默认银行卡"];
            UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 288*autoSizeScaleX, 145*autoSizeScaleY)];
            UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            sureBtn.frame = CGRectMake(24*autoSizeScaleX, 77*autoSizeScaleY, 240*autoSizeScaleX, 41*autoSizeScaleY);
            [sureBtn setBackgroundImage:[UIImage imageNamed:@"alert_tongguo"] forState:UIControlStateNormal];
            [sureBtn addTarget:self action:@selector(setDefaultCard:) forControlEvents:UIControlEventTouchUpInside];
            [childView addSubview:sureBtn];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(24*autoSizeScaleX, 0, 240*autoSizeScaleX, 77*autoSizeScaleY)];
            lab.font = [UIFont fontWithName:@"DroidSansFallback" size:17.f*autoSizeScaleY];
            lab.textColor = [UIColor colorWithHexString:@"15151b"];
            lab.text = @"确认是否设置为默认银行卡?";
            lab.textAlignment = NSTextAlignmentCenter;
            [childView addSubview:lab];
            
            [amalertview setChildView:childView];
            ckAlertVC = [[CKAlertViewController alloc] initWithAlertView:amalertview];
            
            [self presentViewController:ckAlertVC animated:NO completion:nil];
        }
        
        
    }
}

- (void)setDefaultCard:(UIButton *)sender{
    __unsafe_unretained typeof (self) weakself = self;
    SetDefaultBankWebInterface *setdefaultcardInterface = [[SetDefaultBankWebInterface alloc] init];
    NSDictionary *param = [setdefaultcardInterface inboxObject:@[@(self.user.userid),@(self.selectedbankcard.bankid),@(self.user.usertype)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:setdefaultcardInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [setdefaultcardInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            [weakself.view makeToast:@"设置默认银行卡成功" duration:2.0 position:CSToastPositionCenter];
            //重新加载页面
            [weakself viewWillAppear:YES];
        }else{
            [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
        }
    } WithErrorCodeBlock:^(id errorCode) {
        [weakself.view makeToast:@"请求错误" duration:2.0 position:CSToastPositionCenter];
    } WithFailureBlock:^{
        [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
    }];
    [ckAlertVC dismissViewControllerAnimated:NO completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"banktoadd"]) {
        MeNewCardViewController *VC = segue.destinationViewController;
        VC.currentAllBankCardCounts = (int)self.array.count;
    }
}
@end
