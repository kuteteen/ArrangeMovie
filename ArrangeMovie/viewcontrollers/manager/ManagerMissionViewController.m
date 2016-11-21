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

#define Width [UIScreen mainScreen].bounds.size.width

@interface ManagerMissionViewController ()<LFLUISegmentedControlDelegate,UIScrollViewDelegate,ManagerMissionPageViewControllerDelegate,UITableViewDelegate,UITableViewDataSource> {
    LFLUISegmentedControl *segmentControl;
    CKAlertViewController *ckAlertVC;
    
    
    UIPageViewController *pageViewController;
    NSMutableArray *viewControllers;
}
@property (weak, nonatomic) IBOutlet UIView *segmentView;
//@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//@property (strong,nonatomic) NSMutableArray *dataArray;//所有数据
@property (strong,nonatomic) NSMutableArray *array;//显示用的数据

///页数
@property (nonatomic, assign) NSInteger pageCount;
///第N页
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation ManagerMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"查看任务";
    
    segmentControl = [[LFLUISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, Width, 50)];
    segmentControl.delegate = self;
    segmentControl.titleFont = [UIFont fontWithName:@"DroidSansFallback" size:16.f];
    segmentControl.titleColor = [UIColor colorWithHexString:@"162271"];
    segmentControl.selectFont = [UIFont fontWithName:@"DroidSansFallback" size:16.f];
    segmentControl.selectColor = [UIColor colorWithHexString:@"162271"];
    segmentControl.backgroundColor = [UIColor whiteColor];
    segmentControl.lineColor = [UIColor colorWithHexString:@"162271"];
    [segmentControl AddSegumentArray:@[@"新任务",@"已领取",@"审核中",@"已完成"]];
    [self.segmentView addSubview:segmentControl];
    
    self.scrollView.delegate = self;
    
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
        
        [self.scrollView addSubview:tableView];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

-(void)checkMission:(ManagerMissionTableViewCell *)cell {
    //跳转到详情
    //    [self performSegueWithIdentifier:@"metomissiondetail" sender:nil];
    [self startAnimationForIndexPath:cell];
}

#pragma mark animation
-(void)startAnimationForIndexPath:(ManagerMissionTableViewCell *)cell{
    
    ManagerMissionDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"managermissiondetail"];
    viewController.user = self.user;
    viewController.task = cell.task;
    
    CGRect originRect = cell.imgRect;
    //    CGRect
    [((EMINavigationController *)self.navigationController) pushViewController:viewController withImageView:cell.postImgView originRect:originRect desRect:CGRectMake(15, 84, 60, 65)];
}

-(void)toDelTask:(id)sender {
    AMAlertView *amalertview = [[AMAlertView alloc] initWithconsFrame:CGRectMake(45, (screenHeight-191)/2, screenWidth-90, 191)];
    [amalertview setTitle:@"删除任务"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, amalertview.frame.size.width-30, 16)];
    label.text = @"确认是否删除这个任务?";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"15151b"];
    label.font = [UIFont systemFontOfSize:17.f];
    [amalertview.contentView addSubview:label];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 76, amalertview.frame.size.width-30, 40)];
    [sureBtn setTitle:@"确认删除" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 4;
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"557dcf"];
    [sureBtn addTarget:self action:@selector(delTask:) forControlEvents:UIControlEventTouchUpInside];
    [amalertview.contentView addSubview:sureBtn];
    
    ckAlertVC = [[CKAlertViewController alloc] initWithAlertView:amalertview];
    [self presentViewController:ckAlertVC animated:NO completion:nil];
}
-(NSMutableArray *)array {
    if(!_array){
        _array = [[NSMutableArray alloc] init];
        for(int i = 0;i<4;i++){
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
            task.dn = @"18252495961";
            task.gradename = @"A级影院";
            [_array addObject:task];
        }
    }
    return _array;
}

#pragma mark - UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManagerMissionTableViewCell *cell = [ManagerMissionTableViewCell cellWithTableView:tableView];
    UIView *backview = [[UIView alloc] init];
    backview.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    cell.selectedBackgroundView = backview;
    
    [cell setValue:self.array[indexPath.row]];
    
    if(self.pageIndex==2){
        cell.flagLabel.hidden = NO;
        cell.delTaskBtn.hidden = YES;
    }else{
        cell.flagLabel.hidden = YES;
        cell.delTaskBtn.hidden = NO;
    }
    
    cell.delTaskBtn.tag = 1000+indexPath.row;
    
    [cell.delTaskBtn addTarget:self action:@selector(toDelTask:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)delTask:(id)sender {
    [ckAlertVC dismissViewControllerAnimated:NO completion:nil];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    ///X方向上的滑动距离
    CGFloat offSetX = scrollView.contentOffset.x;
    
    segmentControl.buttonDown.center = CGPointMake(screenWidth/(_pageCount*2) + offSetX/_pageCount, segmentControl.buttonDown.center.y);
}


@end
