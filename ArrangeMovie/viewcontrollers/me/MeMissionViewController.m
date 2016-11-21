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
#import "MeMissionPageViewController.h"
#import "MeMissionDetailViewController.h"
#import "EMINavigationController.h"

#define Width [UIScreen mainScreen].bounds.size.width

@interface MeMissionViewController ()<LFLUISegmentedControlDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate,MeMissionPageViewControllerDelegate> {
    LFLUISegmentedControl *segmentControl;
    
    UIPageViewController *pageViewController;
    
    NSMutableArray *viewControllers;
    
    
    MeMissionPageViewController *missionPageController;
}
@property (weak, nonatomic) IBOutlet UIView *segmentView;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;


//@property (nonatomic, strong) MeMissionPageViewController *viewController;
///页数
@property (nonatomic, assign) NSInteger pageCount;
///第N页
@property (nonatomic, assign) NSInteger pageIndex;

//@property (strong,nonatomic) NSMutableArray *dataArray;//所有数据
//@property (strong,nonatomic) NSMutableArray *array;//显示用的数据

@end

@implementation MeMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"查看任务";
    
    
    segmentControl = [[LFLUISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, Width, 50)];
    segmentControl.delegate = self;
    segmentControl.titleFont = [UIFont systemFontOfSize:16.f];
    segmentControl.selectFont = [UIFont systemFontOfSize:16.f];
    [segmentControl AddSegumentArray:@[@"全部",@"已发布",@"待审核",@"已支付"]];
    [self.segmentView addSubview:segmentControl];
    
    pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageviewcontroller"];
    self.pageCount = 4;
    
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    [self setContentViewController:0];
    pageViewController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    [self addChildViewController:pageViewController];
    [self.contentView addSubview:pageViewController.view];
    [pageViewController didMoveToParentViewController:self];
    
}

-(void)setContentViewController:(NSInteger)pageIndex {
    if(!viewControllers){
        viewControllers = [[NSMutableArray alloc] initWithCapacity:self.pageCount];
        for(int i = 0;i<self.pageCount;i++){
            MeMissionPageViewController *startingViewController = [self viewControllerAtIndex:i];
            [viewControllers addObject:startingViewController];
        }
    }
        
    [pageViewController setViewControllers:@[viewControllers[pageIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}

-(MeMissionPageViewController *)viewControllerAtIndex:(NSInteger)index {
    if(index>=self.pageCount) {
        return nil;
    }
    MeMissionPageViewController *pageContentViewController;
    pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"missionpagecontent"];
    pageContentViewController.delegate = self;
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MeMissionPageViewControllerDelegate
-(void)checkMission:(MeMissionTableViewCell *)cell {
    //跳转到详情
//    [self performSegueWithIdentifier:@"metomissiondetail" sender:nil];
    [self startAnimationForIndexPath:cell];
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

#pragma mark -UIPageViewControllerDataSource

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    MeMissionPageViewController *vc = (MeMissionPageViewController *)viewController;
    self.pageIndex = vc.pageIndex;
    if(self.pageIndex<self.pageCount-1){
        self.pageIndex++;
        return [viewControllers objectAtIndex:self.pageIndex];
    }else{
        return nil;
    }
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    MeMissionPageViewController *vc = (MeMissionPageViewController *)viewController;
    self.pageIndex = vc.pageIndex;
    if(self.pageIndex == 0){
        return nil;
    }
    self.pageIndex --;
//    [segmentControl selectTheSegument:self.pageIndex];
    return [viewControllers objectAtIndex:self.pageIndex];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    MeMissionPageViewController *vc = (MeMissionPageViewController *)previousViewControllers[0];
    NSInteger page;
    if((self.pageIndex==0&&self.pageIndex==vc.pageIndex)||self.pageIndex>vc.pageIndex){
        page = vc.pageIndex+1;
    }else{
        page = vc.pageIndex-1;
    }
    [segmentControl selectTheSegument:page];
//    self.pageIndex = vc.pageIndex;
    //切换
//    [segmentControl selectTheSegument:self.pageIndex];
}

#pragma mark - LFLUISegmentedControl delegate
-(void)uisegumentSelectionChange:(NSInteger)selection {
    NSLog(@"滑动到第%ld页",(long)selection);
    //reloadData
//    self.pageIndex = selection;
//    [self setContentViewController:selection];
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
