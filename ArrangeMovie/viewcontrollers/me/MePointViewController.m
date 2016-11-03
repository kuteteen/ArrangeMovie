//
//  MePointViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/11.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MePointViewController.h"
#import "EMIPointButton.h"
#import "MePointRecordTableViewCell.h"
#import "CKAlertViewController.h"
#import "UIImage+SCUtil.h"
#import "EMIFilterButton.h"
#import "AMAlertView.h"


#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface MePointViewController()<UITableViewDelegate,UITableViewDataSource> {
    CKAlertViewController *filterVC;//筛选查询条件VC
    NSInteger filter;// 0,全部 1,充值 2,提现 3,消费
    
    CKAlertViewController *withdrawVC;//提现VC
    CKAlertViewController *chargeVC;//充值VC
    
}

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *array;

@property (weak, nonatomic) IBOutlet UIView *headBackView;
@property (weak, nonatomic) IBOutlet EMIShadowImageView *headImageView;
@property (weak, nonatomic) IBOutlet EMIPointButton *depositBtn;
@property (weak, nonatomic) IBOutlet EMIPointButton *getBackbtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MePointViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的积分";
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"", nil];
    self.array = [[NSArray alloc] initWithObjects:_dataArray, nil];
    
    
    
    self.headBackView.layer.contents = (__bridge id _Nullable)(([UIImage imageNamed:@"head_bg"].CGImage));
    [self.headImageView setShadowWithType:EMIShadowPathCircle shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.5 shadowRadius:10 image:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580" placeholder:@"miller"];
    
    if(self.user.usertype==0){
        //片方
        [self.depositBtn setImage:[UIImage imageNamed:@"integral_recharge"] forState:UIControlStateNormal];
        [self.depositBtn setTitle:@"积分充值" forState:UIControlStateNormal];
        
        [self.getBackbtn setImage:[UIImage imageNamed:@"integral_withdraw_cash"] forState:UIControlStateNormal];
        [self.getBackbtn setTitle:@"积分提现" forState:UIControlStateNormal];
        
        [self.depositBtn addTarget:self action:@selector(toCharge:) forControlEvents:UIControlEventTouchUpInside];
        [self.getBackbtn addTarget:self action:@selector(toWithdraw:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        //院线经理
        [self.depositBtn setImage:[UIImage imageNamed:@"integral_withdraw_cash"] forState:UIControlStateNormal];
        [self.depositBtn setTitle:@"积分提现" forState:UIControlStateNormal];
        
        [self.getBackbtn setImage:[UIImage imageNamed:@"integral_withdraw_instruction"] forState:UIControlStateNormal];
        [self.getBackbtn setTitle:@"提现说明" forState:UIControlStateNormal];
    }
    
    
    
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.tableView.separatorColor = [UIColor colorWithHexString:@"F3F3F3"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.tableFooterView = [[UIView alloc] init];
    
    
    
    
}
#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 54.f;
}
#pragma mark - tableView datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MePointRecordTableViewCell *cell = [MePointRecordTableViewCell cellWithTableView:tableView];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 54)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 80, 10)];
    titleLabel.textColor = [UIColor colorWithHexString:@"404043"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18.f]];
    titleLabel.text = @"积分明细";
    [view addSubview:titleLabel];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(Width-18-15, 25, 18, 18)];
    [btn setImage:[UIImage imageNamed:@"integral_screen"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(filter:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    UIView *separtorView = [[UIView alloc] initWithFrame:CGRectMake(0, 54, Width, 1)];
    separtorView.backgroundColor = [UIColor whiteColor];
    [view addSubview:separtorView];
    
    return view;
}


//弹出筛选积分
-(void)filter:(id)sender {
    if(!filterVC){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(45, (Height-126)/2, (Width-90), 126)];
        view.layer.cornerRadius = 4;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor whiteColor];
        
        EMIFilterButton *allBtn = [[EMIFilterButton alloc] initWithFrame:CGRectMake(17, 21, (Width-90-34-21)/2, 35)];
        [allBtn setTitle:@"全部" forState:UIControlStateNormal];
//        [self setFilterStyle:allBtn];
        [allBtn setHighlighted:YES];
        [view addSubview:allBtn];
        
        EMIFilterButton *chargeBtn = [[EMIFilterButton alloc] initWithFrame:CGRectMake(17+allBtn.frame.size.width+21, 21, (Width-90-34-21)/2, 35)];
        [chargeBtn setTitle:@"充值" forState:UIControlStateNormal];
//        [self setFilterStyle:chargeBtn];
        [view addSubview:chargeBtn];
        
        EMIFilterButton *withdrawBtn = [[EMIFilterButton alloc] initWithFrame:CGRectMake(17, 70, (Width-90-34-21)/2, 35)];
        [withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
        //        [self setFilterStyle:chargeBtn];
        [view addSubview:withdrawBtn];
        
        EMIFilterButton *consumeBtn = [[EMIFilterButton alloc] initWithFrame:CGRectMake(17+allBtn.frame.size.width+21, 70, (Width-90-34-21)/2, 35)];
        [consumeBtn setTitle:@"消费" forState:UIControlStateNormal];
        //        [self setFilterStyle:chargeBtn];
        [view addSubview:consumeBtn];
        
        filterVC = [[CKAlertViewController alloc] initWithAlertView:view];
    }
    [self presentViewController:filterVC animated:NO completion:nil];
}

-(void)toCharge:(id)sender {
    if(!chargeVC){
        AMAlertView *amalertview = [[AMAlertView alloc] initWithFrame:CGRectMake(45, (Height-306)/2, Width-90, 306)];
        [amalertview setTitle:@"积分充值"];
        
        chargeVC = [[CKAlertViewController alloc] initWithAlertView:amalertview];
    }
    [self presentViewController:chargeVC animated:NO completion:nil];
}

@end
