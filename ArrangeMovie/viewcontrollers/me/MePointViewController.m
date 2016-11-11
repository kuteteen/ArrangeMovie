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


#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface MePointViewController()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
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
    [self.headImageView setShadowWithType:EMIShadowPathCircle shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.35 shadowRadius:10 image:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580" placeholder:@"miller"];
    
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
        AMAlertView *amalertview = [[AMAlertView alloc] initWithconsFrame:CGRectMake(45*autoSizeScaleX, (Height-247)/2, Width-90*autoSizeScaleX, 247*autoSizeScaleY)];
        [amalertview setTitle:@"积分充值"];
        
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width-90*autoSizeScaleX, (247-46)*autoSizeScaleY)];
        UITextField *textFild = [[UITextField alloc] initWithFrame:CGRectMake(12*autoSizeScaleX, 20*autoSizeScaleY, Width-90*autoSizeScaleX-24, 40*autoSizeScaleY)];
        textFild.delegate = self;
        textFild.keyboardType = UIKeyboardTypeNumberPad;
        textFild.placeholder = @"请填写充值金额(￥)";
        [textFild setValue:[UIColor colorWithHexString:@"15151b"] forKeyPath:@"_placeholderLabel.textColor"];
        [textFild setValue:[UIFont systemFontOfSize:17*autoSizeScaleX] forKeyPath:@"_placeholderLabel.font"];
        textFild.font = [UIFont systemFontOfSize:17*autoSizeScaleX];
        textFild.layer.cornerRadius = 4*autoSizeScaleY;
        textFild.layer.masksToBounds = YES;
        textFild.layer.borderColor = [[UIColor colorWithHexString:@"bbbbbd"] CGColor];
        textFild.layer.borderWidth = 0.5*autoSizeScaleY;
        [childView addSubview:textFild];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12*autoSizeScaleX, (20+40+28)*autoSizeScaleY, 60*autoSizeScaleX, 15*autoSizeScaleY)];
        label.text = @"付款方式";
        label.textColor = [UIColor colorWithHexString:@"45454a"];
        label.font = [UIFont systemFontOfSize:15*autoSizeScaleX];
        [childView addSubview:label];
        
        //支付宝
        BEMCheckBox *aliPay = [[BEMCheckBox alloc] initWithFrame:CGRectMake(12*autoSizeScaleX+60+20, (20+40+28)*autoSizeScaleY, 15, 15)];
        //微信
        BEMCheckBox *wxPay = [[BEMCheckBox alloc] initWithFrame:CGRectMake(12*autoSizeScaleX+60+20+40, (20+40+28)*autoSizeScaleY, 15, 15)];
        
        
        [amalertview setChildView:childView];
        chargeVC = [[CKAlertViewController alloc] initWithAlertView:amalertview];
    }
    [self presentViewController:chargeVC animated:NO completion:nil];
}

//-(void)

-(void)toWithdraw:(id)sender {
    
}

@end
