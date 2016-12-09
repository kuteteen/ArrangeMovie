//
//  MeMissionViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeMissionViewController.h"
#import "LFLUISegmentedControl.h"
#import "MeMissionTableViewCell.h"
//#import "MeMissionPageViewController.h"
#import "MeMissionDetailViewController.h"
#import "EMINavigationController.h"
#import "UIScrollView+AllowPanGestureEventPass.h"
#import "MJRefreshGifHeader.h"
#import "UIImage+GIF.h"
#import "MJRefreshBackGifFooter.h"
#import "TaskHistoryWebInterface.h"
#import "SCHttpOperation.h"

#define Width [UIScreen mainScreen].bounds.size.width

@interface MeMissionViewController ()<LFLUISegmentedControlDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate> {
    LFLUISegmentedControl *segmentControl;
    
    UIPageViewController *pageViewController;
    
    NSMutableArray *viewControllers;
    
    
//    MeMissionPageViewController *missionPageController;
}
@property (weak, nonatomic) IBOutlet UIView *segmentView;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


///页数
@property (nonatomic, assign) NSInteger pageCount;
///左右第几页
@property (nonatomic, assign) NSInteger pageIndex;//同时也可代表taskstatus

//上下分页加载数据
@property (nonatomic, assign) NSInteger currentPage;

@property (strong,nonatomic) NSMutableArray <NSArray  <Task *> *> *array;//显示用的数据


@end

@implementation MeMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.array = [[NSMutableArray alloc] initWithArray:@[@[],@[],@[],@[]]];//存放四个Task数组
    self.title = @"查看任务";
    self.scrollView.delegate = self;
    self.scrollView.tag = 0;
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:[((EMINavigationController *)(self.navigationController)) screenEdgePanGestureRecognizer]];//在navigationcontroller自带的滑动返回失败后，才去执行scrollview的滑动
    segmentControl = [[LFLUISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, Width, 50)];
    segmentControl.delegate = self;
    segmentControl.titleFont = [UIFont fontWithName:@"Droid Sans Fallback" size:16.f];
    segmentControl.selectFont = [UIFont fontWithName:@"Droid Sans Fallback" size:16.f];
    segmentControl.titleColor = [UIColor colorWithHexString:@"162271"];
    segmentControl.selectColor = [UIColor colorWithHexString:@"162271"];
    segmentControl.backgroundColor = [UIColor whiteColor];
    segmentControl.lineColor = [UIColor colorWithHexString:@"162271"];
    [segmentControl AddSegumentArray:@[@"全部",@"待审核",@"已发布",@"已支付"]];
    [self.segmentView addSubview:segmentControl];
    
    pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageviewcontroller"];
    self.pageCount = 4;
    
//    pageViewController.delegate = self;
//    pageViewController.dataSource = self;
//    [self setContentViewController:0];
//    pageViewController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
//    [self addChildViewController:pageViewController];
//    [self.contentView addSubview:pageViewController.view];
//    [pageViewController didMoveToParentViewController:self];
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
        
        MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];
        // 设置普通状态的动画图片
        [footer setImages:@[loadimage] forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [footer setImages:@[loadimage] forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [footer setImages:@[loadimage] forState:MJRefreshStateRefreshing];
        // 隐藏时间
        footer.stateLabel.hidden = YES;
        footer.tag = i;
        tableView.mj_header = header;
        if (i == 0) {
            [tableView.mj_header beginRefreshing];
        }
        
        
        tableView.mj_footer = footer;
        [self.tableViewArray addObject:tableView];
        [self.scrollView addSubview:tableView];
    }
    
    
    
}

- (void)loadNewData:(MJRefreshGifHeader *)sender {
    self.currentPage = 0;
    __unsafe_unretained __typeof(self) weakSelf = self;
    TaskHistoryWebInterface *taskhisInterface = [[TaskHistoryWebInterface alloc] init];
    NSDictionary *param = [taskhisInterface inboxObject:@[@(self.user.userid),@(sender.tag),@(self.currentPage),@(self.user.usertype)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:taskhisInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [taskhisInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            weakSelf.array[sender.tag] = result[1];
            [weakSelf.tableViewArray[sender.tag] reloadData];
        }else{
            [weakSelf.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
        }
        [sender endRefreshing];
    } WithErrorCodeBlock:^(id errorCode) {
        [weakSelf.view makeToast:@"请求错误" duration:2.0 position:CSToastPositionCenter];
        [sender endRefreshing];
    } WithFailureBlock:^{
        [weakSelf.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
        [sender endRefreshing];
    }];
}

- (void)loadMoreData:(MJRefreshBackGifFooter *)sender {
    self.currentPage ++;
    __unsafe_unretained __typeof(self) weakSelf = self;
    TaskHistoryWebInterface *taskhisInterface = [[TaskHistoryWebInterface alloc] init];
    NSDictionary *param = [taskhisInterface inboxObject:@[@(self.user.userid),@(sender.tag),@(self.currentPage),@(self.user.usertype)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:taskhisInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [taskhisInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            NSArray *countArray = result[1];
            if (countArray.count > 0) {
                weakSelf.array[sender.tag] = countArray;
                [weakSelf.tableViewArray[sender.tag] reloadData];
                [sender endRefreshing];
            }else{
                weakSelf.currentPage--;
                [sender endRefreshingWithNoMoreData];
            }
            
        }else{
            weakSelf.currentPage--;
            [weakSelf.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
            [sender endRefreshing];
        }
        [sender endRefreshing];
    } WithErrorCodeBlock:^(id errorCode) {
        weakSelf.currentPage--;
        [weakSelf.view makeToast:@"请求错误" duration:2.0 position:CSToastPositionCenter];
        [sender endRefreshing];
    } WithFailureBlock:^{
        weakSelf.currentPage--;
        [weakSelf.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
        [sender endRefreshing];
    }];
    
    
}


- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(self.pageCount*screenWidth, 0);
    [self.view layoutSubviews];
    
    
    for (UIView *view in self.scrollView.subviews) {
        NSLog(@"childView宽度：%f",view.frame.size.width);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark animation
-(void)startAnimationForIndexPath:(MeMissionTableViewCell *)cell{
    
    MeMissionDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"memissiondetail"];
    viewController.task = cell.task;
    
    CGRect originRect = cell.imgRect;
//    CGRect 
    [((EMINavigationController *)self.navigationController) pushViewController:viewController withImageView:cell.postImgView originRect:originRect desRect:CGRectMake(15, 84, 60, 65)];
}

#pragma mark - LFLUISegmentedControl delegate
-(void)uisegumentSelectionChange:(NSInteger)selection {
    NSLog(@"滑动到第%ld页",(long)selection);
    //reloadData
    self.pageIndex = selection;
    //刷新数据
    [self.tableViewArray[self.pageIndex].mj_header beginRefreshing];
}



#pragma mark - UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 144.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //任务详情
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    NSInteger tag = tableView.tag-1000;
    
    MeMissionTableViewCell *cell = (MeMissionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    ///cell在tableView的位置
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    
    //cell在viewController中的位置
    CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
    CGRect originRect = CGRectMake(rect.origin.x+15-screenWidth*tag, rect.origin.y+63+50+64, cell.postImgView.frame.size.width, cell.postImgView.frame.size.height);
    cell.imgRect = originRect;
    [self startAnimationForIndexPath:cell];
    //    [self performSegueWithIdentifier:@"metomissiondetail" sender:nil];
}

#pragma mark - UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array[tableView.tag-1000].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeMissionTableViewCell *cell = [MeMissionTableViewCell cellWithTableView:tableView];
    UIView *backview = [[UIView alloc] init];
    backview.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    cell.selectedBackgroundView = backview;
    cell.viewController = self;
    cell.pageIndex = (int)(tableView.tag-1000);
    [cell setValue:self.array[tableView.tag-1000][indexPath.row]];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
