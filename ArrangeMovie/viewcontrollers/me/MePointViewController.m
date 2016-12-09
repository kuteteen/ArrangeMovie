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
#import "BEMCheckBox.h"
#import "UIImage+GIF.h"
#import "MBProgressHUD.h"
#import "UIImageView+Webcache.h"
#import "WXApiRequestHandler.h"
#import "UILabel+StringFrame.h"
#import "PointsDetailWebInterface.h"
#import "SCHttpOperation.h"
#import "GetDefaultBankWebInterface.h"
#import "BankCard.h"
#import "PointApplyWebInterface.h"
#import "OperateNSUserDefault.h"
#import "AlipayRequestHandler.h"


#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface MePointViewController()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BEMCheckBoxDelegate> {
    CKAlertViewController *filterVC;//筛选查询条件VC
    NSInteger filter;// 0,全部 1,充值 2,提现 3,消费
    
    CKAlertViewController *withdrawVC;//提现VC
    CKAlertViewController *chargeVC;//充值VC
    CKAlertViewController *getbackVC;//提现说明VC
    
    //充值金额
    UITextField *cztextField;
    //提现金额
    UITextField *txtextField;
    
    BEMCheckBox *aliPay;
    
    BEMCheckBox *wxPay;
    
    int paytype;//支付类型，1为支付宝，2为微信，0为未选择
    
    //默认银行卡
    BankCard *defaultbankcard;
    
    NSString *newPoints;//更改之后的积分
}

@property (nonatomic, strong) NSArray <OptDetail *> *alldataArray;
@property (nonatomic, strong) NSArray <OptDetail *> *dataArray;

//@property (weak, nonatomic) IBOutlet UIView *headBackView;
//@property (weak, nonatomic) IBOutlet EMIShadowImageView *headImageView;
//@property (weak, nonatomic) IBOutlet EMIPointButton *depositBtn;
//@property (weak, nonatomic) IBOutlet EMIPointButton *getBackbtn;
@property (strong, nonatomic) UITableView *tableView;


@property (strong, nonatomic) UIView *head;
@property (strong, nonatomic) UIImageView *topView;

@property (strong, nonatomic) UIImageView *headImgView;
@property (strong, nonatomic) UILabel *pointlabel;
@property (strong, nonatomic) UIButton *chargeBtn;//充值积分按钮
@property (strong, nonatomic) UIButton *getBackbtn;//积分提现按钮
@property (strong,nonatomic) MBProgressHUD *HUD;


@property (strong,nonatomic) NSString *sectionTitle;
@end

@implementation MePointViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的积分";
    self.alldataArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.sectionTitle = @"全部";
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.bounces = YES;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.tableView.separatorColor = [UIColor colorWithHexString:@"F3F3F3"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.tableFooterView = [[UIView alloc] init];
    
    
    [self addTableHeadView];
    
    self.tableView.tableHeaderView = self.head;
    
    [self.tableView sendSubviewToBack:self.tableView.tableHeaderView];
    
    [self.view addSubview:self.tableView];
    
    //        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80 , 80)];
    

}

-(void)addTableHeadView {
    //head背景
    self.head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64+275*autoSizeScaleY)];
    self.topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64+275*autoSizeScaleY)];
    self.topView.image = [UIImage imageNamed:@"pfhome_topbg"];
    self.topView.contentMode = UIViewContentModeScaleAspectFill;
    self.topView.clipsToBounds = YES;
    self.topView.userInteractionEnabled = YES;
    
    //头像
    self.headImgView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-118*autoSizeScaleY)/2,64+15*autoSizeScaleY,118*autoSizeScaleY,118*autoSizeScaleY)];
    self.headImgView.layer.masksToBounds =YES;
    self.headImgView.layer.cornerRadius = 118*autoSizeScaleY/2;
    self.headImgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    
    [self setHead];
    [self.topView addSubview:self.headImgView];
    
    //
    self.pointlabel = [[UILabel alloc] initWithFrame:CGRectMake(15*autoSizeScaleX, 64+(15+118+20)*autoSizeScaleY, 345*autoSizeScaleY, 16*autoSizeScaleY)];
    self.pointlabel.textAlignment = NSTextAlignmentCenter;
    self.pointlabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:15.0*autoSizeScaleY];
    [self setUserPoints:[NSString stringWithFormat:@"%.0f",self.user.userpoints]];//设置可用积分
    newPoints = [NSString stringWithFormat:@"%.0f",self.user.userpoints];
    self.pointlabel.textColor = [UIColor colorWithHexString:@"162271"];
//    self.pointlabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.pointlabel];
    
    self.chargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(32*autoSizeScaleX, 64+(15+118+20+14+25)*autoSizeScaleY, 310*autoSizeScaleX/2, 60*autoSizeScaleY)];
    [self.chargeBtn setBackgroundImage:[UIImage imageNamed:@"integral_btn_left"] forState:UIControlStateNormal];
    if(self.user.usertype==0){
        [self.chargeBtn setTitle:@"积分充值" forState:UIControlStateNormal];
        [self.chargeBtn addTarget:self action:@selector(toCharge:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.chargeBtn setTitle:@"积分提现" forState:UIControlStateNormal];
        [self.chargeBtn addTarget:self action:@selector(toWithdraw:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.topView addSubview:self.chargeBtn];
    
    self.getBackbtn = [[UIButton alloc] initWithFrame:CGRectMake(32*autoSizeScaleX+310*autoSizeScaleX/2+1, 64+(15+118+20+14+25)*autoSizeScaleY, 310*autoSizeScaleX/2, 60*autoSizeScaleY)];
    [self.getBackbtn setBackgroundImage:[UIImage imageNamed:@"integral_btn_right"] forState:UIControlStateNormal];
    
    if(self.user.usertype==0){
        [self.getBackbtn setTitle:@"积分提现" forState:UIControlStateNormal];
        [self.getBackbtn addTarget:self action:@selector(toWithdraw:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.getBackbtn setTitle:@"提现说明" forState:UIControlStateNormal];
        [self.getBackbtn addTarget:self action:@selector(withdraw:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.topView addSubview:self.getBackbtn];
    
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 64+274*autoSizeScaleY, 345*autoSizeScaleX, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"162271"];
    lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:lineView];
    
    [self.head addSubview:self.topView];
    
    [self fetchData];
    
    //获取默认银行卡
    [self fetchDefaultBankCard];
}

//设置可用积分
- (void)setUserPoints:(NSString *)userPoints{
    self.pointlabel.text = [NSString stringWithFormat:@"可用积分：%@",self.user.userpoints == 0.00?@"0":userPoints];
}


- (void)setHead{
    
    if (self.headimg == nil) {
        [self.headImgView setImage:defaultheadimage];
    }else{
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.headimg] placeholderImage:defaultheadimage];
    }
    
}


//请求数据
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
    
    //请求数据
    __unsafe_unretained typeof(self) weakself = self;
    PointsDetailWebInterface *pointsdetailInterface = [[PointsDetailWebInterface alloc] init];
    NSDictionary *param = [pointsdetailInterface inboxObject:@[@(self.user.userid),@(self.user.usertype)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:pointsdetailInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [pointsdetailInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            weakself.alldataArray = result[1];
            weakself.dataArray = weakself.alldataArray;
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

- (void)fetchDefaultBankCard{
    //请求数据
    __unsafe_unretained typeof(self) weakself = self;
    GetDefaultBankWebInterface *getdefaultInterface = [[GetDefaultBankWebInterface alloc] init];
    NSDictionary *param = [getdefaultInterface inboxObject:@[@(self.user.userid),@(self.user.usertype)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:getdefaultInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [getdefaultInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            defaultbankcard = result[1];
        }else{
            [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
        }
    } WithErrorCodeBlock:^(id errorCode) {
//        [weakself.view makeToast:@"请求出错" duration:2.0 position:CSToastPositionCenter];
    } WithFailureBlock:^{
//        [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
    }];
}


#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 61.f;
}
#pragma mark - tableView datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MePointRecordTableViewCell *cell = [MePointRecordTableViewCell cellWithTableView:tableView];
    [cell setViewValues:self.dataArray[indexPath.row]];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 54*autoSizeScaleY)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 32*autoSizeScaleY, 200*autoSizeScaleX, 18*autoSizeScaleY)];
    titleLabel.textColor = [UIColor colorWithHexString:@"404043"];
    [titleLabel setFont:[UIFont fontWithName:@"Droid Sans" size:18.f*autoSizeScaleY]];
    titleLabel.text = [NSString  stringWithFormat:@"积分明细(%@)",self.sectionTitle];
    [view addSubview:titleLabel];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(Width-(18+15)*autoSizeScaleX, 32*autoSizeScaleY, 18*autoSizeScaleX, 18*autoSizeScaleY)];
    [btn setImage:[UIImage imageNamed:@"integral_screen"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(filter:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    UIView *separtorView = [[UIView alloc] initWithFrame:CGRectMake(0, 60*autoSizeScaleY, Width, 1)];
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
//        [allBtn setHighlighted:YES];
        [allBtn addTarget:self action:@selector(filterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:allBtn];
        
        if (self.user.usertype == 0) {
            EMIFilterButton *chargeBtn = [[EMIFilterButton alloc] initWithFrame:CGRectMake(17+allBtn.frame.size.width+21, 21, (Width-90-34-21)/2, 35)];
            [chargeBtn setTitle:@"充值" forState:UIControlStateNormal];
            [chargeBtn addTarget:self action:@selector(filterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:chargeBtn];
        }else{
            EMIFilterButton *chargeBtn = [[EMIFilterButton alloc] initWithFrame:CGRectMake(17+allBtn.frame.size.width+21, 21, (Width-90-34-21)/2, 35)];
            [chargeBtn setTitle:@"提现" forState:UIControlStateNormal];
            [chargeBtn addTarget:self action:@selector(filterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:chargeBtn];
        }
        if (self.user.usertype == 0) {
            EMIFilterButton *withdrawBtn = [[EMIFilterButton alloc] initWithFrame:CGRectMake(17, 70, (Width-90-34-21)/2, 35)];
            [withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
            [withdrawBtn addTarget:self action:@selector(filterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:withdrawBtn];
        }else{
            EMIFilterButton *withdrawBtn = [[EMIFilterButton alloc] initWithFrame:CGRectMake(17, 70, (Width-90-34-21)/2, 35)];
            [withdrawBtn setTitle:@"收益" forState:UIControlStateNormal];
            [withdrawBtn addTarget:self action:@selector(filterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:withdrawBtn];
        }
        if (self.user.usertype == 0) {
            EMIFilterButton *consumeBtn = [[EMIFilterButton alloc] initWithFrame:CGRectMake(17+allBtn.frame.size.width+21, 70, (Width-90-34-21)/2, 35)];
            [consumeBtn setTitle:@"消费" forState:UIControlStateNormal];
            [consumeBtn addTarget:self action:@selector(filterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:consumeBtn];
        }
        
        
        
        
        filterVC = [[CKAlertViewController alloc] initWithAlertView:view];
    }
    [self presentViewController:filterVC animated:NO completion:nil];
}


- (void)filterBtnClicked:(EMIFilterButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"全部"]) {
        self.dataArray = self.alldataArray;
        self.sectionTitle = @"全部";
        [self.tableView reloadData];
    }
    if ([sender.titleLabel.text isEqualToString:@"充值"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"opttype=1"];
        self.dataArray = [self.alldataArray filteredArrayUsingPredicate:predicate];
        self.sectionTitle = @"充值";
        [self.tableView reloadData];
    }
    if ([sender.titleLabel.text isEqualToString:@"提现"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"opttype=2"];
        self.dataArray = [self.alldataArray filteredArrayUsingPredicate:predicate];
        self.sectionTitle = @"提现";
        [self.tableView reloadData];
    }
    if ([sender.titleLabel.text isEqualToString:@"消费"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"opttype=3"];
        self.dataArray = [self.alldataArray filteredArrayUsingPredicate:predicate];
        self.sectionTitle = @"消费";
        [self.tableView reloadData];
    }
    if ([sender.titleLabel.text isEqualToString:@"收益"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"opttype=4"];
        self.dataArray = [self.alldataArray filteredArrayUsingPredicate:predicate];
        self.sectionTitle = @"收益";
        [self.tableView reloadData];
    }
    
    if(filterVC){
        [filterVC dismissViewControllerAnimated:NO completion:nil];
    }
}

//充值
-(void)toCharge:(id)sender {
    if(!chargeVC){
        AMAlertView *amalertview = [[AMAlertView alloc] initWithconsFrame:CGRectMake((Width-288*autoSizeScaleX)/2, (Height-247*autoSizeScaleY)/2, 288*autoSizeScaleX, 247*autoSizeScaleY)];
        [amalertview setTitle:@"积分充值"];
        
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  288*autoSizeScaleX, (247-47)*autoSizeScaleY)];
        cztextField = [[UITextField alloc] initWithFrame:CGRectMake(10*autoSizeScaleX, 20*autoSizeScaleY, 268*autoSizeScaleX, 40*autoSizeScaleY)];
        CGRect tfframe = cztextField.frame;
        tfframe.size.width = 7;
        UIView *leftView = [[UIView alloc] initWithFrame:tfframe];
        cztextField.leftViewMode = UITextFieldViewModeAlways;
        cztextField.leftView = leftView;
        cztextField.delegate = self;
        cztextField.keyboardType = UIKeyboardTypeNumberPad;
        cztextField.placeholder = @"请填写充值金额(￥)";
        [cztextField setValue:[UIColor colorWithHexString:@"15151b"] forKeyPath:@"_placeholderLabel.textColor"];
        [cztextField setValue:[UIFont fontWithName:@"Droid Sans Fallback" size:17*autoSizeScaleX] forKeyPath:@"_placeholderLabel.font"];
        cztextField.font = [UIFont fontWithName:@"Droid Sans Fallback" size:17*autoSizeScaleX];
        cztextField.layer.cornerRadius = 4*autoSizeScaleY;
        cztextField.layer.masksToBounds = YES;
        cztextField.layer.borderColor = [[UIColor colorWithHexString:@"bbbbbd"] CGColor];
        cztextField.layer.borderWidth = 0.5*autoSizeScaleY;
        [childView addSubview:cztextField];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10*autoSizeScaleX, 86*autoSizeScaleY, 60*autoSizeScaleX, 15*autoSizeScaleY)];
        label.text = @"付款方式";
        label.textColor = [UIColor colorWithHexString:@"45454a"];
        label.font = [UIFont fontWithName:@"Droid Sans Fallback" size:15*autoSizeScaleX];
        [childView addSubview:label];
        
        //支付宝
        aliPay = [[BEMCheckBox alloc] initWithFrame:CGRectMake(144*autoSizeScaleX, 89*autoSizeScaleY, 11*autoSizeScaleX, 11*autoSizeScaleY)];
        aliPay.onFillColor = [UIColor colorWithHexString:@"162271"];
        aliPay.onCheckColor = [UIColor colorWithHexString:@"162271"];
        aliPay.onTintColor = [UIColor colorWithHexString:@"162271"];
        aliPay.on = YES;
        aliPay.delegate = self;
        aliPay.tag = 1;
        paytype = 1;
        [childView addSubview:aliPay];
        
        UILabel *aliLabel = [[UILabel alloc] initWithFrame:CGRectMake(166*autoSizeScaleX, 86*autoSizeScaleY, 60*autoSizeScaleX, 17*autoSizeScaleY)];
        aliLabel.text = @"支付宝";
        aliLabel.textColor = [UIColor colorWithHexString:@"15151b"];
        aliLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:17.f*autoSizeScaleY];
        [childView addSubview:aliLabel];
        
        //微信
        wxPay = [[BEMCheckBox alloc] initWithFrame:CGRectMake(220*autoSizeScaleX, 89*autoSizeScaleY, 11*autoSizeScaleX, 11*autoSizeScaleY)];
        wxPay.onFillColor = [UIColor colorWithHexString:@"162271"];
        wxPay.onCheckColor = [UIColor colorWithHexString:@"162271"];
        wxPay.onTintColor = [UIColor colorWithHexString:@"162271"];
        wxPay.on = NO;
        wxPay.delegate = self;
        wxPay.tag = 2;
        [childView addSubview:wxPay];
        
        UILabel *wxLabel = [[UILabel alloc] initWithFrame:CGRectMake(242*autoSizeScaleX, 86*autoSizeScaleY, 60*autoSizeScaleX, 17*autoSizeScaleY)];
        wxLabel.text = @"微信";
        wxLabel.textColor = [UIColor colorWithHexString:@"15151b"];
        wxLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:17.f*autoSizeScaleY];
        [childView addSubview:wxLabel];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15*autoSizeScaleX, 134*autoSizeScaleY, 258*autoSizeScaleX, 48.5*autoSizeScaleY)];
//        [btn setBackgroundColor:[UIColor colorWithHexString:@"557cce"]];
//        [btn setTitle:@"确认充值" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btn.layer.masksToBounds = YES;
//        btn.layer.cornerRadius = 4;
        [btn setBackgroundImage:[UIImage imageNamed:@"alert_chongzhi"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeChargeVC:) forControlEvents:UIControlEventTouchUpInside];
        [childView addSubview:btn];
        
        [amalertview setChildView:childView];
        chargeVC = [[CKAlertViewController alloc] initWithAlertView:amalertview];
    }
    [self presentViewController:chargeVC animated:NO completion:nil];
}

- (void)didTapCheckBox:(BEMCheckBox*)checkBox{
    if (checkBox.tag == 1) {
//        aliPay.on = !aliPay.on;
        if (aliPay.on) {
            wxPay.on = NO;
        }
    }
    if (checkBox.tag ==2) {
//        wxPay.on = !wxPay.on;
        if (wxPay.on) {
            aliPay.on = NO;
        }
    }
    
    if (aliPay.on && !wxPay.on) {
        paytype = 1;
    }
    
    if (!aliPay.on && wxPay.on) {
        paytype = 2;
    }
}

-(void)closeChargeVC:(id)sender {
    
    [chargeVC.view makeToast:@"支付尚未开通" duration:2.0 position:CSToastPositionCenter];
    return;
    
    
    
    if (paytype == 0) {
        [chargeVC.view makeToast:@"请选择支付方式" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    if (cztextField.text == nil || [cztextField.text isEqualToString:@""] || [cztextField.text doubleValue] == 0) {
        [chargeVC.view makeToast:@"请填写充值金额" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    if (paytype == 2) {
            //微信支付
        WXApiRequestHandler *wxreq = [[WXApiRequestHandler alloc] init];
        wxreq.wxreturnBlock = ^(NSString *res){
            if( ![@"" isEqual:res] ){
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                
                [alter show];
            }
        } ;
        [wxreq jumpToBizPay:@"132" price:[NSNumber numberWithDouble:[cztextField.text doubleValue]]];
        
    }else{
        //支付宝支付
        AlipayRequestHandler *alireq = [[AlipayRequestHandler alloc] init];
        alireq.alireturnBlock = ^(NSString *res){
            if( ![@"" isEqual:res] ){
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                
                [alter show];
            }
        } ;
        [alireq jumpToBizPay:@"132" price:[NSNumber numberWithDouble:[cztextField.text doubleValue]]];
    }
    

    
    if(chargeVC){
        [chargeVC dismissViewControllerAnimated:NO completion:nil];
    }
}
//提现
-(void)toWithdraw:(id)sender {
    
    if (defaultbankcard == nil) {
        [self.view makeToast:@"请先添加默认银行卡" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    
    if(!withdrawVC){
        AMAlertView *amalertview = [[AMAlertView alloc] initWithconsFrame:CGRectMake(45*autoSizeScaleX, (Height-306)/2, Width-90*autoSizeScaleX, 306*autoSizeScaleY)];
        [amalertview setTitle:@"积分提现"];
        
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width-90*autoSizeScaleX, (306-46)*autoSizeScaleY)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12*autoSizeScaleX, 23*autoSizeScaleY, 60, 15*autoSizeScaleX)];
        label.font = [UIFont fontWithName:@"Droid Sans Fallback" size:15*autoSizeScaleX];
        label.textColor = [UIColor colorWithHexString:@"45454a"];
        label.text = @"银行卡";
        [childView addSubview:label];
        
        //选中
        BEMCheckBox *bankPay = [[BEMCheckBox alloc] initWithFrame:CGRectMake(12*autoSizeScaleX, (23+21+14+6)*autoSizeScaleY, 10, 10)];
        bankPay.onFillColor = [UIColor colorWithHexString:@"162271"];
        bankPay.onCheckColor = [UIColor colorWithHexString:@"162271"];
        bankPay.onTintColor = [UIColor colorWithHexString:@"162271"];
        bankPay.on = YES;
        bankPay.userInteractionEnabled = NO;
        [childView addSubview:bankPay];
        
        UILabel *cardLabel = [[UILabel alloc] initWithFrame:CGRectMake((12+15+12)*autoSizeScaleX, (23+21+14)*autoSizeScaleY, Width-90*autoSizeScaleX-15-(12+12)*autoSizeScaleX, 18*autoSizeScaleY)];
        cardLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:17*autoSizeScaleX];
        cardLabel.textColor = [UIColor colorWithHexString:@"15151b"];
        cardLabel.text = [NSString stringWithFormat:@"%@（%@）",defaultbankcard.bankname,[defaultbankcard.account substringWithRange:NSMakeRange(defaultbankcard.account.length-3, 3)]];
        [childView addSubview:cardLabel];
        
        
        txtextField = [[UITextField alloc] initWithFrame:CGRectMake(10*autoSizeScaleX, (23+21+14+15+28)*autoSizeScaleY, Width-(90+20)*autoSizeScaleX, 40*autoSizeScaleY)];
        CGRect tfframe = txtextField.frame;
        tfframe.size.width = 7;
        UIView *leftView = [[UIView alloc] initWithFrame:tfframe];
        txtextField.leftViewMode = UITextFieldViewModeAlways;
        txtextField.leftView = leftView;
        txtextField.delegate = self;
        txtextField.keyboardType = UIKeyboardTypeNumberPad;
        txtextField.placeholder = @"请填写提现积分";
        [txtextField setValue:[UIColor colorWithHexString:@"15151b"] forKeyPath:@"_placeholderLabel.textColor"];
        [txtextField setValue:[UIFont fontWithName:@"Droid Sans Fallback" size:17*autoSizeScaleX] forKeyPath:@"_placeholderLabel.font"];
        txtextField.font = [UIFont fontWithName:@"Droid Sans Fallback" size:17*autoSizeScaleX];
        txtextField.layer.cornerRadius = 4*autoSizeScaleY;
        txtextField.layer.masksToBounds = YES;
        txtextField.layer.borderColor = [[UIColor colorWithHexString:@"bbbbbd"] CGColor];
        txtextField.layer.borderWidth = 0.5*autoSizeScaleY;
        [childView addSubview:txtextField];
        
        UILabel *sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*autoSizeScaleX, (23+21+14+15+28+13+40)*autoSizeScaleY, (Width-(90+24)*autoSizeScaleX)/2, 15*autoSizeScaleX)];
        sumLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:15*autoSizeScaleX];
        sumLabel.textColor = [UIColor colorWithHexString:@"45454a"];
        sumLabel.text = @"提现金额：";
        [childView addSubview:sumLabel];
        
        UILabel *feeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*autoSizeScaleX+(Width-(90+24)*autoSizeScaleX)/2, (23+21+14+15+28+13+40)*autoSizeScaleY, (Width-(90+24)*autoSizeScaleX)/2, 15*autoSizeScaleX)];
        feeLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:15*autoSizeScaleX];
        feeLabel.textColor = [UIColor colorWithHexString:@"45454a"];
        feeLabel.text = @"手续费：";
        [childView addSubview:feeLabel];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(21*autoSizeScaleX, (23+21+14+15+28+13+40+15+30)*autoSizeScaleY, Width-(90+42)*autoSizeScaleX, 48*autoSizeScaleY)];
        [btn setBackgroundImage:[UIImage imageNamed:@"alert_tixian"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeWithdraw:) forControlEvents:UIControlEventTouchUpInside];
        [childView addSubview:btn];
        
        
        [amalertview setChildView:childView];
        withdrawVC = [[CKAlertViewController alloc] initWithAlertView:amalertview];
    }
    
    [self presentViewController:withdrawVC animated:NO completion:nil];
}
//确定提现
-(void)closeWithdraw:(id)sender {
    
    if ([txtextField.text intValue] > [newPoints intValue]) {
        [withdrawVC.view makeToast:@"积分余额不足" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    if (txtextField.text == nil || [txtextField.text isEqualToString:@""] || [txtextField.text doubleValue] == 0) {
        [withdrawVC.view makeToast:@"请填写提现金额" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    //请求数据
    __unsafe_unretained typeof(self) weakself = self;
    PointApplyWebInterface *pointapplyInterface = [[PointApplyWebInterface alloc] init];
    NSDictionary *param = [pointapplyInterface inboxObject:@[@(self.user.userid),@(self.user.usertype),@([txtextField.text doubleValue]),@(defaultbankcard.bankid)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:pointapplyInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [pointapplyInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
           [weakself.view makeToast:@"提现申请成功" duration:2.0 position:CSToastPositionCenter];
            //更改保存的个人积分
            newPoints = [NSString stringWithFormat:@"%.0f",weakself.user.userpoints-[txtextField.text doubleValue]];
            [weakself setUserPoints:newPoints];
            weakself.user.userpoints = [newPoints doubleValue];
            [OperateNSUserDefault saveUser:weakself.user];
        }else{
            [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
        }
    } WithErrorCodeBlock:^(id errorCode) {
            [weakself.view makeToast:@"请求出错" duration:2.0 position:CSToastPositionCenter];
    } WithFailureBlock:^{
            [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
    }];
    
    [withdrawVC dismissViewControllerAnimated:NO completion:nil];
}

//提现说明
-(void)withdraw:(id)sender {
    if(!getbackVC){
        AMAlertView *amalertview = [[AMAlertView alloc] initWithconsFrame:CGRectMake(25*autoSizeScaleX, 40*autoSizeScaleY, Width-50*autoSizeScaleX, Height-80*autoSizeScaleY)];
        [amalertview setTitle:@"积分提现"];
        
        UIScrollView *childView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Width-50*autoSizeScaleX, Height-80*autoSizeScaleY-46*autoSizeScaleY)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12*autoSizeScaleX, 12*autoSizeScaleY, Width-50*autoSizeScaleX-24*autoSizeScaleX, Height-80*autoSizeScaleY-46*autoSizeScaleY-24*autoSizeScaleY)];
        label.font = [UIFont fontWithName:@"Droid Sans Fallback" size:15*autoSizeScaleY];
        label.numberOfLines = 0;
        label.textColor = [UIColor colorWithHexString:@"a0a0a0"];
        label.text = @"\t凡持影城会员卡在影城集团旗下各公司消费，系统将自动记录你的消费金额并积分，同时我们将定期举办各式各样的积分活动，让你真正享受到您的每一份支持都将获得我们的真情回报。\n\n1、积分规则：凡持影城集团会员卡的用户，均可参加会员积分活动。会员持卡在影城仓储超市有限公司、影城超市有限公司、影城百货有限责任公司和影城电子商务有限公司消费，每消费1元积1分。\n\n2、查分方法：登陆本网站后，进入的“设置”，即可以自助服务中查到自己的积分、积点情况，以及相关明细。\n\n3、积分的使用：会员积分可在网站积分商城兑换相应的礼品、参加网站的会员积分系列活动，也可按照1000积分兑换3个积点的比例转化为积点进行消费。";
        CGSize size = [label boundingRectWithSize:CGSizeMake(Width-50*autoSizeScaleX-24*autoSizeScaleX, 0)];
        label.frame = CGRectMake(12*autoSizeScaleX, 12*autoSizeScaleY, Width-50*autoSizeScaleX-24*autoSizeScaleX, size.height);
        childView.contentSize = CGSizeMake(Width-50*autoSizeScaleX-24*autoSizeScaleX, size.height+20);
        [childView addSubview:label];
        
        
        
        
        [amalertview setChildView:childView];
        getbackVC = [[CKAlertViewController alloc] initWithAlertView:amalertview];
    }
    
    [self presentViewController:getbackVC animated:NO completion:nil];
}

@end
