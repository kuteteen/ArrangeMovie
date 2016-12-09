//
//  ManagerMissionViewController.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/10/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ManagerMissionViewController.h"
#import "LFLUISegmentedControl.h"
#import "ManagerMissionTableViewCell.h"
#import "ManagerMissionDetailViewController.h"
#import "AMAlertView.h"
#import "CKAlertViewController.h"
#import "ManagerMissionPageViewController.h"
#import "EMINavigationController.h"
#import "UIScrollView+AllowPanGestureEventPass.h"
#import "UIImage+GIF.h"
#import "MJRefreshGifHeader.h"
#import "ManagerTaskWebInterface.h"
#import "SCHttpOperation.h"


#define Width [UIScreen mainScreen].bounds.size.width

@interface ManagerMissionViewController ()<LFLUISegmentedControlDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource> {
    LFLUISegmentedControl *segmentControl;
    CKAlertViewController *ckAlertVC;
    
    
    UIPageViewController *pageViewController;
    NSMutableArray *viewControllers;
}
@property (weak, nonatomic) IBOutlet UIView *segmentView;
//@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//@property (strong,nonatomic) NSMutableArray *dataArray;//所有数据
@property (strong,nonatomic) NSMutableArray <NSArray  <Task *> *> *array;//显示用的数据

///页数
@property (nonatomic, assign) NSInteger pageCount;
///第N页
@property (nonatomic, assign) NSInteger pageIndex;


@end

@implementation ManagerMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.array = [[NSMutableArray alloc] initWithArray:@[@[],@[],@[],@[]]];//存放四个Task数组
    
    self.title = @"查看任务";
    
    segmentControl = [[LFLUISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, Width, 50)];
    segmentControl.delegate = self;
    segmentControl.titleFont = [UIFont fontWithName:@"Droid Sans Fallback" size:16.f];
    segmentControl.titleColor = [UIColor colorWithHexString:@"162271"];
    segmentControl.selectFont = [UIFont fontWithName:@"Droid Sans Fallback" size:16.f];
    segmentControl.selectColor = [UIColor colorWithHexString:@"162271"];
    segmentControl.backgroundColor = [UIColor whiteColor];
    segmentControl.lineColor = [UIColor colorWithHexString:@"162271"];
    [segmentControl AddSegumentArray:@[@"新任务",@"已领取",@"审核中",@"已完成"]];
    [self.segmentView addSubview:segmentControl];
    self.scrollView.tag = 0;
    self.scrollView.delegate = self;
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:[((EMINavigationController *)(self.navigationController)) screenEdgePanGestureRecognizer]];//在navigationcontroller自带的滑动返回失败后，才去执行scrollview的滑动
    _pageCount = 4;
    if(!viewControllers){
        viewControllers = [[NSMutableArray alloc] initWithCapacity:self.pageCount];
    }
//    for(NSInteger i = 0;i<self.pageCount;i++){
//        [self setContentViewController:i];
//    }
    for (NSInteger i = 0; i<_pageCount; i++) {
        UITableView *tableView  = [[UITableView alloc] initWithFrame:CGRectMake(i*screenWidth, 0, screenWidth, self.scrollView.frame.size.height) style:UITableViewStylePlain];
        
        tableView.tag = 1000+i;
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        
        
        //设置下拉刷新和上拉加载
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
        header.tag = i;
        
        
        tableView.mj_header = header;
        if (i == 0) {
            [tableView.mj_header beginRefreshing];
        }
        
        [self.tableViewArray addObject:tableView];
        [self.scrollView addSubview:tableView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNewData:(MJRefreshGifHeader *)sender {
    ManagerTaskWebInterface *homeInterface = [[ManagerTaskWebInterface alloc] init];
    __unsafe_unretained typeof(self) weakself = self;
    NSDictionary *param = [homeInterface inboxObject:@[@(self.user.userid),@(sender.tag),@(self.user.usertype)]];//首页展示的都是新任务
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:homeInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSMutableArray *result = [homeInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            
            weakself.array[sender.tag]  = result[7];
            
            [weakself.tableViewArray[sender.tag] reloadData];
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


//-(void)setContentViewController:(NSInteger)pageIndex {
//    ManagerMissionPageViewController *startingViewController = [self viewControllerAtIndex:pageIndex];
//    
//     NSLog(@"pageContentViewController宽度：%f",startingViewController.view.frame.size.width);
//    [self.scrollView addSubview:startingViewController.view];
//    [viewControllers addObject:startingViewController];
//}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(self.pageCount*screenWidth, 0);
    [self.view layoutSubviews];
    
    
    for (UIView *view in self.scrollView.subviews) {
        NSLog(@"childView宽度：%f",view.frame.size.width);
    }
}
#pragma mark - UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 144.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //任务详情
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    NSInteger tag = tableView.tag-1000;
    
    ManagerMissionTableViewCell *cell = (ManagerMissionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    ///cell在tableView的位置
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    
    //cell在scrollview中的位置
    CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
    CGRect originRect = CGRectMake(rect.origin.x+15-screenWidth*tag, rect.origin.y+63+50+64, cell.postImgView.frame.size.width, cell.postImgView.frame.size.height);
    cell.imgRect = originRect;
    [self startAnimationForIndexPath:cell];
    //跳转到任务详情
    //    [self performSegueWithIdentifier:@"tomanagermissiondetail" sender:nil];
}


#pragma mark - LFLUISegmentedControl delegate
-(void)uisegumentSelectionChange:(NSInteger)selection {
    NSLog(@"滑动到第%ld页",(long)selection);
    //reloadData
    self.pageIndex = selection;
    //刷新数据
    [self.tableViewArray[self.pageIndex].mj_header beginRefreshing];
}



#pragma mark animation
-(void)startAnimationForIndexPath:(ManagerMissionTableViewCell *)cell{
    
    ManagerMissionDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"managermissiondetail"];
    viewController.task = cell.task;
    viewController.flag = self.pageIndex;
    CGRect originRect = cell.imgRect;
    //    CGRect
    [((EMINavigationController *)self.navigationController) pushViewController:viewController withImageView:cell.postImgView originRect:originRect desRect:CGRectMake(15, 84, 60, 65)];
}



#pragma mark - UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array[tableView.tag-1000].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManagerMissionTableViewCell *cell = [ManagerMissionTableViewCell cellWithTableView:tableView];
    UIView *backview = [[UIView alloc] init];
    backview.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    cell.selectedBackgroundView = backview;
    cell.viewController = self;
    cell.pageIndex = (int)(tableView.tag-1000);
    [cell setValue:self.array[tableView.tag-1000][indexPath.row]];
    
    if(tableView.tag-1000==2){
        cell.flagLabel.hidden = NO;
        cell.delTaskBtn.hidden = YES;
    }else if(tableView.tag-1000==1){
        cell.flagLabel.hidden = YES;
        cell.delTaskBtn.hidden = NO;
    }else{
        cell.flagLabel.hidden = YES;
        cell.delTaskBtn.hidden = YES;
    }
    return cell;
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 0) {
        ///X方向上的滑动距离
        CGFloat offSetX = scrollView.contentOffset.x;
        
        segmentControl.buttonDown.center = CGPointMake(screenWidth/(_pageCount*2) + offSetX/_pageCount, segmentControl.buttonDown.center.y);
    }
    
}
//停止滑动了
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 0) {
        NSInteger count = (int)(scrollView.contentOffset.x/screenWidth);
        [segmentControl selectTheSegument:count];
    }
}

@end
