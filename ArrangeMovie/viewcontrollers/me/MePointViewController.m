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
//#import "WXApiRequestHandler.h"


#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface MePointViewController()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    CKAlertViewController *filterVC;//筛选查询条件VC
    NSInteger filter;// 0,全部 1,充值 2,提现 3,消费
    
    CKAlertViewController *withdrawVC;//提现VC
    CKAlertViewController *chargeVC;//充值VC
    CKAlertViewController *getbackVC;//提现说明VC
}

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *array;

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

@end

@implementation MePointViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的积分";
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"", nil];
    self.array = [[NSArray alloc] initWithObjects:_dataArray, nil];

//    [self.headImageView setShadowWithType:EMIShadowPathCircle shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.35 shadowRadius:10 image:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580" placeholder:@"miller"];
//    
//    if(self.user.usertype==0){
//        //片方
//        [self.depositBtn setImage:[UIImage imageNamed:@"integral_recharge"] forState:UIControlStateNormal];
//        [self.depositBtn setTitle:@"积分充值" forState:UIControlStateNormal];
//        
//        [self.getBackbtn setImage:[UIImage imageNamed:@"integral_withdraw_cash"] forState:UIControlStateNormal];
//        [self.getBackbtn setTitle:@"积分提现" forState:UIControlStateNormal];
//        
//        [self.depositBtn addTarget:self action:@selector(toCharge:) forControlEvents:UIControlEventTouchUpInside];
//        [self.getBackbtn addTarget:self action:@selector(toWithdraw:) forControlEvents:UIControlEventTouchUpInside];
//    }else{
//        //院线经理
//        [self.depositBtn setImage:[UIImage imageNamed:@"integral_withdraw_cash"] forState:UIControlStateNormal];
//        [self.depositBtn setTitle:@"积分提现" forState:UIControlStateNormal];
//        
//        [self.getBackbtn setImage:[UIImage imageNamed:@"integral_withdraw_instruction"] forState:UIControlStateNormal];
//        [self.getBackbtn setTitle:@"提现说明" forState:UIControlStateNormal];
//    }
    
    
    
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
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage sd_animatedGIFNamed:@"loading_120"]];
    //        NSString  *name = @"loading.gif";
    //
    //        NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:name ofType:nil];
    //
    //        NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    //        imageView.image = [UIImage sd_animatedGIFWithData:imageData];
    //        imageView.image = [UIImage sd_animatedGIFNamed:@"loading"];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.2];
    HUD.bezelView.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:0.8];
    //        HUD.bezelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_bj"]];
    //        HUD.bezelView.tintColor = [UIColor clearColor];
    
    HUD.bezelView.layer.cornerRadius = 16;
    HUD.mode = MBProgressHUDModeCustomView;
    //        HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.customView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    HUD.customView = imageView;
    HUD.margin = 5;
    NSLog(@"HUD的margin:%f",HUD.margin);
//    HUD.delegate = self;
    HUD.square = YES;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:5];

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
    self.pointlabel = [[UILabel alloc] initWithFrame:CGRectMake(15*autoSizeScaleX, 64+(15+118+20)*autoSizeScaleY, 345*autoSizeScaleY, 14*autoSizeScaleY)];
    self.pointlabel.textAlignment = NSTextAlignmentCenter;
    self.pointlabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:15.0*autoSizeScaleY];
    self.pointlabel.text = @"可用积分：200";
    self.pointlabel.textColor = [UIColor colorWithHexString:@"162271"];
//    self.pointlabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.pointlabel];
    
    self.chargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(32*autoSizeScaleX, 64+(15+118+20+14+25)*autoSizeScaleY, 310*autoSizeScaleX/2, 60*autoSizeScaleY)];
    [self.chargeBtn setBackgroundImage:[UIImage imageNamed:@"integral_btn_left"] forState:UIControlStateNormal];
//    self.user.usertype = 0;
//    if(self.user.usertype==0){
        [self.chargeBtn setTitle:@"积分充值" forState:UIControlStateNormal];
        [self.chargeBtn addTarget:self action:@selector(toCharge:) forControlEvents:UIControlEventTouchUpInside];
//    }else{
//        [self.chargeBtn setTitle:@"积分提现" forState:UIControlStateNormal];
//        [self.chargeBtn addTarget:self action:@selector(toWithdraw:) forControlEvents:UIControlEventTouchUpInside];
//    }
    [self.topView addSubview:self.chargeBtn];
    
    self.getBackbtn = [[UIButton alloc] initWithFrame:CGRectMake(32*autoSizeScaleX+310*autoSizeScaleX/2+1, 64+(15+118+20+14+25)*autoSizeScaleY, 310*autoSizeScaleX/2, 60*autoSizeScaleY)];
    [self.getBackbtn setBackgroundImage:[UIImage imageNamed:@"integral_btn_right"] forState:UIControlStateNormal];
    
//    if(self.user.usertype==0){
        [self.getBackbtn setTitle:@"积分提现" forState:UIControlStateNormal];
        [self.getBackbtn addTarget:self action:@selector(toWithdraw:) forControlEvents:UIControlEventTouchUpInside];
//    }else{
//        [self.getBackbtn setTitle:@"提现说明" forState:UIControlStateNormal];
//        [self.getBackbtn addTarget:self action:@selector(withdraw:) forControlEvents:UIControlEventTouchUpInside];
//    }
    [self.topView addSubview:self.getBackbtn];
    
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 64+274*autoSizeScaleY, 345*autoSizeScaleX, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"162271"];
    lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:lineView];
    
    [self.head addSubview:self.topView];
}

- (void)setHead{
    //加载头像
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:@"http://static.cnbetacdn.com/topics/6b6702c2167e5a2.jpg"]];// placeholderImage:[UIImage imageNamed:@"default_head"]
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 32, 80, 18)];
    titleLabel.textColor = [UIColor colorWithHexString:@"404043"];
    [titleLabel setFont:[UIFont fontWithName:@"Droid Sans" size:18.f]];
    titleLabel.text = @"积分明细";
    [view addSubview:titleLabel];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(Width-18-15, 32, 18, 18)];
    [btn setImage:[UIImage imageNamed:@"integral_screen"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(filter:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    UIView *separtorView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, Width, 1)];
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


//充值
-(void)toCharge:(id)sender {
    if(!chargeVC){
        AMAlertView *amalertview = [[AMAlertView alloc] initWithconsFrame:CGRectMake(45*autoSizeScaleX, (Height-247)/2, Width-90*autoSizeScaleX, 247*autoSizeScaleY)];
        [amalertview setTitle:@"积分充值"];
        
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width-90*autoSizeScaleX, (247-46)*autoSizeScaleY)];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(12*autoSizeScaleX, 20*autoSizeScaleY, Width-90*autoSizeScaleX-24, 40*autoSizeScaleY)];
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"请填写充值金额(￥)";
        [textField setValue:[UIColor colorWithHexString:@"15151b"] forKeyPath:@"_placeholderLabel.textColor"];
        [textField setValue:[UIFont fontWithName:@"Droid Sans Fallback" size:17*autoSizeScaleX] forKeyPath:@"_placeholderLabel.font"];
        textField.font = [UIFont fontWithName:@"Droid Sans Fallback" size:17*autoSizeScaleX];
        textField.layer.cornerRadius = 4*autoSizeScaleY;
        textField.layer.masksToBounds = YES;
        textField.layer.borderColor = [[UIColor colorWithHexString:@"bbbbbd"] CGColor];
        textField.layer.borderWidth = 0.5*autoSizeScaleY;
        [childView addSubview:textField];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12*autoSizeScaleX, (20+40+28)*autoSizeScaleY, 60*autoSizeScaleX, 15*autoSizeScaleY)];
        label.text = @"付款方式";
        label.textColor = [UIColor colorWithHexString:@"45454a"];
        label.font = [UIFont fontWithName:@"Droid Sans Fallback" size:15*autoSizeScaleX];
        [childView addSubview:label];
        
        //支付宝
        BEMCheckBox *aliPay = [[BEMCheckBox alloc] initWithFrame:CGRectMake(12*autoSizeScaleX+60+20, (20+40+28+3)*autoSizeScaleY, 10, 10)];
        aliPay.onFillColor = [UIColor colorWithHexString:@"162271"];
        aliPay.onCheckColor = [UIColor colorWithHexString:@"162271"];
        aliPay.onTintColor = [UIColor colorWithHexString:@"162271"];
        aliPay.on = YES;
        [childView addSubview:aliPay];
        
        UILabel *aliLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*autoSizeScaleX+60+20+15+4, (20+40+28)*autoSizeScaleY, 60*autoSizeScaleY, 15*autoSizeScaleY)];
        aliLabel.text = @"支付宝";
        aliLabel.textColor = [UIColor colorWithHexString:@"15151b"];
        aliLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:17.f*autoSizeScaleY];
        [childView addSubview:aliLabel];
        
        //微信
        BEMCheckBox *wxPay = [[BEMCheckBox alloc] initWithFrame:CGRectMake(aliLabel.frame.origin.x+60*autoSizeScaleY+8, (20+40+28+3)*autoSizeScaleY, 10, 10)];
        wxPay.onFillColor = [UIColor colorWithHexString:@"162271"];
        wxPay.onCheckColor = [UIColor colorWithHexString:@"162271"];
        wxPay.onTintColor = [UIColor colorWithHexString:@"162271"];
        wxPay.on = NO;
        [childView addSubview:wxPay];
        
        UILabel *wxLabel = [[UILabel alloc] initWithFrame:CGRectMake(wxPay.frame.origin.x+15+4, (20+40+28)*autoSizeScaleY, 60*autoSizeScaleY, 15*autoSizeScaleY)];
        wxLabel.text = @"微信";
        wxLabel.textColor = [UIColor colorWithHexString:@"15151b"];
        wxLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:17.f*autoSizeScaleY];
        [childView addSubview:wxLabel];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(12*autoSizeScaleX, (247-46)*autoSizeScaleY-(27+40)*autoSizeScaleY, Width-90*autoSizeScaleX-24, 48*autoSizeScaleY)];
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


-(void)closeChargeVC:(id)sender {
    
    //微信支付
//    NSString *res = [WXApiRequestHandler jumpToBizPay];
//    if( ![@"" isEqual:res] ){
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        
//        [alter show];
//    }
//    
    if(chargeVC){
        [chargeVC dismissViewControllerAnimated:NO completion:nil];
    }
}
//提现
-(void)toWithdraw:(id)sender {
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
        BEMCheckBox *aliPay = [[BEMCheckBox alloc] initWithFrame:CGRectMake(12*autoSizeScaleX, (23+21+14+3)*autoSizeScaleY, 10, 10)];
        aliPay.onFillColor = [UIColor colorWithHexString:@"162271"];
        aliPay.onCheckColor = [UIColor colorWithHexString:@"162271"];
        aliPay.onTintColor = [UIColor colorWithHexString:@"162271"];
        aliPay.on = YES;
        [childView addSubview:aliPay];
        
        UILabel *cardLabel = [[UILabel alloc] initWithFrame:CGRectMake((12+15+12)*autoSizeScaleX, (23+21+14)*autoSizeScaleY, Width-90*autoSizeScaleX-15-(12+12)*autoSizeScaleX, 15*autoSizeScaleY)];
        cardLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:17*autoSizeScaleX];
        cardLabel.textColor = [UIColor colorWithHexString:@"15151b"];
        cardLabel.text = @"中国银行储蓄卡（789）";
        [childView addSubview:cardLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10*autoSizeScaleX, (23+21+14+15+28)*autoSizeScaleY, Width-(90+20)*autoSizeScaleX, 40*autoSizeScaleY)];
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"请填写提现积分";
        [textField setValue:[UIColor colorWithHexString:@"15151b"] forKeyPath:@"_placeholderLabel.textColor"];
        [textField setValue:[UIFont fontWithName:@"Droid Sans Fallback" size:17*autoSizeScaleX] forKeyPath:@"_placeholderLabel.font"];
        textField.font = [UIFont fontWithName:@"Droid Sans Fallback" size:17*autoSizeScaleX];
        textField.layer.cornerRadius = 4*autoSizeScaleY;
        textField.layer.masksToBounds = YES;
        textField.layer.borderColor = [[UIColor colorWithHexString:@"bbbbbd"] CGColor];
        textField.layer.borderWidth = 0.5*autoSizeScaleY;
        [childView addSubview:textField];
        
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
-(void)closeWithdraw:(id)sender {
    [withdrawVC dismissViewControllerAnimated:NO completion:nil];
}

//提现说明
-(void)withdraw:(id)sender {
    
}

@end
