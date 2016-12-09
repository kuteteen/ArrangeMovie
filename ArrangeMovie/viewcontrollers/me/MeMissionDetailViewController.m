//
//  MeMissionDetailViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/18.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeMissionDetailViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MeMissionTitleView.h"
#import "MeMissionActorView.h"
#import "MeMissionRequireView.h"
#import "MeMissionRowPieceView.h"
#import "MeMissionNoAuthView.h"
#import "EMINavigationController.h"
#import "TaskDetailWebInterface.h"
#import "SCHttpOperation.h"
#import "UIImage+GIF.h"
#import "MBProgressHUD.h"
#import "SCDateTools.h"

#define Width [UIScreen mainScreen].bounds.size.width

@interface MeMissionDetailViewController () <UIScrollViewDelegate>{
    BOOL isAuthed;
    CGFloat originY;
    Task *detailTask;
}
@property (strong,nonatomic) MBProgressHUD *HUD;
@end

@implementation MeMissionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isAuthed = YES;
    self.title = @"任务详情";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back" highImageName:@"back_click" target:self action:@selector(backToUp)];
    
//    self.tableView.tableFooterView = [[UIView alloc] init];
    for(UIView *view in self.view.superview.subviews){
        if ([view isKindOfClass:[UIImageView class]]) {
            originY = view.frame.origin.y;
        }
    }

}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    //请求数据
    [self fetchData];
    [self createswipToLastViewGesture];
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
    
    //请求到数据之后才initView
    __unsafe_unretained typeof(self) weakself = self;
    TaskDetailWebInterface *taskdetailInterface = [[TaskDetailWebInterface alloc] init];
    NSDictionary *param = [taskdetailInterface inboxObject:@[@(self.user.userid),@(self.user.usertype),@(self.task.taskid)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:taskdetailInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [taskdetailInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            detailTask = result[1];
            [weakself initViews];
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


-(void)initViews {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    
    ///添加电影信息
    MeMissionTitleView *titleView = [[MeMissionTitleView alloc] initNibWithFrame:CGRectMake(0, 64, screenWidth, 99)];
    [self showTitleView:titleView];
    [scrollView addSubview:titleView];
    
    //添加演员信息
    MeMissionActorView *actorView = [[MeMissionActorView alloc] initNibWithFrame:CGRectMake(0, titleView.frame.origin.y+titleView.frame.size.height, screenWidth, 82)];
    [self showActor:actorView];
    [scrollView addSubview:actorView];
    
    ///添加任务要求信息
    MeMissionRequireView *requireView = [[MeMissionRequireView alloc] initNibWithFrame:CGRectMake(0, actorView.frame.origin.y+actorView.frame.size.height, screenWidth, 144)];
    [self showRequire:requireView];
    [scrollView addSubview:requireView];
    
    ///添加排片详情Label
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, requireView.frame.origin.y+requireView.frame.size.height+17, 76, 18)];
    detailLabel.font = [UIFont fontWithName:@"Droid Sans" size:18.f];
    detailLabel.textColor = [UIColor colorWithHexString:@"404043"];
    detailLabel.text = @"排片详情";
    [scrollView addSubview:detailLabel];
    
    //有状态的接受任务记录0接受 1完成  2放弃 3片方审核未完成 4片方审核完成 5平台审核未完成 6平台审核完成
    //要从中筛选出0接受 1完成  2放弃 这三中
//    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"taskdetailstatus='0' || taskdetailstatus='1' || taskdetailstatus='2'"];
//   NSPredicate *preicate =  [NSPredicate predicateWithFormat:@"taskdetailstatus<3"];
    
//    NSArray <TakeTask *> *needtakeTask = [detailTask.data filteredArrayUsingPredicate:preicate];
    
    if(detailTask.data.count>0){
        NSInteger count = detailTask.data.count;
        for(int i = 0;i<count;i ++){
            MeMissionRowPieceView *pieceView = [[MeMissionRowPieceView alloc] initNibWithFrame:CGRectMake(0, 17+detailLabel.frame.origin.y+detailLabel.frame.size.height+i*84, screenWidth, 84)];
            pieceView.viewController = self;
            pieceView.taskid = self.task.taskid;
            [pieceView setTakeTaskValues:detailTask.data[i]];
            pieceView.tag = 1000+i;
            [scrollView addSubview:pieceView];
        }
    scrollView.contentSize = CGSizeMake(screenWidth, 17+detailLabel.frame.origin.y+detailLabel.frame.size.height+count*84+17);
    }else{
        MeMissionNoAuthView *noAuthView = [[MeMissionNoAuthView alloc] initNibWithFrame:CGRectMake(0, 17+detailLabel.frame.origin.y+detailLabel.frame.size.height, screenWidth, 134)];
        [scrollView addSubview:noAuthView];
        scrollView.contentSize = CGSizeMake(screenWidth, 17+detailLabel.frame.origin.y+detailLabel.frame.size.height+134);
    }

    [self.view addSubview:scrollView];
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

/**
 *  self.task 展示影片信息
 *
 *  @param titleView
 */
-(void)showTitleView:(MeMissionTitleView *)titleView {
    [titleView.postImgView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeZero shadowOpacity:0.26 shadowRadius:2 image:detailTask.img placeholder:@""];
    titleView.filmNameLabel.text = detailTask.filmname;
    titleView.directorLabel.text = [NSString stringWithFormat:@"导演：%@",detailTask.filmdirector];
    titleView.dateLabel.text = [NSString stringWithFormat:@"任务时间：%@~%@",detailTask.startdate,detailTask.enddate];
    titleView.pointsLabel.text = [NSString stringWithFormat:@"%@分",detailTask.taskpoints];
}

/**
 *  self.task 展示演员信息
 *
 *  @param actorView
 */
-(void)showActor:(MeMissionActorView *)actorView {
    actorView.actorLabel.text = detailTask.filmstars;
}

/**
 *  self.task 展示任务要求信息
 *
 *  @param requireView
 */
-(void)showRequire:(MeMissionRequireView *)requireView {
    
    requireView.taskCountLabel.text = [NSString stringWithFormat:@"%@份",detailTask.tasknum];
    requireView.cinemaLevelLabel.text = [NSString stringWithFormat:@"%@级影院以上",detailTask.gradename];
    
    
    
    
    requireView.requireContentLabel.text = [NSString stringWithFormat:@"%@开始为期%ld天的任务",detailTask.startdate,(long)[SCDateTools daysBetween:[SCDateTools stringToDate:detailTask.startdate] and:[SCDateTools stringToDate:detailTask.enddate]]];
    CGSize size = [requireView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat width = screenWidth - 60 - 30;

    CGSize textViewSize = [requireView.requireContentLabel sizeThatFits:CGSizeMake(width, FLT_MAX)];
    [requireView.requireContentLabel sizeToFit];
    CGFloat h = size.height + textViewSize.height - 15 - 1;
    h = h > 144 ? h : 144;
    requireView.frame = CGRectMake(requireView.frame.origin.x, requireView.frame.origin.y, requireView.frame.size.width, h);
    
}

//#pragma mark - UITableView delegate
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 4;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    switch (section) {
//        case 0:
//            return 1;
//            break;
//        case 1:
//            return 1;
//            break;
//        case 2:
//            return 1;
//            break;
//        case 3:
//            if(isAuthed){
//                return 2;
//            }else{
//                return 1;
//            }
//            break;
//        default:
//            break;
//    }
//    return 0;
//}
//
////分组Header高度
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if(section==0){
//        return 0.01f;
//    }else{
//        return 42.f;
//    }
//    
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if(section==0){
//        return nil;
//    }else{
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 42)];
//        view.backgroundColor = [UIColor whiteColor];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 17, Width-30, 18)];
//        label.textColor = [UIColor colorWithHexString:@"404043"];
//        label.font = [UIFont boldSystemFontOfSize:18.f];
//        if(section==1){
//            label.text = @"主要演员";
//        }else if(section==2){
//            label.text = @"任务要求";
//        }else {
//            label.text = @"排片详情";
//        }
//        [view addSubview:label];
//        return view;
//    }
//}
//
////分组Footer高度
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01f;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
//    if(section==0){
//        return 99.f;
//    }else if(section==1){
//        return 44.f;
//    }else if(section==2){
//        //需要根据内容计算高度
//        MissionRequireTableViewCell *cell = (MissionRequireTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//        CGFloat width = Width - 64 - 30;
//        
//        CGSize textViewSize = [cell.requireLabel sizeThatFits:CGSizeMake(width, FLT_MAX)];
//        [cell.requireLabel sizeToFit];
//        CGFloat h = size.height + textViewSize.height - 15 - 1;
//        h = h > 104 ? h : 104;  //89是图片显示的最低高度， 见xib
//        return h;
//    }
//    if (isAuthed) {
//        return 84.f;
//    }
//    return 134.f;
//}
//
//#pragma mark - UITableView dataSource
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
//    if(section==0){
//        MissionTitleTableViewCell *cell = [MissionTitleTableViewCell cellWithTableView:tableView];
//        cell.selectedBackgroundView = [[UIView alloc] init];
//        [cell setValue:@""];
//        return cell;
//    }else if(section==1){
//        MissionActorTableViewCell *cell = [MissionActorTableViewCell cellWithTableView:tableView];
//        cell.selectedBackgroundView = [[UIView alloc] init];
//        return cell;
//    }else if(section==2){
//        
//        MissionRequireTableViewCell *cell = [MissionRequireTableViewCell cellWithTableView:tableView];
//        cell.selectedBackgroundView = [[UIView alloc] init];
//        return cell;
//    }else{
//        if(isAuthed){
//            MissionRowPieceTableViewCell *cell = [MissionRowPieceTableViewCell cellWithTableView:tableView];
//            cell.selectedBackgroundView = [[UIView alloc] init];
//            return cell;
//        }else{
//            MissionNoAuthTableViewCell *cell = [MissionNoAuthTableViewCell cellWithTableView:tableView];
//            return cell;
//        }
//    }
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
//    
//    if(section==3&&isAuthed){
//        [self performSegueWithIdentifier:@"memissiontocheck" sender:nil];
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end