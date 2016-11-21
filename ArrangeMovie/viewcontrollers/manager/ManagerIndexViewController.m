//
//  ManagerIndexViewController.m
//  ArrangeMovie
//
//  Created by Emi-iMac on 16/10/25.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ManagerIndexViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MeViewController.h"
#import "ManagerNewMissionTableViewCell.h"
#import "Task.h"
#import "ManagerMissionDetailViewController.h"
#import "ManagerMissionViewController.h"
#import "UIView+SDAutoLayout.h"
#import "EMINavigationController.h"
#import "UIImageView+Webcache.h"
#import "UILabel+StringFrame.h"
#import "ManagerTaskWebInterface.h"
#import "SCHttpOperation.h"

@interface ManagerIndexViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
    Task *selTask;
}
@property (strong, nonatomic) UIView *head;
@property (strong, nonatomic) UIImageView *topView;

@property (strong, nonatomic) UIImageView *headImgView;
//@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *cinemaLabel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic)  UILabel *nameLab;//姓名

@property (strong,nonatomic) UILabel *pointFirstLab;//积分首数字
@property (strong,nonatomic) UILabel *pointOtherLab;//积分其他数字

@property (strong,nonatomic) UILabel *releaseCountLab;//已领取个数首字母
@property (strong,nonatomic) UILabel *releaseAllCountLab;//已领取个数其他字母+/+已领取总个数

@property (strong,nonatomic) UILabel *shCountLab;//待审核个数首字母
@property (strong,nonatomic) UILabel *shAllCountLab;//待审核个数其他字母+/+待审核总个数

@property (strong,nonatomic) UILabel *payCountLab;//已支付个数首字母
@property (strong,nonatomic) UILabel *payAllCountLab;//已支付个数其他字母+/已支付总个数


@property(nonatomic,strong)UIImageView *leadaddView;//引导图片
@property(nonatomic,strong)UIImageView *leadmyView;//引导图片
@property(nonatomic,strong)UITapGestureRecognizer *removeLeadGes;//清除引导图片的手势


@property (strong, nonatomic) NSMutableArray *array;//数据源

@end

@implementation ManagerIndexViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"";

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"theatres_index_view_task" highImageName:@"theatres_index_view_task" target:self action:@selector(toMyMission)];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"film_home_my" highImageName:@"film_home_my" target:self action:@selector(presentRightMenuViewController:)];

//    self.tableView.tableFooterView = [[UIView alloc] init];

    
    [self initViews];
    
    [self showUser];
}

-(void)initViews {
    
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
    self.nameLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:16.0*autoSizeScaleY];
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
    
    [self initLeadView];
    
    
    [self fetchMission];
}

-(void)fetchMission {
    ManagerTaskWebInterface *webInterface = [[ManagerTaskWebInterface alloc] init];
    NSArray *array = @[self.user.userid,@0];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:webInterface.url withparameter:[webInterface inboxObject:array] WithReturnValeuBlock:^(id returnValue) {
        
    } WithErrorCodeBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
    
}



//加载引导相关的视图，只在第一次进入这个应用时加载一次
- (void)initLeadView{
    //首先，隐藏navigation
    [self.navigationController setNavigationBarHidden:YES];
    
    self.leadmyView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.leadmyView.tag = 0;
    self.leadmyView.image = [UIImage imageNamed:@"cinema_manager_my_new"];
    self.leadmyView.userInteractionEnabled = YES;
    [self.view addSubview:self.leadmyView];
    
    self.leadaddView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.leadaddView.tag = 1;
    self.leadaddView.image = [UIImage imageNamed:@"cinema_manager_task_new"];
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

//创建其他labs
- (void)createLabs{
    //积分
    UILabel *pointTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(152*autoSizeScaleX, 64+22*autoSizeScaleY, 100, 100)];
    pointTitleLab.textAlignment = NSTextAlignmentLeft;
    pointTitleLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:10.5*autoSizeScaleY];
    pointTitleLab.text = @"我的积分";
    pointTitleLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize pointTitleLabSize = [pointTitleLab boundingRectWithSize:CGSizeZero];
    pointTitleLab.frame = CGRectMake(152*autoSizeScaleX, 64+22*autoSizeScaleY, pointTitleLabSize.width, pointTitleLabSize.height);
    pointTitleLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:pointTitleLab];
    //积分第一位
    self.pointFirstLab = [[UILabel alloc] initWithFrame:CGRectMake(152*autoSizeScaleX, 0, 100, 100)];
    self.pointFirstLab.textAlignment = NSTextAlignmentLeft;
    self.pointFirstLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:39*autoSizeScaleY];
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
    self.pointOtherLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:15*autoSizeScaleY];
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
    pointUnitLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:15*autoSizeScaleY];
    pointUnitLab.text = @"分";
    pointUnitLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize pointUnitLabSize = [self.pointOtherLab boundingRectWithSize:CGSizeZero];
    pointUnitLab.frame = CGRectMake(208*autoSizeScaleX, 64+(153-64)*autoSizeScaleY-pointUnitLab.font.capHeight-4, pointUnitLabSize.width, pointUnitLab.font.capHeight+4);
    pointUnitLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:pointUnitLab];
    //已领取
    UILabel *releaseTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(268*autoSizeScaleX, 64+22*autoSizeScaleY, 100, 100)];
    releaseTitleLab.textAlignment = NSTextAlignmentLeft;
    releaseTitleLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:10.5*autoSizeScaleY];
    releaseTitleLab.text = @"已领取";
    releaseTitleLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize releaseTitleLabSize = [releaseTitleLab boundingRectWithSize:CGSizeZero];
    releaseTitleLab.frame = CGRectMake(268*autoSizeScaleX, 64+22*autoSizeScaleY, releaseTitleLabSize.width, releaseTitleLabSize.height);
    releaseTitleLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:releaseTitleLab];
    //已领取个数 首字母
    self.releaseCountLab = [[UILabel alloc] initWithFrame:CGRectMake(268*autoSizeScaleX, 0, 100, 100)];
    self.releaseCountLab.textAlignment = NSTextAlignmentLeft;
    self.releaseCountLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:39*autoSizeScaleY];
    self.releaseCountLab.text = @"2";
    self.releaseCountLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize releaseCountLabSize = [self.releaseCountLab boundingRectWithSize:CGSizeZero];
    self.releaseCountLab.frame = CGRectMake(268*autoSizeScaleX, 64+(153-64)*autoSizeScaleY-self.releaseCountLab.font.capHeight-5, releaseCountLabSize.width, self.releaseCountLab.font.capHeight+3);
    self.releaseCountLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.releaseCountLab];
    //已领取个数其他字母 + / + 已领取总个数
    self.releaseAllCountLab = [[UILabel alloc] initWithFrame:CGRectMake(292*autoSizeScaleX, 0, 100, 100)];
    self.releaseAllCountLab.textAlignment = NSTextAlignmentLeft;
    self.releaseAllCountLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:15*autoSizeScaleY];
    self.releaseAllCountLab.text = @""" / 10 个";
    self.releaseAllCountLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize releaseAllCountLabSize = [self.releaseAllCountLab boundingRectWithSize:CGSizeZero];
    self.releaseAllCountLab.frame = CGRectMake(292*autoSizeScaleX, 64+(153-64)*autoSizeScaleY-self.releaseAllCountLab.font.capHeight-4, releaseAllCountLabSize.width, self.releaseAllCountLab.font.capHeight+3);
    self.releaseAllCountLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.releaseAllCountLab];
    //待审核
    UILabel *shTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(152*autoSizeScaleX, 64+108*autoSizeScaleY, 100, 100)];
    shTitleLab.textAlignment = NSTextAlignmentLeft;
    shTitleLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:10.5*autoSizeScaleY];
    shTitleLab.text = @"待审核";
    shTitleLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize shTitleLabSize = [shTitleLab boundingRectWithSize:CGSizeZero];
    shTitleLab.frame = CGRectMake(152*autoSizeScaleX, 64+108*autoSizeScaleY, shTitleLabSize.width, shTitleLabSize.height);
    shTitleLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:shTitleLab];
    //待审核 首字母
    self.shCountLab = [[UILabel alloc] initWithFrame:CGRectMake(152*autoSizeScaleX, 0, 100, 100)];
    self.shCountLab.textAlignment = NSTextAlignmentLeft;
    self.shCountLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:39*autoSizeScaleY];
    self.shCountLab.text = @"1";
    self.shCountLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize shCountLabSize = [self.shCountLab boundingRectWithSize:CGSizeZero];
    self.shCountLab.frame = CGRectMake(152*autoSizeScaleX, 64+(238.5-64)*autoSizeScaleY-self.shCountLab.font.capHeight-5, shCountLabSize.width, self.shCountLab.font.capHeight+3);
    self.shCountLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.shCountLab];
    //待审核个数其他字母 + / + 待审核总个数
    self.shAllCountLab = [[UILabel alloc] initWithFrame:CGRectMake(174*autoSizeScaleX, 0, 100, 100)];
    self.shAllCountLab.textAlignment = NSTextAlignmentLeft;
    self.shAllCountLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:15*autoSizeScaleY];
    self.shAllCountLab.text = @""" / 3 个";
    self.shAllCountLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize shAllCountLabSize = [self.shAllCountLab boundingRectWithSize:CGSizeZero];
    self.shAllCountLab.frame = CGRectMake(174*autoSizeScaleX, 64+(238.5-64)*autoSizeScaleY-self.shAllCountLab.font.capHeight-4, shAllCountLabSize.width, self.shAllCountLab.font.capHeight+3);
    self.shAllCountLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.shAllCountLab];
    //已支付
    UILabel *payTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(268*autoSizeScaleX, 64+108*autoSizeScaleY, 100, 100)];
    payTitleLab.textAlignment = NSTextAlignmentLeft;
    payTitleLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:10.5*autoSizeScaleY];
    payTitleLab.text = @"已支付";
    payTitleLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize payTitleLabSize = [payTitleLab boundingRectWithSize:CGSizeZero];
    payTitleLab.frame = CGRectMake(268*autoSizeScaleX, 64+108*autoSizeScaleY, payTitleLabSize.width, payTitleLabSize.height);
    payTitleLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:payTitleLab];
    //已支付个数 首字母
    self.payCountLab = [[UILabel alloc] initWithFrame:CGRectMake(268*autoSizeScaleX, 0, 100, 100)];
    self.payCountLab.textAlignment = NSTextAlignmentLeft;
    self.payCountLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:39*autoSizeScaleY];
    self.payCountLab.text = @"1";
    self.payCountLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize payCountLabSize = [self.payCountLab boundingRectWithSize:CGSizeZero];
    self.payCountLab.frame = CGRectMake(268*autoSizeScaleX, 64+(238.5-64)*autoSizeScaleY-self.payCountLab.font.capHeight-5, payCountLabSize.width, self.payCountLab.font.capHeight+3);
    self.payCountLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.payCountLab];
    //已支付个数其他字母 + / 已支付总个数
    self.payAllCountLab = [[UILabel alloc] initWithFrame:CGRectMake(292*autoSizeScaleX, 0, 100, 100)];
    self.payAllCountLab.textAlignment = NSTextAlignmentLeft;
    self.payAllCountLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:15*autoSizeScaleY];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showUser {

    if(self.user){
        self.nameLab.text = self.user.nickname;
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.user.headimg] placeholderImage:[UIImage imageNamed:@"miller"]];
    }
}

-(NSMutableArray *)array {
    if(!_array){
        _array = [[NSMutableArray alloc] init];
        for(int i = 0;i<10;i++){
            Task *task = [[Task alloc] init];
            task.filmname = @"让子弹飞";
            task.filmdirector = @"姜文";
            task.startdate = @"2016/10/28";
            task.enddate = @"2016/11/28";
            task.taskpoints = @"200";
            task.filmstars = @"本尼迪克特·康伯巴奇,马丁·弗瑞曼,安德鲁·斯科特,马克·加蒂斯";
            task.startdate = @"2016-10-31";
            task.enddate = @"2016-11-21";
            task.shownum = @"30";
            task.tasknum = @"10";
            task.surplusnum = @"7";
            task.gradename = @"A级影院";
            [_array addObject:task];
        }
    }
    return _array;
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 101.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManagerNewMissionTableViewCell *cell = [ManagerNewMissionTableViewCell cellWithTableView:tableView];
    [cell setValue:self.array[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    selTask = self.array[indexPath.row];
//    [self performSegueWithIdentifier:@"tomissiondetail" sender:nil];
    [self startAnimationForIndexPath:indexPath];
}

-(void)startAnimationForIndexPath:(NSIndexPath*)indexPath{
    
    ManagerMissionDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"managermissiondetail"];
    viewController.user = self.user;
    viewController.task = selTask;
    
    ManagerNewMissionTableViewCell *cell = (ManagerNewMissionTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    ///cell在tableView的位置
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    
    //cell在viewController中的位置
    CGRect rect = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    CGRect originRect = CGRectMake(rect.origin.x+15, rect.origin.y+25, cell.postImgView.frame.size.width, cell.postImgView.frame.size.height);
    cell.imgRect = originRect;
    
    [((EMINavigationController *)self.navigationController) pushViewController:viewController withImageView:cell.postImgView originRect:originRect desRect:CGRectMake(15, 84, 60, 65)];
}

 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     NSString *identifier = segue.identifier;
     if([identifier isEqualToString:@"tomanagermission"]){
         ManagerMissionViewController *viewController = (ManagerMissionViewController *)segue.destinationViewController;
         viewController.user = self.user;
//         viewController.user = self.user;
     }else if([identifier isEqualToString:@"tomissiondetail"]){
         ManagerMissionDetailViewController *viewController = (ManagerMissionDetailViewController *)segue.destinationViewController;
         viewController.user = self.user;
         viewController.task = selTask;
     }
 }



-(void)toMyMission {
    [self performSegueWithIdentifier:@"tomanagermission" sender:nil];
}

-(void)toMyProfile {
    
    
   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"me" bundle:nil];
    MeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"me"];
    viewController.user = self.user;
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
