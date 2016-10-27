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

#define Width [UIScreen mainScreen].bounds.size.width

@interface ManagerMissionDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ManagerMissionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"任务详情";
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        label.font = [UIFont boldSystemFontOfSize:18.f];
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
        return 99.f;
    }else if(section==1){
        return 44.f;
    }else if(section==2){
        //需要根据内容计算高度
        ManagerMissionRequireTableViewCell *cell = (ManagerMissionRequireTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        CGFloat width = Width - 64 - 30;
        
        CGSize textViewSize = [cell.requireLabel sizeThatFits:CGSizeMake(width, FLT_MAX)];
        [cell.requireLabel sizeToFit];
        CGFloat h = size.height + textViewSize.height - 15 - 1;
        h = h > 180 ? h : 180;  //89是图片显示的最低高度， 见xib
        return h;
    }
    return 114.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section==0){
        MissionTitleTableViewCell *cell = [MissionTitleTableViewCell cellWithTableView:tableView];
        cell.selectedBackgroundView = [[UIView alloc] init];
        [cell setValue:@""];
        return cell;
    }else if(section==1){
        MissionActorTableViewCell *cell = [MissionActorTableViewCell cellWithTableView:tableView];
        cell.selectedBackgroundView = [[UIView alloc] init];
        return cell;
    }else if(section==2){
        
        ManagerMissionRequireTableViewCell *cell = [ManagerMissionRequireTableViewCell cellWithTableView:tableView];
        cell.selectedBackgroundView = [[UIView alloc] init];
        return cell;
    }else{
        ManagerMissionBtnTableViewCell *cell = [ManagerMissionBtnTableViewCell cellWithTableView:tableView];
        cell.selectedBackgroundView = [[UIView alloc] init];
        return cell;
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
