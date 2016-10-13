//
//  MeBankCardViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/11.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeBankCardViewController.h"
#import "MeBankCardTableViewCell.h"

@interface MeBankCardViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *array;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MeBankCardViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.array = [[NSArray alloc] initWithObjects:@"",@"", nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}


#pragma mark tableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        return 127.f;
    }
    return 50.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
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
    if(section==0){
        MeBankCardTableViewCell *cell = [MeBankCardTableViewCell cellWithTableView:tableView];
        return cell;
    }else {
        MeBankCardTableViewCell *cell = [MeBankCardTableViewCell cellWithTableView:tableView];
        return cell;
    }
}

@end
