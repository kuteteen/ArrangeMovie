//
//  ManagerMissionDetailViewController.m
//  ArrangeMovie
//
//  Created by 王雪成 on 16/10/25.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ManagerMissionDetailViewController.h"
#import "MissionTitleTableViewCell.h"
#import "MissionActorTableViewCell.h"
#import "ManagerMissionRequireTableViewCell.h"
#import "ManagerMissionBtnTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIBarButtonItem+Extension.h"
#import "EMIShadowImageView.h"
#import "EMINavigationController.h"
#import "UIImage+GIF.h"
#import "MBProgressHUD.h"
#import "TaskDetailWebInterface.h"
#import "SCHttpOperation.h"

#define Width [UIScreen mainScreen].bounds.size.width

@interface ManagerMissionDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
    CGFloat originY;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) MBProgressHUD *HUD;
@property (strong,nonatomic) Task *dataTask;//网络请求来的，而非上一页传来的
@end

@implementation ManagerMissionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"任务详情";
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //导航栏右侧按钮为任务发布人的头像
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    headView.layer.masksToBounds = YES;
    headView.layer.cornerRadius = 14.f;
    
    if (self.task.headimg != nil) {
        [headView sd_setImageWithURL:[NSURL URLWithString:self.task.headimg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:headView];
        }];
    }else{
        headView.image = defaultheadimage;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:headView];
    }
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back" highImageName:@"back_click" target:self action:@selector(backToUp)];
    
    
    for(UIView *view in self.view.superview.subviews){
        if ([view isKindOfClass:[UIImageView class]]) {
            originY = view.frame.origin.y;
        }
    }
    
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu"
//                                                        object:self
//                                                      userInfo:nil];
    [self createswipToLastViewGesture];
    
    
    //请求数据
    [self fetchData];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

//自定义滑动返回
- (void)createswipToLastViewGesture{
    // 加入左侧边界手势
    UIScreenEdgePanGestureRecognizer * edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
}

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer  *)edgePan{
    
    for(UIView *view in self.view.superview.subviews){
        if ([view isKindOfClass:[UIImageView class]]) {
            view.alpha = 1;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
        
    
}


-(void)backToUp {
    for(UIView *view in self.view.superview.subviews){
        if ([view isKindOfClass:[UIImageView class]]) {
            view.alpha = 1;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//请求数据
- (void)fetchData{
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage sd_animatedGIFNamed:@"loading_120"]];
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.2];
    self.HUD.bezelView.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:0.8];
    //        HUD.bezelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_bj"]];
    //        HUD.bezelView.tintColor = [UIColor clearColor];
    
    self.HUD.bezelView.layer.cornerRadius = 16;
    self.HUD.mode = MBProgressHUDModeCustomView;
    //        HUD.mode = MBProgressHUDModeIndeterminate;
    self.HUD.customView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    self.HUD.customView = imageView;
    self.HUD.margin = 5;
    NSLog(@"HUD的margin:%f",self.HUD.margin);
    //    HUD.delegate = self;
    self.HUD.square = YES;
    [self.HUD showAnimated:YES];
    
    
    __unsafe_unretained typeof(self) weakself = self;
    TaskDetailWebInterface *taskdetailInterface = [[TaskDetailWebInterface alloc] init];
    NSDictionary *param = [taskdetailInterface inboxObject:@[@(self.user.userid),@(self.user.usertype),@(self.task.taskid)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:taskdetailInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [taskdetailInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            weakself.dataTask = result[1];
            [weakself.HUD hideAnimated:YES];
        }else{
            [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
            [weakself.HUD hideAnimated:YES];
        }
    } WithErrorCodeBlock:^(id errorCode) {
        [weakself.view makeToast:@"请求出错" duration:2.0 position:CSToastPositionCenter];
        [weakself.HUD hideAnimated:YES];
    } WithFailureBlock:^{
        [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
        [weakself.HUD hideAnimated:YES];
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

//分组Header高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section==0){
        return 0.01f;
    }else{
        return 42.f;
    }
}

//分组Footer高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section==0){
        return nil;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 42)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 17, Width-30, 18)];
        label.textColor = [UIColor colorWithHexString:@"404043"];
        label.font = [UIFont fontWithName:@"Droid Sans" size:18.f];
        if(section==1){
            label.text = @"主要演员";
        }else if(section==2){
            label.text = @"任务要求";
        }else {
            label.text = @"";
        }
        [view addSubview:label];
        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section==0){
        return 103.f;
    }else if(section==1){
        return 44.f;
    }else if(section==2){
        //需要根据内容计算高度
        ManagerMissionRequireTableViewCell *cell = (ManagerMissionRequireTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        CGFloat width = Width - 68 - 30;
        
        CGSize textViewSize = [cell.requireLabel sizeThatFits:CGSizeMake(width, FLT_MAX)];
        [cell.requireLabel sizeToFit];
        CGFloat h = size.height + textViewSize.height - 15 - 1;
        h = h > 180 ? h : 180;  //89是图片显示的最低高度， 见xib
        return h;
    }
    return 159.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section==0){
        MissionTitleTableViewCell *cell = [MissionTitleTableViewCell cellWithTableView:tableView];
        cell.selectedBackgroundView = [[UIView alloc] init];
        [cell setValue:self.dataTask];
        return cell;
    }else if(section==1){
        MissionActorTableViewCell *cell = [MissionActorTableViewCell cellWithTableView:tableView];
        cell.selectedBackgroundView = [[UIView alloc] init];
        [cell setValue:self.dataTask];
        return cell;
    }else if(section==2){
        
        ManagerMissionRequireTableViewCell *cell = [ManagerMissionRequireTableViewCell cellWithTableView:tableView];
        cell.selectedBackgroundView = [[UIView alloc] init];
        [cell setValue:self.dataTask];
        return cell;
    }else{
        ManagerMissionBtnTableViewCell *cell = [ManagerMissionBtnTableViewCell cellWithTableView:tableView];
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.flag = (int)self.flag;
        cell.task = self.dataTask;
        cell.viewController = self;
        switch (self.flag) {
            case 0:
                [cell.btn setTitle:@"领取任务" forState:UIControlStateNormal];
                //背景图
                [cell.btn setBackgroundImage:[UIImage imageNamed:@"task_receive"] forState:UIControlStateNormal];
                break;
            case 1:
                [cell.btn setTitle:@"上传排片凭证" forState:UIControlStateNormal];
                //背景图
                [cell.btn setBackgroundImage:[UIImage imageNamed:@"task_uploadcert"] forState:UIControlStateNormal];
                break;
            case 2:
                [cell.btn setTitle:@"查看排片凭证" forState:UIControlStateNormal];
                //背景图
                [cell.btn setBackgroundImage:[UIImage imageNamed:@"task_lookcert"] forState:UIControlStateNormal];
                break;
            case 3:
                [cell.btn setTitle:@"查看排片凭证" forState:UIControlStateNormal];
                [cell.btn setBackgroundImage:[UIImage imageNamed:@"task_lookcert"] forState:UIControlStateNormal];
                //背景图
                break;
            default:
                break;
        }
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    ///Y方向上的滑动距离
    CGFloat offSetY = scrollView.contentOffset.y-64;
    for(UIView *view in self.view.superview.subviews){
        if ([view isKindOfClass:[UIImageView class]]) {
            view.frame = CGRectMake(view.frame.origin.x, originY - offSetY + 20, view.frame.size.width, view.frame.size.height);
            NSLog(@"移动之后详情页面图片的Y:%f",view.frame.origin.y);
            ((EMINavigationController *)self.navigationController).animation.desRect = view.frame;
        }
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
