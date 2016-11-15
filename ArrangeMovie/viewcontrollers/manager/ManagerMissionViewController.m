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

@interface ManagerMissionViewController ()<LFLUISegmentedControlDelegate,UIScrollViewDelegate,ManagerMissionPageViewControllerDelegate> {
    LFLUISegmentedControl *segmentControl;
    CKAlertViewController *ckAlertVC;
    
    
    UIPageViewController *pageViewController;
    NSMutableArray *viewControllers;
}
@property (weak, nonatomic) IBOutlet UIView *segmentView;
//@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//@property (strong,nonatomic) NSMutableArray *dataArray;//所有数据
//@property (strong,nonatomic) NSMutableArray *array;//显示用的数据

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
    segmentControl.titleFont = [UIFont systemFontOfSize:16.f];
    segmentControl.titleColor = [UIColor colorWithHexString:@"162271"];
    segmentControl.selectFont = [UIFont systemFontOfSize:16.f];
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
    for(NSInteger i = 0;i<self.pageCount;i++){
        [self setContentViewController:i];
    }
    self.scrollView.contentSize = CGSizeMake(self.pageCount*screenWidth, 0);
//    pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"managerpageviewcontroller"];
//    self.pageCount = 4;
//    
//    pageViewController.delegate = self;
//    pageViewController.dataSource = self;
//    [self setContentViewController:0];
//    pageViewController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
//    [self addChildViewController:pageViewController];
//    [self.contentView addSubview:pageViewController.view];
//    [pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setContentViewController:(NSInteger)pageIndex {
    ManagerMissionPageViewController *startingViewController = [self viewControllerAtIndex:pageIndex];
    [self.scrollView addSubview:startingViewController.view];
    [viewControllers addObject:startingViewController];
}

-(ManagerMissionPageViewController *)viewControllerAtIndex:(NSInteger)index {
    if(index>=self.pageCount) {
        return nil;
    }
    ManagerMissionPageViewController *pageContentViewController;
    pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"managermissionpagecontent"];
    pageContentViewController.pageIndex = index;
    pageContentViewController.delegate = self;
    
    pageContentViewController.view.frame = CGRectMake(index*screenWidth, 0, screenWidth, self.scrollView.frame.size.height);
    [pageContentViewController viewWillAppear:YES];
    return pageContentViewController;
}

//#pragma mark -UIPageViewControllerDataSource
//
//-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
//    ManagerMissionPageViewController *vc = (ManagerMissionPageViewController *)viewController;
//    self.pageIndex = vc.pageIndex;
//    if(self.pageIndex<self.pageCount-1){
//        self.pageIndex++;
//        return [viewControllers objectAtIndex:self.pageIndex];
//    }else{
//        return nil;
//    }
//}
//
//-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
//    ManagerMissionPageViewController *vc = (ManagerMissionPageViewController *)viewController;
//    self.pageIndex = vc.pageIndex;
//    if(self.pageIndex == 0){
//        return nil;
//    }
//    self.pageIndex --;
//    //    [segmentControl selectTheSegument:self.pageIndex];
//    return [viewControllers objectAtIndex:self.pageIndex];
//}
//
//-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
//    ManagerMissionPageViewController *vc = (ManagerMissionPageViewController *)previousViewControllers[0];
//    NSInteger page;
//    if((self.pageIndex==0&&self.pageIndex==vc.pageIndex)||self.pageIndex>vc.pageIndex){
//        page = vc.pageIndex+1;
//    }else{
//        page = vc.pageIndex-1;
//    }
//    [segmentControl selectTheSegument:page];
//}




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
    [((EMINavigationController *)self.navigationController) pushViewController:viewController withImageView:cell.postImgView originRect:originRect desRect:CGRectMake(15, 84, 53, 61)];
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

-(void)delTask:(id)sender {
    [ckAlertVC dismissViewControllerAnimated:NO completion:nil];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    ///X方向上的滑动距离
    CGFloat offSetX = scrollView.contentOffset.x;
    NSLog(@"在X方向上的滑动距离：%f",offSetX);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSString *identifier = segue.identifier;
    if ([identifier isEqualToString:@"tomanagermissiondetail"]) {
        ManagerMissionDetailViewController *viewController = [segue destinationViewController];
        viewController.flag = segmentControl.selectSeugment;
    }
}


@end
