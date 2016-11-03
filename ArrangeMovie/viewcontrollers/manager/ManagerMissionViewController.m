//
//  ManagerMissionViewController.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/10/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ManagerMissionViewController.h"
#import "LFLUISegmentedControl.h"
#import "ManagerMissionTableViewCell.h"
#import "ManagerMissionDetailViewController.h"
#import "AMAlertView.h"
#import "CKAlertViewController.h"

#define Width [UIScreen mainScreen].bounds.size.width

@interface ManagerMissionViewController ()<LFLUISegmentedControlDelegate,UITableViewDelegate,UITableViewDataSource>{
    LFLUISegmentedControl *segmentControl;
    CKAlertViewController *ckAlertVC;
}
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *dataArray;//所有数据
@property (strong,nonatomic) NSMutableArray *array;//显示用的数据
@end

@implementation ManagerMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"查看任务";
    
    segmentControl = [[LFLUISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, Width, 50)];
    segmentControl.delegate = self;
    segmentControl.titleFont = [UIFont systemFontOfSize:16.f];
    segmentControl.selectFont = [UIFont systemFontOfSize:16.f];
    [segmentControl AddSegumentArray:@[@"新任务",@"已领取",@"审核中",@"已完成"]];
    [self.segmentView addSubview:segmentControl];
    
//    self.array = @[@"http://cdnq.duitang.com/uploads/item/201506/05/20150605124315_xFQtw.thumb.700_0.jpeg",@"http://b.hiphotos.baidu.com/baike/c0%3Dbaike272%2C5%2C5%2C272%2C90/sign=529c869ec7fc1e17e9b284632bf99d66/1e30e924b899a9015d3d6abe15950a7b0208f529.jpg",@"http://p0.qhimg.com/t017f06c5631452f6bd.jpg"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //分割线
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.tableFooterView = [[UIView alloc] init];
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
            task.filmstars = @"本尼迪克特·康伯巴奇,马丁·弗瑞曼,安德鲁·斯科特,马克·加蒂斯";
            task.startdate = @"2016-10-31";
            task.enddate = @"2016-11-21";
            task.shownum = @"30";
            task.tasknum = @"10";
            task.surplusnum = @"7";
            task.dn = @"18252495961";
            task.gradename = @"A级影院";
            [_array addObject:task];
        }
    }
    return _array;
}

#pragma mark - UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 144.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //任务详情
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    //跳转到任务详情
    [self performSegueWithIdentifier:@"tomanagermissiondetail" sender:nil];
}

#pragma mark - UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManagerMissionTableViewCell *cell = [ManagerMissionTableViewCell cellWithTableView:tableView];
    UIView *backview = [[UIView alloc] init];
    backview.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    cell.selectedBackgroundView = backview;
    
    [cell setValue:self.array[indexPath.row]];
    
    if(segmentControl.selectSeugment==2){
        cell.flagLabel.hidden = NO;
        cell.delTaskBtn.hidden = YES;
    }else{
        cell.flagLabel.hidden = YES;
        cell.delTaskBtn.hidden = NO;
    }
    [cell.delTaskBtn addTarget:self action:@selector(toDelTask:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - LFLUISegmentedControl delegate
-(void)uisegumentSelectionChange:(NSInteger)selection {
    NSLog(@"滑动到第%ld页",(long)selection);
    //reloadData
    [self.tableView reloadData];
}

- (IBAction)selectSegment:(UISwipeGestureRecognizer *)sender {
    UISwipeGestureRecognizerDirection direction = sender.direction;
    NSInteger select = segmentControl.selectSeugment;
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            if(segmentControl.selectSeugment!=3){
                select ++;
                [segmentControl selectTheSegument:select];
            }
            break;
        case UISwipeGestureRecognizerDirectionRight:
            if(segmentControl.selectSeugment!=0){
                select --;
                [segmentControl selectTheSegument:select];
            }
            break;
        default:
            break;
    }
}

-(void)toDelTask:(id)sender {
    AMAlertView *amalertview = [[AMAlertView alloc] initWithconsFrame:CGRectMake(45, (screenHeight-191)/2, screenWidth-90, 191)];
    [amalertview setTitle:@"删除任务"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, amalertview.frame.size.width-30, 16)];
    label.text = @"确认是否删除这个任务?";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"15151b"];
    label.font = [UIFont systemFontOfSize:17.f];
    [amalertview.contentView addSubview:label];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 76, amalertview.frame.size.width-30, 40)];
    [sureBtn setTitle:@"确认删除" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 4;
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"557dcf"];
    [sureBtn addTarget:self action:@selector(delTask:) forControlEvents:UIControlEventTouchUpInside];
    [amalertview.contentView addSubview:sureBtn];
    
    ckAlertVC = [[CKAlertViewController alloc] initWithAlertView:amalertview];
    [self presentViewController:ckAlertVC animated:NO completion:nil];
}

-(void)delTask:(id)sender {
    [ckAlertVC dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSString *identifier = segue.identifier;
    if ([identifier isEqualToString:@"tomanagermissiondetail"]) {
        ManagerMissionDetailViewController *viewController = [segue destinationViewController];
        viewController.flag = segmentControl.selectSeugment;
    }
}


@end
