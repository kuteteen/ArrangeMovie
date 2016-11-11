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

@interface ManagerIndexViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
    Task *selTask;
}
@property (strong, nonatomic) UIView *head;
@property (strong, nonatomic) UIImageView *topView;

@property (strong, nonatomic) EMIShadowImageView *headImgView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *cinemaLabel;
@property (strong, nonatomic) UITableView *tableView;


@property (strong, nonatomic) NSMutableArray *array;//数据源

@end

@implementation ManagerIndexViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"";

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"theatres_index_view_task" highImageName:@"theatres_index_view_task" target:self action:@selector(toMyMission)];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"film_index_my" highImageName:@"film_index_my" target:self action:@selector(presentRightMenuViewController:)];

//    self.tableView.tableFooterView = [[UIView alloc] init];

    
    [self initViews];
    
    [self showUser];
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
    
    self.head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 201*autoSizeScaleY)];
    self.topView = [[UIImageView alloc] initWithFrame:self.head.bounds];
    self.topView.image = [UIImage imageNamed:@"pfhome_topbg"];
    self.topView.contentMode = UIViewContentModeScaleAspectFill;
    self.topView.clipsToBounds = YES;
    
    //头像
    self.headImgView = [[EMIShadowImageView alloc] initWithFrame:CGRectMake((screenWidth-110*autoSizeScaleX)/2, 4, 110*autoSizeScaleX, 110*autoSizeScaleX)];
    self.headImgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    
    [self.topView addSubview:self.headImgView];
    self.headImgView.sd_layout.centerXEqualToView(self.topView);
    
    //姓名
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 4+110*autoSizeScaleX+4+23*autoSizeScaleY, screenWidth-20, 25*autoSizeScaleY)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:21.f];
    self.nameLabel.text = @"王小二";
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.nameLabel];
    self.nameLabel.sd_layout.centerXEqualToView(self.topView);
    
    [self.head addSubview:self.topView];
    self.tableView.tableHeaderView = self.head;
    
    [self.tableView sendSubviewToBack:self.tableView.tableHeaderView];
    
    [self.view addSubview:self.tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showUser {
  [self.headImgView setShadowWithType:EMIShadowPathCircle shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeZero shadowOpacity:0.35 shadowRadius:10 image:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580" placeholder:@""];
    // [self.headImgView setShadowWithType:EMIShadowPathCircle shadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.3 shadowRadius:10 image:self.user.headimg placeholder:@""];
    self.nameLabel.text = self.user.name;
//    self.cinemaLabel.text = self.user.gradename;
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
    
    
    
    //上移
    if (imageOffsetY < 0) {
        CGFloat totalOffset = imageHeight + ABS(imageOffsetY);
        CGFloat f = totalOffset / imageHeight;
        
        self.topView.frame = CGRectMake(-(imageWidth * f - imageWidth) * 0.5, imageOffsetY, imageWidth * f, totalOffset);
    }
    
    //下移
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
    
    [((EMINavigationController *)self.navigationController) pushViewController:viewController withImageView:cell.postImgView originRect:originRect desRect:CGRectMake(15, 84, 53, 61)];
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
