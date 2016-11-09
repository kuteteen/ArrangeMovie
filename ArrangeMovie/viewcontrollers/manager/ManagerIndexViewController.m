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

@interface ManagerIndexViewController ()<UITableViewDelegate,UITableViewDataSource> {
    Task *selTask;
}
@property (strong, nonatomic) IBOutlet EMIShadowImageView *headImgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cinemaLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSMutableArray *array;//数据源

@end

@implementation ManagerIndexViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"";

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"theatres_index_view_task" highImageName:@"theatres_index_view_task" target:self action:@selector(toMyMission)];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"film_index_my" highImageName:@"film_index_my" target:self action:@selector(presentRightMenuViewController:)];

    self.tableView.tableFooterView = [[UIView alloc] init];

    [self showUser];

    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(disableRESideMenu)
//                                                 name:@"disableRESideMenu"
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(enableRESideMenu)
//                                                 name:@"enableRESideMenu"
//                                               object:nil];
}

//- (void)enableRESideMenu {
//    self.panGestureEnabled = YES;
//}
//
//- (void)disableRESideMenu {
//    self.panGestureEnabled = NO;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showUser {
  [self.headImgView setShadowWithType:EMIShadowPathCircle shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeZero shadowOpacity:0.35 shadowRadius:10 image:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580" placeholder:@""];
    // [self.headImgView setShadowWithType:EMIShadowPathCircle shadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.3 shadowRadius:10 image:self.user.headimg placeholder:@""];
    self.nameLabel.text = self.user.name;
    self.cinemaLabel.text = self.user.gradename;
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
            task.gradename = @"A级影院";
            [_array addObject:task];
        }
    }
    return _array;
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
    [self performSegueWithIdentifier:@"tomissiondetail" sender:nil];
}

-(void)startAnimationForIndexPath:(NSIndexPath*)indexPath{
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
