//
//  MakeTaskViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/18.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MakeTaskViewController.h"
#import "AMAlertView.h"
#import "CKAlertViewController.h"
#import "TouchLabel.h"


@interface MakeTaskViewController ()<UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)NSMutableArray *contentArray;

@end

@implementation MakeTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.definesPresentationContext = YES;
    
    [self initView];
    
    [AppDelegate storyBoradAutoLay:self.view];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initView{
    
    
    
    self.title = @"创建任务";
    
    self.titleArray = @[@[@"任务名称",@"任务发放数"],@[@"任务积分",@"任务时间"],@[@"影院级别",@"任务类型"]];
    self.contentArray = @[@[@"选择电影名称(请包含电影名)",@"选择可领取的任务数"],@[@"选择可获得的任务积分",@""],@[@"选择放映的影院级别",@"选择任务类型"]];
    //右侧navBtn
    UIBarButtonItem *rightNavBtn = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(rightNavBtnClicked:)];
    [rightNavBtn setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:18],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [rightNavBtn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 17;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,rightNavBtn, nil];
    
    [self setCollectionView];
}


- (void)setCollectionView{
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.minimumInteritemSpacing = 0;
//    flowLayout.minimumLineSpacing = 0;
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"TaskCellNormal" bundle:nil] forCellWithReuseIdentifier:@"TaskCellNormal"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TaskCellTime" bundle:nil] forCellWithReuseIdentifier:@"TaskCellTime"];
}

//发布
- (void)rightNavBtnClicked:(UIBarButtonItem *)sender{
    
}

//添加图片
- (IBAction)addImg:(UIButton *)sender {
    NSLog(@"%@",@"添加图片");
    
    [self performSegueWithIdentifier:@"toUploadImgVC" sender:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1  && indexPath.row == 1) {
        //时间
        TaskCellTime *cell = [TaskCellTime cellForCollection:collectionView indexPath:indexPath];
        [cell setTitleTxt:@"任务时间"];
        
        [cell setStartTxt:@"选择任务开始时间"];
        [cell setEndTxt:@"选择任务结束时间"];
        cell.parentVC = self;
        return cell;
    }else{
        //其他
        TaskCellNormal *cell = [TaskCellNormal cellForCollection:collectionView indexPath:indexPath];
        [cell setTitleTxt:self.titleArray[indexPath.section][indexPath.row]];
        [cell setContentTxt:self.contentArray[indexPath.section][indexPath.row]];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //电影名称
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self performSegueWithIdentifier:@"toChooseFilmVC" sender:self];
    }
    //任务发放数
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self createAlertView];
    }
    //任务积分
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self createAlertView];
    }
    //任务时间
    if (indexPath.section == 1 && indexPath.row == 1) {
        
    }
    //影院级别
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self createAlertView];
    }
    
    //任务类型
    if (indexPath.section == 2 && indexPath.row == 1) {
        [self createAlertView];
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(164*autoSizeScaleX, 170*autoSizeScaleY);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(7.5*autoSizeScaleX, 6.25*autoSizeScaleY, 7.5*autoSizeScaleX, 6.25*autoSizeScaleX);
}


- (void)createAlertView{
    AMAlertView *amalertview = [[AMAlertView alloc] initWithconsFrame:CGRectMake(43.5*autoSizeScaleX, (667/2-173)*autoSizeScaleY, 288*autoSizeScaleX, 346*autoSizeScaleY)];
    [amalertview setTitle:@"通过审核"];
    UIScrollView *childView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 288*autoSizeScaleX, 300*autoSizeScaleY)];
    ;
    childView.scrollEnabled = YES;
    childView.showsVerticalScrollIndicator = NO;
    childView.showsHorizontalScrollIndicator = NO;
    CGFloat y = 0;
    for (int i = 0; i <100; i ++) {
        
        
        TouchLabel *label = [[TouchLabel alloc] initWithBlock:^(NSString *str) {
            NSLog(@"%@",str);
        } frame:CGRectMake(24*autoSizeScaleX, y, 240*autoSizeScaleX, 40*autoSizeScaleY)];
        label.text = [NSString stringWithFormat:@"%d份",i+1];
        y = 40*autoSizeScaleY+y;
        
        [childView addSubview:label];
    }
    childView.contentSize = CGSizeMake(0, y);
    [amalertview setChildView:childView];
    CKAlertViewController *ckAlertVC = [[CKAlertViewController alloc] initWithAlertView:amalertview];
    
    [self presentViewController:ckAlertVC animated:NO completion:nil];
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
