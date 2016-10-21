//
//  MeMissionDetailViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/18.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeMissionDetailViewController.h"
#import "MissionTitleTableViewCell.h"
#import "MissionActorTableViewCell.h"
#import "MissionRequireTableViewCell.h"
#import "MissionRowPieceTableViewCell.h"
#import "MissionNoAuthTableViewCell.h"

#define Width [UIScreen mainScreen].bounds.size.width

@interface MeMissionDetailViewController ()<UITableViewDelegate,UITableViewDataSource> {
    BOOL isAuthed;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MeMissionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isAuthed = YES;
    self.title = @"任务详情";
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            if(isAuthed){
                return 2;
            }else{
                return 1;
            }
            break;
        default:
            break;
    }
    return 0;
}

//分组Header高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section==0){
        return 0.01f;
    }else{
        return 42.f;
    }
    
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
            label.text = @"排片详情";
        }
        [view addSubview:label];
        return view;
    }
}

//分组Footer高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
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
        MissionRequireTableViewCell *cell = (MissionRequireTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        CGFloat width = Width - 64 - 30;
        
        CGSize textViewSize = [cell.requireLabel sizeThatFits:CGSizeMake(width, FLT_MAX)];
        [cell.requireLabel sizeToFit];
        CGFloat h = size.height + textViewSize.height - 15 - 1;
        h = h > 104 ? h : 104;  //89是图片显示的最低高度， 见xib
        return h;
    }
    if (isAuthed) {
        return 84.f;
    }
    return 134.f;
}

#pragma mark - UITableView dataSource
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
        
        MissionRequireTableViewCell *cell = [MissionRequireTableViewCell cellWithTableView:tableView];
        cell.selectedBackgroundView = [[UIView alloc] init];
        return cell;
    }else{
        if(isAuthed){
            MissionRowPieceTableViewCell *cell = [MissionRowPieceTableViewCell cellWithTableView:tableView];
            cell.selectedBackgroundView = [[UIView alloc] init];
            return cell;
        }else{
            MissionNoAuthTableViewCell *cell = [MissionNoAuthTableViewCell cellWithTableView:tableView];
            return cell;
        }
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if(section==3&&isAuthed){
        [self performSegueWithIdentifier:@"memissiontocheck" sender:nil];
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
