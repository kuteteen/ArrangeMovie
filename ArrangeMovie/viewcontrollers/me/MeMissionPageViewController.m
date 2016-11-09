//
//  MeMissionPageViewController.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/2.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeMissionPageViewController.h"

@interface MeMissionPageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *array;//显示用的数据
@end

@implementation MeMissionPageViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"第%ld页",(long)self.pageIndex);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//        self.array = [NSMutableArray arrayWithArray:@[@"http://cdnq.duitang.com/uploads/item/201506/05/20150605124315_xFQtw.thumb.700_0.jpeg",@"http://b.hiphotos.baidu.com/baike/c0%3Dbaike272%2C5%2C5%2C272%2C90/sign=529c869ec7fc1e17e9b284632bf99d66/1e30e924b899a9015d3d6abe15950a7b0208f529.jpg",@"http://p0.qhimg.com/t017f06c5631452f6bd.jpg"]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.tableFooterView = [[UIView alloc] init];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 144.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //任务详情
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    MeMissionTableViewCell *cell = (MeMissionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    ///cell在tableView的位置
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    
    //cell在viewController中的位置
    CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
    CGRect originRect = CGRectMake(rect.origin.x+15, rect.origin.y+63+50+64, cell.postImgView.frame.size.width, cell.postImgView.frame.size.height);
    cell.imgRect = originRect;
    if([self.delegate respondsToSelector:@selector(checkMission:)]){
        [self.delegate performSelector:@selector(checkMission:) withObject:cell];
    }
//    [self performSegueWithIdentifier:@"metomissiondetail" sender:nil];
}

#pragma mark - UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeMissionTableViewCell *cell = [MeMissionTableViewCell cellWithTableView:tableView];
    UIView *backview = [[UIView alloc] init];
    backview.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    cell.selectedBackgroundView = backview;

    [cell setValue:self.array[indexPath.row]];
    return cell;
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
