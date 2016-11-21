//
//  MeBankCardViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/11.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeBankCardViewController.h"
#import "MeBankCardTableViewCell.h"
#import "MeBankAddTableViewCell.h"

#define width [UIScreen mainScreen].bounds.size.width

@interface MeBankCardViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *array;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MeBankCardViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"我的银行卡";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.array = [[NSArray alloc] initWithObjects:@"",@"", nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0.1)];
    
}


#pragma mark tableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        return 127.f;
    }
    return 60.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

#pragma mark tableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.array.count;
            break;
        case 1:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section==0){
        MeBankCardTableViewCell *cell = [MeBankCardTableViewCell cellWithTableView:tableView];
        if(row!=0){
            cell.mainView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8" alpha:1];
        }else{
            cell.mainView.backgroundColor = [UIColor colorWithHexString:@"e7e7e7" alpha:1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        MeBankAddTableViewCell *cell = [MeBankAddTableViewCell cellWithTableView:tableView];
        UIView *backview = [[UIView alloc] init];
        backview.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = backview;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section==1&&row==0){
        //添加银行卡
        [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
        [self performSegueWithIdentifier:@"banktoadd" sender:nil];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
@end
