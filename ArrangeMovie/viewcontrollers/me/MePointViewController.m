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


#define width [UIScreen mainScreen].bounds.size.width

@interface MePointViewController()<UITableViewDelegate,UITableViewDataSource>

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
    
    [self.depositBtn setImage:[UIImage imageNamed:@"integral_recharge"] forState:UIControlStateNormal];
    [self.getBackbtn setImage:[UIImage imageNamed:@"integral_withdraw_cash"] forState:UIControlStateNormal];
    
    
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 54)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 80, 10)];
    titleLabel.textColor = [UIColor colorWithHexString:@"404043"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18.f]];
    titleLabel.text = @"积分明细";
    [view addSubview:titleLabel];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width-18-15, 25, 18, 18)];
    [btn setImage:[UIImage imageNamed:@"integral_screen"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(filter:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    UIView *separtorView = [[UIView alloc] initWithFrame:CGRectMake(0, 54, width, 1)];
    separtorView.backgroundColor = [UIColor whiteColor];
    [view addSubview:separtorView];
    
    return view;
}

-(void)filter:(id)sender {
    NSLog(@"点击筛选按钮");
}

@end
