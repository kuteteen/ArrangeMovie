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
#import "DismissAnimation.h"
#import "PresentAnimation.h"
#import "MJRefreshGifHeader.h"
#import "UIImage+GIF.h"
#import "MeMissionViewController.h"
#import "MePointViewController.h"
#import "MeProfileViewController.h"

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


@property (strong, nonatomic) NSArray <Task *> *array;//数据源
@property (nonatomic, retain) UIPercentDrivenInteractiveTransition * percentDrivenTransition;
@end

@implementation ManagerIndexViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.title = @"";
    
    self.array = [[NSArray alloc] init];
    
    
    
    [self initViews];
    //动画代理
    self.transitioningDelegate = self;
    [self addScreenEdgePanGestureRecognizer:self.view edges:UIRectEdgeRight]; // 为self.view增加右侧的手势，用于push
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"theatres_index_view_task" highImageName:@"theatres_index_view_task" target:self action:@selector(toMyMission)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"film_home_my" highImageName:@"film_home_my" target:self action:@selector(tomy)];
    
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

//跳转至我的
- (void)tomy{
    UIStoryboard *me = [UIStoryboard storyboardWithName:@"me" bundle:nil];
    
    MeViewController * secondVC = [me instantiateViewControllerWithIdentifier:@"me"];
    
    
    
    EMINavigationController *nav = [[EMINavigationController alloc] initWithRootViewController:secondVC];
    nav.transitioningDelegate = self; // 必须second同样设置delegate才有动画
    [self addScreenEdgePanGestureRecognizer:secondVC.view edges:UIRectEdgeLeft];
    [self presentViewController:nav animated:YES completion:^{
    }];
}

// present动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[PresentAnimation alloc] init];
}
// dismiss动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[DismissAnimation alloc] init];
}

// 添加手势的方法
- (void)addScreenEdgePanGestureRecognizer:(UIView *)view edges:(UIRectEdge)edges{
    UIScreenEdgePanGestureRecognizer * edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)]; // viewController和SecondViewController的手势都由self管理
    edgePan.edges = edges;
    [view addGestureRecognizer:edgePan];
}

// 手势的监听方法
- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan{
    if(edgePan.state == UIGestureRecognizerStateBegan){
        if(edgePan.edges == UIRectEdgeRight){
            // present，避免重复，直接调用点击方法
            [self tomy];
        }else if(edgePan.edges == UIRectEdgeLeft){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
//    CGFloat progress = fabs([edgePan translationInView:[UIApplication sharedApplication].keyWindow].x / [UIApplication sharedApplication].keyWindow.bounds.size.width);// 有两个手势，所以这里计算百分比使用的是 KeyWindow
//    
//    if(edgePan.state == UIGestureRecognizerStateBegan){
//        self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
//        if(edgePan.edges == UIRectEdgeRight){
//            // present，避免重复，直接调用点击方法
//            [self tomy];
//        }else if(edgePan.edges == UIRectEdgeLeft){
//            [self dismissViewControllerAnimated:YES completion:^{
//            }];
//        }
//    }else if(edgePan.state == UIGestureRecognizerStateChanged){
//        [self.percentDrivenTransition updateInteractiveTransition:progress];
//    }else if(edgePan.state == UIGestureRecognizerStateCancelled || edgePan.state == UIGestureRecognizerStateEnded){
//        if(progress > 0.5){
//            [_percentDrivenTransition finishInteractiveTransition];
//        }else{
//            [_percentDrivenTransition cancelInteractiveTransition];
//        }
//        _percentDrivenTransition = nil;
//    }
}

// 百分比present
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    return _percentDrivenTransition;
}
// 百分比dismiss
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return _percentDrivenTransition;
}

-(void)initViews {
    
    //tabelview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.bounces = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 192*autoSizeScaleY)];
    
    self.topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 192*autoSizeScaleY)];
    self.topView.image = [UIImage imageNamed:@"pfhome_topbg"];
    self.topView.contentMode = UIViewContentModeScaleAspectFill;
    self.topView.clipsToBounds = YES;
    //头像
    self.headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(11*autoSizeScaleX,22*autoSizeScaleY,118*autoSizeScaleY,118*autoSizeScaleY)];
    self.headImgView.layer.masksToBounds =YES;
    self.headImgView.layer.cornerRadius = 118*autoSizeScaleY/2;
    self.headImgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self setHead];
    [self.topView addSubview:self.headImgView];
    //姓名
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(11*autoSizeScaleX, 172*autoSizeScaleY, 118*autoSizeScaleY, 100)];
    self.nameLab.textAlignment = NSTextAlignmentCenter;
    self.nameLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:16.0*autoSizeScaleY];
    self.nameLab.text = self.user.nickname;
    if (self.user.nickname.length == 2) {
        self.nameLab.text = [NSString stringWithFormat:@"%@    %@",[self.user.nickname substringToIndex:1],[self.user.nickname substringFromIndex:1]];
    }
    self.nameLab.frame = CGRectMake(11*autoSizeScaleX, 172*autoSizeScaleY-self.nameLab.font.capHeight-8, 118*autoSizeScaleY, self.nameLab.font.capHeight+8);
    self.nameLab.textColor = [UIColor colorWithHexString:@"162271"];
    self.nameLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.nameLab];
    
    //创建其他具体的Label
    
    [self createLabs];
    
    [self.head addSubview:self.topView];
    self.tableView.tableHeaderView = self.head;
    
    [self.tableView sendSubviewToBack:self.tableView.tableHeaderView];
    
    [self.view addSubview:self.tableView];
    
    if (self.isFirstUse == nil) {
        [self initLeadView];
    }else{
        [self setupRefresh];
    }
}

/**
 *  集成下拉刷新
 */
-(void)setupRefresh
{
    
    UIImage *loadimage =[UIImage sd_animatedGIFNamed:@"loading_120"];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData:)];
    // 设置普通状态的动画图片
    [header setImages:@[loadimage] forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:@[loadimage] forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:@[loadimage] forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView addSubview:header];
    
    [header beginRefreshing];
}


- (void)loadNewData:(MJRefreshGifHeader *)sender{
    
    CGFloat y = 0;
    
    //判断下拉刷新有没有加载
    for (UIView *item in self.tableView.subviews) {
        if ([item isKindOfClass:[MJRefreshGifHeader class]]) {
            y = item.frame.size.height;
            break;
        }
    }
    [self setHead];
    self.nameLab.text = self.user.nickname;
    if (self.user.nickname.length == 2) {
        self.nameLab.text = [NSString stringWithFormat:@"%@    %@",[self.user.nickname substringToIndex:1],[self.user.nickname substringFromIndex:1]];
    }
    
    self.pointFirstLab.text = [[NSString stringWithFormat:@"%.0f",self.user.userpoints] substringToIndex:1];
    CGSize pointFirstLabSize = [self.pointFirstLab boundingRectWithSize:CGSizeZero];
    self.pointFirstLab.frame = CGRectMake(152*autoSizeScaleX, 89*autoSizeScaleY-self.pointFirstLab.font.capHeight-4.5+y, pointFirstLabSize.width, self.pointFirstLab.font.capHeight+4.5);
    
    self.pointOtherLab.text = [NSString stringWithFormat:@"%.0f",self.user.userpoints].length == 1 ? @"" : [[NSString stringWithFormat:@"%.0f",self.user.userpoints] substringFromIndex:1];
    CGSize pointOtherLabSize = [self.pointOtherLab boundingRectWithSize:CGSizeZero];
    self.pointOtherLab.frame = CGRectMake(177*autoSizeScaleX, 89*autoSizeScaleY-self.pointOtherLab.font.capHeight-3+y, pointOtherLabSize.width, self.pointOtherLab.font.capHeight+3);
    
    
    ManagerTaskWebInterface *homeInterface = [[ManagerTaskWebInterface alloc] init];
    __unsafe_unretained typeof(self) weakself = self;
    NSDictionary *param = [homeInterface inboxObject:@[@(self.user.userid),@(0),@(self.user.usertype)]];//首页展示的都是新任务
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:homeInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSMutableArray *result = [homeInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            weakself.releaseAllCountLab.text = [NSString stringWithFormat:@""" / %@ 个",result[1]];
            weakself.releaseCountLab.text = [NSString stringWithFormat:@"%@",result[2]];
            weakself.payAllCountLab.text = [NSString stringWithFormat:@""" / %@ 个",result[3]];
            weakself.payCountLab.text = [NSString stringWithFormat:@"%@",result[4]];
            weakself.shAllCountLab.text = [NSString stringWithFormat:@""" / %@ 个",result[5]];
            weakself.shCountLab.text = [NSString stringWithFormat:@"%@",result[6]];
            [weakself layoutLabs];
            
            weakself.array = result[7];
            
            [weakself.tableView reloadData];
        }else{
            [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
        }
        
        [sender endRefreshing];
    } WithErrorCodeBlock:^(id errorCode) {
        [weakself.view makeToast:@"请求出错" duration:2.0 position:CSToastPositionCenter];
        [sender endRefreshing];
    } WithFailureBlock:^{
        [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
        [sender endRefreshing];
    }];
}






//加载引导相关的视图，只在第一次进入这个应用时加载一次
- (void)initLeadView{
    
    //做上不是本app不是第一次使用的标记
    [OperateNSUserDefault addUserDefaultWithKeyAndValue:@"isFirstUse" value:@"1"];
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
        [self setupRefresh];
        return;
    }
}


- (void)setHead{
    if (self.headimg == nil) {
        [self.headImgView setImage:defaultheadimage];
    }else{
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.headimg] placeholderImage:defaultheadimage];
    }
}

//创建其他labs
- (void)createLabs{
    //积分
    UILabel *pointTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(152*autoSizeScaleX, 22*autoSizeScaleY, 100, 100)];
    pointTitleLab.textAlignment = NSTextAlignmentLeft;
    pointTitleLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:10.5*autoSizeScaleY];
    pointTitleLab.text = @"我的积分";
    pointTitleLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize pointTitleLabSize = [pointTitleLab boundingRectWithSize:CGSizeZero];
    pointTitleLab.frame = CGRectMake(152*autoSizeScaleX, 22*autoSizeScaleY, pointTitleLabSize.width, pointTitleLabSize.height);
    pointTitleLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:pointTitleLab];
    //积分第一位
    self.pointFirstLab = [[UILabel alloc] initWithFrame:CGRectMake(152*autoSizeScaleX, 0, 100, 100)];
    self.pointFirstLab.textAlignment = NSTextAlignmentLeft;
    self.pointFirstLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:39*autoSizeScaleY];
    self.pointFirstLab.text = [[NSString stringWithFormat:@"%.0f",self.user.userpoints] substringToIndex:1];
    //    self.pointFirstLab.backgroundColor = [UIColor redColor];
    self.pointFirstLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize pointFirstLabSize = [self.pointFirstLab boundingRectWithSize:CGSizeZero];
    self.pointFirstLab.frame = CGRectMake(152*autoSizeScaleX, 89*autoSizeScaleY-self.pointFirstLab.font.capHeight-4.5, pointFirstLabSize.width, self.pointFirstLab.font.capHeight+4.5);
    self.pointFirstLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.pointFirstLab];
    //积分后几位
    self.pointOtherLab = [[UILabel alloc] initWithFrame:CGRectMake(174*autoSizeScaleX, 0, 100, 100)];
    self.pointOtherLab.textAlignment = NSTextAlignmentLeft;
    self.pointOtherLab.font = [UIFont fontWithName:@"DroidSansFallback" size:15*autoSizeScaleY];
    self.pointOtherLab.text = [NSString stringWithFormat:@"%.0f",self.user.userpoints].length == 1 ? @"" : [[NSString stringWithFormat:@"%.0f",self.user.userpoints] substringFromIndex:1];
    //    self.pointOtherLab.backgroundColor = [UIColor yellowColor];
    self.pointOtherLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize pointOtherLabSize = [self.pointOtherLab boundingRectWithSize:CGSizeZero];
    self.pointOtherLab.frame = CGRectMake(177*autoSizeScaleX, 89*autoSizeScaleY-self.pointOtherLab.font.capHeight-3, pointOtherLabSize.width, self.pointOtherLab.font.capHeight+3);
    self.pointOtherLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.pointOtherLab];
    
    //单位
    UILabel *pointUnitLab = [[UILabel alloc] initWithFrame:CGRectMake(208*autoSizeScaleX, 0, 100, 100)];
    pointUnitLab.textAlignment = NSTextAlignmentLeft;
    pointUnitLab.font = [UIFont fontWithName:@"DroidSansFallback" size:15*autoSizeScaleY];
    pointUnitLab.text = @"分";
    pointUnitLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize pointUnitLabSize = [pointUnitLab boundingRectWithSize:CGSizeZero];
    pointUnitLab.frame = CGRectMake(177*autoSizeScaleX+pointOtherLabSize.width+3, 89*autoSizeScaleY-pointUnitLab.font.capHeight-4, pointUnitLabSize.width, pointUnitLab.font.capHeight+4);
    pointUnitLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:pointUnitLab];
    //已领取
    UILabel *releaseTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(268*autoSizeScaleX, 22*autoSizeScaleY, 100, 100)];
    releaseTitleLab.textAlignment = NSTextAlignmentLeft;
    releaseTitleLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:10.5*autoSizeScaleY];
    releaseTitleLab.text = @"已领取";
    releaseTitleLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize releaseTitleLabSize = [releaseTitleLab boundingRectWithSize:CGSizeZero];
    releaseTitleLab.frame = CGRectMake(268*autoSizeScaleX, 22*autoSizeScaleY, releaseTitleLabSize.width, releaseTitleLabSize.height);
    releaseTitleLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:releaseTitleLab];
    //已领取个数 首字母
    self.releaseCountLab = [[UILabel alloc] initWithFrame:CGRectMake(268*autoSizeScaleX, 0, 100, 100)];
    self.releaseCountLab.textAlignment = NSTextAlignmentLeft;
    self.releaseCountLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:39*autoSizeScaleY];
    self.releaseCountLab.text = @"0";
    self.releaseCountLab.textColor = [UIColor colorWithHexString:@"162271"];
//    CGSize releaseCountLabSize = [self.releaseCountLab boundingRectWithSize:CGSizeZero];
//    self.releaseCountLab.frame = CGRectMake(268*autoSizeScaleX, 89*autoSizeScaleY-self.releaseCountLab.font.capHeight-3, releaseCountLabSize.width, self.releaseCountLab.font.capHeight+3);
    self.releaseCountLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.releaseCountLab];
    //已领取个数其他字母 + / + 已领取总个数
    self.releaseAllCountLab = [[UILabel alloc] initWithFrame:CGRectMake(292*autoSizeScaleX, 0, 100, 100)];
    self.releaseAllCountLab.textAlignment = NSTextAlignmentLeft;
    self.releaseAllCountLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:15*autoSizeScaleY];
    self.releaseAllCountLab.text = @""" / 0 个";
    self.releaseAllCountLab.textColor = [UIColor colorWithHexString:@"162271"];
//    CGSize releaseAllCountLabSize = [self.releaseAllCountLab boundingRectWithSize:CGSizeZero];
//    self.releaseAllCountLab.frame = CGRectMake(292*autoSizeScaleX, 89*autoSizeScaleY-self.releaseAllCountLab.font.capHeight-3, releaseAllCountLabSize.width, self.releaseAllCountLab.font.capHeight+3);
    self.releaseAllCountLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.releaseAllCountLab];
    //待审核
    UILabel *shTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(152*autoSizeScaleX, 106.5*autoSizeScaleY, 100, 100)];
    shTitleLab.textAlignment = NSTextAlignmentLeft;
    shTitleLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:10.5*autoSizeScaleY];
    shTitleLab.text = @"待审核";
    shTitleLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize shTitleLabSize = [shTitleLab boundingRectWithSize:CGSizeZero];
    shTitleLab.frame = CGRectMake(152*autoSizeScaleX, 106.5*autoSizeScaleY, shTitleLabSize.width, shTitleLabSize.height);
    shTitleLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:shTitleLab];
    //待审核 首字母
    self.shCountLab = [[UILabel alloc] initWithFrame:CGRectMake(152*autoSizeScaleX, 0, 100, 100)];
    self.shCountLab.textAlignment = NSTextAlignmentLeft;
    self.shCountLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:39*autoSizeScaleY];
    self.shCountLab.text = @"0";
    self.shCountLab.textColor = [UIColor colorWithHexString:@"162271"];
//    CGSize shCountLabSize = [self.shCountLab boundingRectWithSize:CGSizeZero];
//    self.shCountLab.frame = CGRectMake(152*autoSizeScaleX, 172*autoSizeScaleY-self.shCountLab.font.capHeight-3, shCountLabSize.width, self.shCountLab.font.capHeight+3);
    self.shCountLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.shCountLab];
    //待审核个数其他字母 + / + 待审核总个数
    self.shAllCountLab = [[UILabel alloc] initWithFrame:CGRectMake(174*autoSizeScaleX, 0, 100, 100)];
    self.shAllCountLab.textAlignment = NSTextAlignmentLeft;
    self.shAllCountLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:15*autoSizeScaleY];
    self.shAllCountLab.text = @""" / 0 个";
    self.shAllCountLab.textColor = [UIColor colorWithHexString:@"162271"];
//    CGSize shAllCountLabSize = [self.shAllCountLab boundingRectWithSize:CGSizeZero];
//    self.shAllCountLab.frame = CGRectMake(174*autoSizeScaleX, 172*autoSizeScaleY-self.shAllCountLab.font.capHeight-3, shAllCountLabSize.width, self.shAllCountLab.font.capHeight+3);
    self.shAllCountLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.shAllCountLab];
    //已支付
    UILabel *payTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(268*autoSizeScaleX, 106.5*autoSizeScaleY, 100, 100)];
    payTitleLab.textAlignment = NSTextAlignmentLeft;
    payTitleLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:10.5*autoSizeScaleY];
    payTitleLab.text = @"已支付";
    payTitleLab.textColor = [UIColor colorWithHexString:@"162271"];
    CGSize payTitleLabSize = [payTitleLab boundingRectWithSize:CGSizeZero];
    payTitleLab.frame = CGRectMake(268*autoSizeScaleX, 106.5*autoSizeScaleY, payTitleLabSize.width, payTitleLabSize.height);
    payTitleLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:payTitleLab];
    //已支付个数 首字母
    self.payCountLab = [[UILabel alloc] initWithFrame:CGRectMake(268*autoSizeScaleX, 0, 100, 100)];
    self.payCountLab.textAlignment = NSTextAlignmentLeft;
    self.payCountLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:39*autoSizeScaleY];
    self.payCountLab.text = @"0";
    self.payCountLab.textColor = [UIColor colorWithHexString:@"162271"];
//    CGSize payCountLabSize = [self.payCountLab boundingRectWithSize:CGSizeZero];
//    self.payCountLab.frame = CGRectMake(268*autoSizeScaleX, 172*autoSizeScaleY-self.payCountLab.font.capHeight-3, payCountLabSize.width, self.payCountLab.font.capHeight+3);
    self.payCountLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.payCountLab];
    //已支付个数其他字母 + / 已支付总个数
    self.payAllCountLab = [[UILabel alloc] initWithFrame:CGRectMake(292*autoSizeScaleX, 0, 100, 100)];
    self.payAllCountLab.textAlignment = NSTextAlignmentLeft;
    self.payAllCountLab.font = [UIFont fontWithName:@"Droid Sans Fallback" size:15*autoSizeScaleY];
    self.payAllCountLab.text = @""" / 0 个";
    self.payAllCountLab.textColor = [UIColor colorWithHexString:@"162271"];
//    CGSize payAllCountLabSize = [self.payAllCountLab boundingRectWithSize:CGSizeZero];
//    self.payAllCountLab.frame = CGRectMake(292*autoSizeScaleX, 172*autoSizeScaleY-self.payAllCountLab.font.capHeight-3, payAllCountLabSize.width, self.payAllCountLab.font.capHeight+3);
    self.payAllCountLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.payAllCountLab];
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 191.5*autoSizeScaleY, 345*autoSizeScaleX, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"162271"];
    lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:lineView];
    
    
    //给labels集中布局，（在赋值之后）
    [self layoutLabs];
    
    [self createGesture];
}


//给labels集中布局，（在赋值之后）
- (void)layoutLabs{
    
    CGFloat y = 0;
    
    //判断下拉刷新有没有加载
    for (UIView *item in self.tableView.subviews) {
        if ([item isKindOfClass:[MJRefreshGifHeader class]]) {
            y = item.frame.size.height;
            break;
        }
    }
    
    //已发布个数 首字母
    CGSize releaseCountLabSize = [self.releaseCountLab boundingRectWithSize:CGSizeZero];
    self.releaseCountLab.frame = CGRectMake(268*autoSizeScaleX, 89*autoSizeScaleY-self.releaseCountLab.font.capHeight-4.5+y, releaseCountLabSize.width, self.releaseCountLab.font.capHeight+4.5);
    //已发布个数其他字母 + / + 已领取总个数
    CGSize releaseAllCountLabSize = [self.releaseAllCountLab boundingRectWithSize:CGSizeZero];
    self.releaseAllCountLab.frame = CGRectMake(292*autoSizeScaleX, 89*autoSizeScaleY-self.releaseAllCountLab.font.capHeight-3+y, releaseAllCountLabSize.width, self.releaseAllCountLab.font.capHeight+3);
    //待审核 首字母
    CGSize shCountLabSize = [self.shCountLab boundingRectWithSize:CGSizeZero];
    self.shCountLab.frame = CGRectMake(152*autoSizeScaleX, (172)*autoSizeScaleY-self.shCountLab.font.capHeight-4.5+y, shCountLabSize.width, self.shCountLab.font.capHeight+4.5);
    //待审核个数其他字母 + / + 待审核总个数
    CGSize shAllCountLabSize = [self.shAllCountLab boundingRectWithSize:CGSizeZero];
    self.shAllCountLab.frame = CGRectMake(174*autoSizeScaleX, 172*autoSizeScaleY-self.shAllCountLab.font.capHeight-3+y, shAllCountLabSize.width, self.shAllCountLab.font.capHeight+3);;
    //已支付个数 首字母
    CGSize payCountLabSize = [self.payCountLab boundingRectWithSize:CGSizeZero];
    self.payCountLab.frame = CGRectMake(268*autoSizeScaleX, 172*autoSizeScaleY-self.payCountLab.font.capHeight-4.5+y, payCountLabSize.width, self.payCountLab.font.capHeight+4.5);
    //已支付个数其他字母 + / 已支付总个数
    CGSize payAllCountLabSize = [self.payAllCountLab boundingRectWithSize:CGSizeZero];
    self.payAllCountLab.frame = CGRectMake(292*autoSizeScaleX, 172*autoSizeScaleY-self.payAllCountLab.font.capHeight-3+y, payAllCountLabSize.width, self.payAllCountLab.font.capHeight+3);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//        CGFloat f = totalOffset / imageHeight;
        
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
    viewController.task = selTask;
    viewController.flag = 0;
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

     }else if([identifier isEqualToString:@"tomissiondetail"]){
         ManagerMissionDetailViewController *viewController = (ManagerMissionDetailViewController *)segue.destinationViewController;
         viewController.task = selTask;
     }
 }



-(void)toMyMission {
    [self performSegueWithIdentifier:@"tomanagermission" sender:nil];
}

-(void)toMyProfile {
    
    
   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"me" bundle:nil];
    MeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"me"];
    [self.navigationController pushViewController:viewController animated:YES];
}


//创建手势，头像跳至修改个人资料，积分跳至我的积分，其他跳至任务历史
- (void)createGesture{
    
    self.topView.userInteractionEnabled = YES;
    self.headImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totap1:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totap2:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totap3:)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totap3:)];
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totap3:)];
    
    [self.headImgView addGestureRecognizer:tap1];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(152*autoSizeScaleX, 22*autoSizeScaleY, 100*autoSizeScaleX, 77*autoSizeScaleY)];
    view1.backgroundColor = [UIColor clearColor];
    [view1 addGestureRecognizer:tap2];
    [self.topView addSubview:view1];
    view1.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(268*autoSizeScaleX,22*autoSizeScaleY, 100*autoSizeScaleX, 77*autoSizeScaleY)];
    view2.backgroundColor = [UIColor clearColor];
    [view2 addGestureRecognizer:tap3];
    [self.topView addSubview:view2];
    view2.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(152*autoSizeScaleX, 106.5*autoSizeScaleY, 100*autoSizeScaleX, 77*autoSizeScaleY)];
    view3.backgroundColor = [UIColor clearColor];
    [view3 addGestureRecognizer:tap4];
    [self.topView addSubview:view3];
    view3.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(268*autoSizeScaleX,106.5*autoSizeScaleY, 100*autoSizeScaleX, 77*autoSizeScaleY)];
    view4.backgroundColor = [UIColor clearColor];
    [view4 addGestureRecognizer:tap5];
    [self.topView addSubview:view4];
    view4.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
}

- (void)totap1:(UITapGestureRecognizer *)sender{
    UIStoryboard *me = [UIStoryboard storyboardWithName:@"me" bundle:nil];
    MeProfileViewController *profileVC = [me instantiateViewControllerWithIdentifier:@"meprofile"];
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)totap2:(UITapGestureRecognizer *)sender{
    UIStoryboard *me = [UIStoryboard storyboardWithName:@"me" bundle:nil];
    MePointViewController *pointVC = [me instantiateViewControllerWithIdentifier:@"mepoint"];
    [self.navigationController pushViewController:pointVC animated:YES];
}
- (void)totap3:(UITapGestureRecognizer *)sender{
   [self performSegueWithIdentifier:@"tomanagermission" sender:nil];
}
@end
