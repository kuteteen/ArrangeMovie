//
//  MeViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/9.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeViewController.h"
#import "EMIShadowImageView.h"
//#import "SDWebImage.h"

@interface MeViewController ()
@property (nonatomic, strong) NSArray *array;//存放列表item

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}

-(NSArray *)array {
    if (!_array) {
        if(self.user.usertype==0){
            _array = @[@"我的资料",@"任务历史",@"我的积分",@"我的银行卡",@"修改密码",@"资料审核",@"设置"];
        }else{
            _array = @[@"我的资料",@"我的积分",@"我的银行卡",@"修改密码",@"资料审核",@"设置"];
        }
    }
    return _array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate

#pragma mark - tableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell
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
