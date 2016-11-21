//
//  PFHomeViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "PFHomeViewController.h"
#import "MakeTaskViewController.h"
#import "EMINavigationController.h"

@interface PFHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic,strong)NSMutableArray *sectionArray;//section数组(里面包裹着各个section的数据)
@property(nonatomic,strong)NSMutableArray *isshowArray;//是否展示数组(和sectionArray数量保持一致)
@property(nonatomic,strong)NSMutableArray *issselectedArray;//是否选中数组(和sectionArray数量保持一致),用来标志背景色


@property(nonatomic,strong)UIImageView *leadaddView;//引导图片
@property(nonatomic,strong)UIImageView *leadmyView;//引导图片
@property(nonatomic,strong)UITapGestureRecognizer *removeLeadGes;//清除引导图片的手势
@end

@implementation PFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.sectionArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < 100; i++) {
        [self.sectionArray addObject:@[@1,@2,@3]];
    }
    self.isshowArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.issselectedArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self handleData];
    
    [self initView];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initView{
    
    //tabelview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.bounces = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64+199.25*autoSizeScaleY)];
    
    self.topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64+199.25*autoSizeScaleY)];
    self.topView.image = [UIImage imageNamed:@"pfhome_topbg"];
    self.topView.contentMode = UIViewContentModeScaleAspectFill;
    self.topView.clipsToBounds = YES;
    //头像
    self.headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(11*autoSizeScaleX,64+22*autoSizeScaleY,118*autoSizeScaleY,118*autoSizeScaleY)];
    self.headImgView.layer.masksToBounds =YES;
    self.headImgView.layer.cornerRadius = 118*autoSizeScaleY/2;
    self.headImgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self setHead];
    [self.topView addSubview:self.headImgView];
    //姓名
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(11*autoSizeScaleX, 64+158*autoSizeScaleY, 118*autoSizeScaleY, 100)];
    self.nameLab.textAlignment = NSTextAlignmentCenter;
    self.nameLab.font = [UIFont fontWithName:@"DroidSansFallback" size:16.0*autoSizeScaleY];
    self.nameLab.text = @"乔布斯";
    self.nameLab.frame = CGRectMake(11*autoSizeScaleX, 64+(238.5-64)*autoSizeScaleY-self.nameLab.font.capHeight-5, 118*autoSizeScaleY, self.nameLab.font.capHeight+3);
    self.nameLab.textColor = [UIColor colorWithHexString:@"162271"];
    self.nameLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.nameLab];
    
    //创建其他具体的Label
    
    [self createLabs];
    
    [self.head addSubview:self.topView];
    self.tableView.tableHeaderView = self.head;
    
    [self.tableView sendSubviewToBack:self.tableView.tableHeaderView];
    
    [self.view addSubview:self.tableView];
    
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"film_home_add" highImageName:@"film_home_add" target:self action:@selector(leftNavBtnClicked:)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"film_home_my" highImageName:@"film_home_my" target:self action:@selector(presentRightMenuViewController:)];
    
    
    [self initLeadView];
}


//创建其他labs
- (void)createLabs{
    //积分
    UILabel *pointTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(152*autoSizeScaleX, 64+22*autoSizeScaleY, 100, 100)];
    pointTitleLab.textAlignment = NSTextAlignmentLeft;
    pointTitleLab.font = [UIFont fontWithName:@"DroidSansFallback" size:10.5*autoSizeScaleY];
    pointTitleLab.text = @"我的积分";
    pointTitleLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize pointTitleLabSize = [pointTitleLab boundingRectWithSize:CGSizeZero];
    pointTitleLab.frame = CGRectMake(152*autoSizeScaleX, 64+22*autoSizeScaleY, pointTitleLabSize.width, pointTitleLabSize.height);
    pointTitleLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:pointTitleLab];
    //积分第一位
    self.pointFirstLab = [[UILabel alloc] initWithFrame:CGRectMake(152*autoSizeScaleX, 0, 100, 100)];
    self.pointFirstLab.textAlignment = NSTextAlignmentLeft;
    self.pointFirstLab.font = [UIFont fontWithName:@"DroidSansFallback" size:39*autoSizeScaleY];
    self.pointFirstLab.text = @"2";
//    self.pointFirstLab.backgroundColor = [UIColor redColor];
    self.pointFirstLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize pointFirstLabSize = [self.pointFirstLab boundingRectWithSize:CGSizeZero];
    self.pointFirstLab.frame = CGRectMake(152*autoSizeScaleX, 64+(153-64)*autoSizeScaleY-self.pointFirstLab.font.capHeight-5, pointFirstLabSize.width, self.pointFirstLab.font.capHeight+3);
    self.pointFirstLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.pointFirstLab];
    //积分后几位
    self.pointOtherLab = [[UILabel alloc] initWithFrame:CGRectMake(174*autoSizeScaleX, 0, 100, 100)];
    self.pointOtherLab.textAlignment = NSTextAlignmentLeft;
    self.pointOtherLab.font = [UIFont fontWithName:@"DroidSansFallback" size:15*autoSizeScaleY];
    self.pointOtherLab.text = @"300";
//    self.pointOtherLab.backgroundColor = [UIColor yellowColor];
    self.pointOtherLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize pointOtherLabSize = [self.pointOtherLab boundingRectWithSize:CGSizeZero];
    self.pointOtherLab.frame = CGRectMake(177*autoSizeScaleX, 64+(153-64)*autoSizeScaleY-self.pointOtherLab.font.capHeight-4, pointOtherLabSize.width, self.pointOtherLab.font.capHeight+3);
    self.pointOtherLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.pointOtherLab];
    
    //单位
    UILabel *pointUnitLab = [[UILabel alloc] initWithFrame:CGRectMake(208*autoSizeScaleX, 0, 100, 100)];
    pointUnitLab.textAlignment = NSTextAlignmentLeft;
    pointUnitLab.font = [UIFont fontWithName:@"DroidSansFallback" size:15*autoSizeScaleY];
    pointUnitLab.text = @"分";
    pointUnitLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize pointUnitLabSize = [self.pointOtherLab boundingRectWithSize:CGSizeZero];
    pointUnitLab.frame = CGRectMake(208*autoSizeScaleX, 64+(153-64)*autoSizeScaleY-pointUnitLab.font.capHeight-4, pointUnitLabSize.width, pointUnitLab.font.capHeight+4);
    pointUnitLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:pointUnitLab];
    //已领取
    UILabel *releaseTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(268*autoSizeScaleX, 64+22*autoSizeScaleY, 100, 100)];
    releaseTitleLab.textAlignment = NSTextAlignmentLeft;
    releaseTitleLab.font = [UIFont fontWithName:@"DroidSansFallback" size:10.5*autoSizeScaleY];
    releaseTitleLab.text = @"已发布";
    releaseTitleLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize releaseTitleLabSize = [releaseTitleLab boundingRectWithSize:CGSizeZero];
    releaseTitleLab.frame = CGRectMake(268*autoSizeScaleX, 64+22*autoSizeScaleY, releaseTitleLabSize.width, releaseTitleLabSize.height);
    releaseTitleLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:releaseTitleLab];
    //已领取个数 首字母
    self.releaseCountLab = [[UILabel alloc] initWithFrame:CGRectMake(268*autoSizeScaleX, 0, 100, 100)];
    self.releaseCountLab.textAlignment = NSTextAlignmentLeft;
    self.releaseCountLab.font = [UIFont fontWithName:@"DroidSansFallback" size:39*autoSizeScaleY];
    self.releaseCountLab.text = @"2";
    self.releaseCountLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize releaseCountLabSize = [self.releaseCountLab boundingRectWithSize:CGSizeZero];
    self.releaseCountLab.frame = CGRectMake(268*autoSizeScaleX, 64+(153-64)*autoSizeScaleY-self.releaseCountLab.font.capHeight-5, releaseCountLabSize.width, self.releaseCountLab.font.capHeight+3);
    self.releaseCountLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.releaseCountLab];
    //已领取个数其他字母 + / + 已领取总个数
    self.releaseAllCountLab = [[UILabel alloc] initWithFrame:CGRectMake(292*autoSizeScaleX, 0, 100, 100)];
    self.releaseAllCountLab.textAlignment = NSTextAlignmentLeft;
    self.releaseAllCountLab.font = [UIFont fontWithName:@"DroidSansFallback" size:15*autoSizeScaleY];
    self.releaseAllCountLab.text = @""" / 10 个";
    self.releaseAllCountLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize releaseAllCountLabSize = [self.releaseAllCountLab boundingRectWithSize:CGSizeZero];
    self.releaseAllCountLab.frame = CGRectMake(292*autoSizeScaleX, 64+(153-64)*autoSizeScaleY-self.releaseAllCountLab.font.capHeight-4, releaseAllCountLabSize.width, self.releaseAllCountLab.font.capHeight+3);
    self.releaseAllCountLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.releaseAllCountLab];
    //待审核
    UILabel *shTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(152*autoSizeScaleX, 64+108*autoSizeScaleY, 100, 100)];
    shTitleLab.textAlignment = NSTextAlignmentLeft;
    shTitleLab.font = [UIFont fontWithName:@"DroidSansFallback" size:10.5*autoSizeScaleY];
    shTitleLab.text = @"待审核";
    shTitleLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize shTitleLabSize = [shTitleLab boundingRectWithSize:CGSizeZero];
    shTitleLab.frame = CGRectMake(152*autoSizeScaleX, 64+108*autoSizeScaleY, shTitleLabSize.width, shTitleLabSize.height);
    shTitleLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:shTitleLab];
    //待审核 首字母
    self.shCountLab = [[UILabel alloc] initWithFrame:CGRectMake(152*autoSizeScaleX, 0, 100, 100)];
    self.shCountLab.textAlignment = NSTextAlignmentLeft;
    self.shCountLab.font = [UIFont fontWithName:@"DroidSansFallback" size:39*autoSizeScaleY];
    self.shCountLab.text = @"1";
    self.shCountLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize shCountLabSize = [self.shCountLab boundingRectWithSize:CGSizeZero];
    self.shCountLab.frame = CGRectMake(152*autoSizeScaleX, 64+(238.5-64)*autoSizeScaleY-self.shCountLab.font.capHeight-5, shCountLabSize.width, self.shCountLab.font.capHeight+3);
    self.shCountLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.shCountLab];
    //待审核个数其他字母 + / + 待审核总个数
    self.shAllCountLab = [[UILabel alloc] initWithFrame:CGRectMake(174*autoSizeScaleX, 0, 100, 100)];
    self.shAllCountLab.textAlignment = NSTextAlignmentLeft;
    self.shAllCountLab.font = [UIFont fontWithName:@"DroidSansFallback" size:15*autoSizeScaleY];
    self.shAllCountLab.text = @""" / 3 个";
    self.shAllCountLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize shAllCountLabSize = [self.shAllCountLab boundingRectWithSize:CGSizeZero];
    self.shAllCountLab.frame = CGRectMake(174*autoSizeScaleX, 64+(238.5-64)*autoSizeScaleY-self.shAllCountLab.font.capHeight-4, shAllCountLabSize.width, self.shAllCountLab.font.capHeight+3);
    self.shAllCountLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.shAllCountLab];
    //已支付
    UILabel *payTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(268*autoSizeScaleX, 64+108*autoSizeScaleY, 100, 100)];
    payTitleLab.textAlignment = NSTextAlignmentLeft;
    payTitleLab.font = [UIFont fontWithName:@"DroidSansFallback" size:10.5*autoSizeScaleY];
    payTitleLab.text = @"已支付";
    payTitleLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize payTitleLabSize = [payTitleLab boundingRectWithSize:CGSizeZero];
    payTitleLab.frame = CGRectMake(268*autoSizeScaleX, 64+108*autoSizeScaleY, payTitleLabSize.width, payTitleLabSize.height);
    payTitleLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:payTitleLab];
    //已支付个数 首字母
    self.payCountLab = [[UILabel alloc] initWithFrame:CGRectMake(268*autoSizeScaleX, 0, 100, 100)];
    self.payCountLab.textAlignment = NSTextAlignmentLeft;
    self.payCountLab.font = [UIFont fontWithName:@"DroidSansFallback" size:39*autoSizeScaleY];
    self.payCountLab.text = @"1";
    self.payCountLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize payCountLabSize = [self.payCountLab boundingRectWithSize:CGSizeZero];
    self.payCountLab.frame = CGRectMake(268*autoSizeScaleX, 64+(238.5-64)*autoSizeScaleY-self.payCountLab.font.capHeight-5, payCountLabSize.width, self.payCountLab.font.capHeight+3);
    self.payCountLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.payCountLab];
    //已支付个数其他字母 + / 已支付总个数
    self.payAllCountLab = [[UILabel alloc] initWithFrame:CGRectMake(292*autoSizeScaleX, 0, 100, 100)];
    self.payAllCountLab.textAlignment = NSTextAlignmentLeft;
    self.payAllCountLab.font = [UIFont fontWithName:@"DroidSansFallback" size:15*autoSizeScaleY];
    self.payAllCountLab.text = @""" / 4 个";
    self.payAllCountLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize payAllCountLabSize = [self.payAllCountLab boundingRectWithSize:CGSizeZero];
    self.payAllCountLab.frame = CGRectMake(292*autoSizeScaleX, 64+(238.5-64)*autoSizeScaleY-self.payAllCountLab.font.capHeight-4, payAllCountLabSize.width, self.payAllCountLab.font.capHeight+3);
    self.payAllCountLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.payAllCountLab];
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 64+192.3*autoSizeScaleY, 345*autoSizeScaleX, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"162271"];
    lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:lineView];
}

//加载引导相关的视图，只在第一次进入这个应用时加载一次
- (void)initLeadView{
    //首先，隐藏navigation
    [self.navigationController setNavigationBarHidden:YES];
    
    self.leadmyView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.leadmyView.tag = 0;
    self.leadmyView.image = [UIImage imageNamed:@"film_lead_my"];
    self.leadmyView.userInteractionEnabled = YES;
    [self.view addSubview:self.leadmyView];
    
    self.leadaddView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.leadaddView.tag = 1;
    self.leadaddView.image = [UIImage imageNamed:@"film_lead_add"];
    self.leadaddView.userInteractionEnabled = YES;
    [self.view addSubview:self.leadaddView];
    
    self.removeLeadGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeLead:)];
    [self.leadaddView addGestureRecognizer:self.removeLeadGes];
    
}

//清除引导相关视图
- (void)removeLead:(UITapGestureRecognizer *)sender{
    //点击leadaddView
    if (sender.view.tag == 1) {
        [self.leadaddView removeFromSuperview];
        [self.leadaddView removeGestureRecognizer:self.removeLeadGes];
        [self.leadmyView addGestureRecognizer:self.removeLeadGes];
        return;
    }
    //点击leadaddView
    if (sender.view.tag == 0) {
        [self.leadmyView removeFromSuperview];
        [self.navigationController setNavigationBarHidden:NO];
        return;
    }
}

- (void)setHead{
    //加载头像
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:@"http://static.cnbetacdn.com/topics/6b6702c2167e5a2.jpg"]];// placeholderImage:[UIImage imageNamed:@"default_head"]
    
}

//处理数据
- (void)handleData{
    for (int i = 0 ; i < self.sectionArray.count; i++) {
        [self.isshowArray addObject:@NO];
        [self.issselectedArray addObject:@NO];
    }
}


//新增拍片任务
- (void)leftNavBtnClicked:(UIBarButtonItem *)sender{
//    [self performSegueWithIdentifier:@"toMakeTaskVC" sender:self];
    MakeTaskViewController *mtVC = [[UIStoryboard storyboardWithName:@"pfhome" bundle:nil] instantiateViewControllerWithIdentifier:@"mtVC"];
    EMINavigationController *mtNav = [[EMINavigationController alloc] initWithRootViewController:mtVC];
    [self presentViewController:mtNav animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    //替代tableview的视图
    /*
    if (self.sectionArray.count == 0) {
//        self.tableView.hidden = YES;
        self.noDataView = [[TableWithNoDataView alloc] initGesture];
        [self.view addSubview:self.noDataView];
        self.noDataView.sd_layout.heightRatioToView(self.tableView,1).widthRatioToView(self.tableView,1).centerXEqualToView(self.tableView).centerYEqualToView(self.tableView);
        
        [self.noDataView initLabel:@"暂无数据"];
        
        //点击刷新表格数据
        __unsafe_unretained typeof(self) weakSelf = self;
        [self.noDataView setBlock:^{
            [weakSelf.sectionArray addObject:@"1"];
            [weakSelf.tableView reloadData];
        }];
    }else{
        if (self.noDataView != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.noDataView.hidden = YES;
            });
            
//            self.tableView.hidden = NO;
        }
    }*/
    
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.isshowArray[section]  isEqual: @YES]) {
        return ((NSMutableArray *)(self.sectionArray[section])).count;
    }else{
        return 0;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PFHomeCell *cell = [PFHomeCell cellWithTableView:tableView];
    
    switch (indexPath.row) {
        case 0:
            [cell setValues:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2317499888,864114656&fm=116&gp=0.jpg" tailImg:@"" title:@"《让子弹飞》拍片任务接收"];
            
            break;
        case 1:
            [cell setValues:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2317499888,864114656&fm=116&gp=0.jpg" tailImg:@"film_index_task_finished" title:@"系统提示：《让子弹飞》拍片任务已完成"];
            
            break;
        case 2:
            [cell setValues:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2317499888,864114656&fm=116&gp=0.jpg" tailImg:@"film_index_task_lost" title:@"系统提示：《让子弹飞》拍片任务已失败"];
            
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46*autoSizeScaleY;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.isshowArray[section]  isEqual: @YES]) {
        return (103+15)*autoSizeScaleY;
    }else{
        return 103*autoSizeScaleY;
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PFHomeSectionView *sectionView = [[PFHomeSectionView alloc] initWithType:@"1" imageName:@"http://cdnq.duitang.com/uploads/item/201506/05/20150605124315_xFQtw.thumb.700_0.jpeg" titleStr:@"《让子弹飞》排片任务" bigNumStr:@"8" smallNumStr:@"0.5"];
    
    
    //背景色
//    if ([self.issselectedArray[section]  isEqual: @YES]) {
//        sectionView.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
//    }else{
//        sectionView.backgroundColor = [UIColor whiteColor];
//    }
    
    
    //展开图标
    
    if ([self.isshowArray[section]  isEqual: @YES]) {
        [sectionView operateSection:YES];
    }else{
        [sectionView operateSection:NO];
    }
    __unsafe_unretained typeof(self) weakSelf = self;
    [sectionView setBlock:^{
        
        if ([weakSelf.isshowArray[section]  isEqual: @YES]) {
            [weakSelf.isshowArray replaceObjectAtIndex:section withObject:@(NO)];
        }else{
            [weakSelf.isshowArray replaceObjectAtIndex:section withObject:@(YES)];
        }
        
        
        
        
        
        
        
        [weakSelf.issselectedArray replaceObjectAtIndex:section withObject:@YES];
        
        for (int i = 0;i < weakSelf.issselectedArray.count;i++){
            if (i != section){
                [weakSelf.issselectedArray replaceObjectAtIndex:i withObject:@NO];
            }
        }
        
        //刷新表格
        [weakSelf.tableView reloadData];
        

    }];
    return sectionView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"toUnDoVC" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"toDoneVC" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"toFailedVC" sender:self];
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//滑动

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    
    //图片高度
    CGFloat imageHeight = self.head.frame.size.height;
    //图片宽度
    CGFloat imageWidth = screenWidth;
    //图片上下偏移量
    CGFloat imageOffsetY = scrollView.contentOffset.y;
    
//    NSLog(@"图片上下偏移量 imageOffsetY:%f ->",imageOffsetY);
    
    
    
    //下拉
    if (imageOffsetY < 0) {
        CGFloat totalOffset = imageHeight + ABS(imageOffsetY);
        CGFloat f = totalOffset / imageHeight;
        
//        self.topView.frame = CGRectMake(-(imageWidth * f - imageWidth) * 0.5, imageOffsetY, imageWidth * f, totalOffset);伸缩
        //不伸缩
        self.topView.frame = CGRectMake(0, imageOffsetY, imageWidth, totalOffset);
        
    }
    
        //往上推
        if (imageOffsetY > 0) {
            CGFloat totalOffset = imageHeight + ABS(imageOffsetY);
//            CGFloat f = totalOffset / imageHeight;
    
            [self.topView setFrame:CGRectMake(0, -imageOffsetY/2, imageWidth, totalOffset)];
            
            
        }


    return;
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
