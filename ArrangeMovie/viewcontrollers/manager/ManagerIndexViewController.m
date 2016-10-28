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

@interface ManagerIndexViewController ()<UITableViewDelegate,UITableViewDataSource>
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
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"film_index_my" highImageName:@"film_index_my" target:self action:@selector(toMyProfile)];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.headImgView setShadowWithType:EMIShadowPathCircle shadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.3 shadowRadius:10 image:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580" placeholder:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            [_array addObject:task];
        }
        
        _array = [NSMutableArray arrayWithObjects:@"",@"", nil];
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
    [self performSegueWithIdentifier:@"tomissiondetail" sender:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(void)toMyMission {
    [self performSegueWithIdentifier:@"tomanagermission" sender:nil];
}

-(void)toMyProfile {
   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"me" bundle:nil];
    MeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"me"];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
