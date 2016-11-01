//
//  MeMissionViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeMissionViewController.h"
#import "LFLUISegmentedControl.h"
#import "MeMissionTableViewCell.h"

#define Width [UIScreen mainScreen].bounds.size.width

@interface MeMissionViewController ()<LFLUISegmentedControlDelegate,UITableViewDelegate,UITableViewDataSource> {
    LFLUISegmentedControl *segmentControl;
}
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *dataArray;//所有数据
@property (strong,nonatomic) NSMutableArray *array;//显示用的数据

@end

@implementation MeMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"查看任务";
    
    segmentControl = [[LFLUISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, Width, 50)];
    segmentControl.delegate = self;
    segmentControl.titleFont = [UIFont systemFontOfSize:16.f];
    segmentControl.selectFont = [UIFont systemFontOfSize:16.f];
    [segmentControl AddSegumentArray:@[@"全部",@"已发布",@"待审核",@"已支付"]];
    [self.segmentView addSubview:segmentControl];
    
    self.array = @[@"http://cdnq.duitang.com/uploads/item/201506/05/20150605124315_xFQtw.thumb.700_0.jpeg",@"http://b.hiphotos.baidu.com/baike/c0%3Dbaike272%2C5%2C5%2C272%2C90/sign=529c869ec7fc1e17e9b284632bf99d66/1e30e924b899a9015d3d6abe15950a7b0208f529.jpg",@"http://p0.qhimg.com/t017f06c5631452f6bd.jpg"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.tableFooterView = [[UIView alloc] init];
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
    
    
    [self performSegueWithIdentifier:@"metomissiondetail" sender:nil];
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
            if(segmentControl.selectSeugment<3){
                select ++;
                [segmentControl selectTheSegument:select];
            }
            
            break;
        case UISwipeGestureRecognizerDirectionRight:
            if(segmentControl.selectSeugment>0){
                select --;
                [segmentControl selectTheSegument:select];
            }
            break;
        default:
            break;
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
