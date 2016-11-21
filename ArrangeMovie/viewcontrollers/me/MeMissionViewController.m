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
///第N页
@property (nonatomic, assign) NSInteger pageIndex;

//@property (strong,nonatomic) NSMutableArray *dataArray;//所有数据
@property (strong,nonatomic) NSMutableArray *array;//显示用的数据

@end

@implementation MeMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"查看任务";
    self.scrollView.delegate = self;
    
    segmentControl = [[LFLUISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, Width, 50)];
    segmentControl.delegate = self;
    segmentControl.titleFont = [UIFont fontWithName:@"Droid Sans Fallback" size:16.f];
    segmentControl.selectFont = [UIFont fontWithName:@"Droid Sans Fallback" size:16.f];
    segmentControl.titleColor = [UIColor colorWithHexString:@"162271"];
    segmentControl.selectColor = [UIColor colorWithHexString:@"162271"];
    segmentControl.backgroundColor = [UIColor whiteColor];
    segmentControl.lineColor = [UIColor colorWithHexString:@"162271"];
    [segmentControl AddSegumentArray:@[@"全部",@"已发布",@"待审核",@"已支付"]];
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
        
        [self.scrollView addSubview:tableView];
    }
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
    viewController.user = self.user;
    viewController.task = cell.task;
    
    CGRect originRect = cell.imgRect;
//    CGRect 
    [((EMINavigationController *)self.navigationController) pushViewController:viewController withImageView:cell.postImgView originRect:originRect desRect:CGRectMake(15, 84, 60, 65)];
}

#pragma mark - LFLUISegmentedControl delegate
-(void)uisegumentSelectionChange:(NSInteger)selection {
    NSLog(@"滑动到第%ld页",(long)selection);
    //reloadData
//    self.pageIndex = selection;
//    [self setContentViewController:selection];
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
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeMissionTableViewCell *cell = [MeMissionTableViewCell cellWithTableView:tableView];
    UIView *backview = [[UIView alloc] init];
    backview.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    cell.selectedBackgroundView = backview;
    
    [cell setValue:self.array[indexPath.row]];
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    ///X方向上的滑动距离
    CGFloat offSetX = scrollView.contentOffset.x;
    
    segmentControl.buttonDown.center = CGPointMake(screenWidth/(_pageCount*2) + offSetX/_pageCount, segmentControl.buttonDown.center.y);
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
