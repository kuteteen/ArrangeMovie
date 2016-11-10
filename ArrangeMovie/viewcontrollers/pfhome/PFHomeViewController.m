//
//  PFHomeViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "PFHomeViewController.h"

@interface PFHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic,strong)NSMutableArray *sectionArray;//section数组(里面包裹着各个section的数据)
@property(nonatomic,strong)NSMutableArray *isshowArray;//是否展示数组(和sectionArray数量保持一致)
@property(nonatomic,strong)NSMutableArray *issselectedArray;//是否选中数组(和sectionArray数量保持一致),用来标志背景色
@end

@implementation PFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.sectionArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < 100; i++) {
        [self.sectionArray addObject:@[@1,@2,@3]];
    }
    self.isshowArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.issselectedArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self handleData];
    
    [self initView];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initView{
    
    
    //tabelview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64)];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.bounces = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 201*autoSizeScaleY)];
    
    self.topView = [[UIImageView alloc] initWithFrame:self.head.bounds];
    self.topView.image = [UIImage imageNamed:@"pfhome_topbg"];
    self.topView.contentMode = UIViewContentModeScaleAspectFill;
    self.topView.clipsToBounds = YES;
    //头像
    self.headImgView = [[EMIShadowImageView alloc] initWithFrame:CGRectMake((screenWidth-110*autoSizeScaleX)/2, 4, 110*autoSizeScaleX, 110*autoSizeScaleX)];
    self.headImgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self setHead];
    [self.topView addSubview:self.headImgView];
    self.headImgView.sd_layout.centerXEqualToView(self.topView);
    //姓名
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 4+110*autoSizeScaleX+4+23*autoSizeScaleY, screenWidth-20, 25*autoSizeScaleY)];
    self.nameLab.textAlignment = NSTextAlignmentCenter;
    self.nameLab.font = [UIFont systemFontOfSize:21.f];
    self.nameLab.text = @"王小二";
    self.nameLab.textColor = [UIColor whiteColor];
    self.nameLab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//距离底部距离不变
    [self.topView addSubview:self.nameLab];
    self.nameLab.sd_layout.centerXEqualToView(self.topView);
    
    [self.head addSubview:self.topView];
    self.tableView.tableHeaderView = self.head;
    
    [self.tableView sendSubviewToBack:self.tableView.tableHeaderView];
    
    [self.view addSubview:self.tableView];
    
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"film_index_add" highImageName:@"film_index_add" target:self action:@selector(leftNavBtnClicked:)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"film_index_my" highImageName:@"film_index_my" target:self action:@selector(rightNavBtnClicked:)];
}


- (void)setHead{
    //加载头像
    [self.headImgView setShadowWithType:EMIShadowPathCircle shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.35 shadowRadius:8 image:@"miller" placeholder:@"miller"];
}

//处理数据
- (void)handleData{
    for (int i = 0 ; i < self.sectionArray.count; i++) {
        [self.isshowArray addObject:@NO];
        [self.issselectedArray addObject:@NO];
    }
}

//我的资料
- (void)rightNavBtnClicked:(UIBarButtonItem *)sender{
    UIStoryboard *me = [UIStoryboard storyboardWithName:@"me" bundle:nil];
    MeViewController *viewController = [me instantiateViewControllerWithIdentifier:@"me"];
    [self.navigationController pushViewController:viewController animated:YES];
}
//新增拍片任务
- (void)leftNavBtnClicked:(UIBarButtonItem *)sender{
    [self performSegueWithIdentifier:@"toMakeTaskVC" sender:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    //替代tableview的视图
    /*
    if (self.sectionArray.count == 0) {
//        self.tableView.hidden = YES;
        self.noDataView = [[TableWithNoDataView alloc] initGesture];
        [self.view addSubview:self.noDataView];
        self.noDataView.sd_layout.heightRatioToView(self.tableView,1).widthRatioToView(self.tableView,1).centerXEqualToView(self.tableView).centerYEqualToView(self.tableView);
        
        [self.noDataView initLabel:@"暂无数据"];
        
        //点击刷新表格数据
        __unsafe_unretained typeof(self) weakSelf = self;
        [self.noDataView setBlock:^{
            [weakSelf.sectionArray addObject:@"1"];
            [weakSelf.tableView reloadData];
        }];
    }else{
        if (self.noDataView != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.noDataView.hidden = YES;
            });
            
//            self.tableView.hidden = NO;
        }
    }*/
    
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.isshowArray[section]  isEqual: @YES]) {
        return ((NSMutableArray *)(self.sectionArray[section])).count;
    }else{
        return 0;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PFHomeCell *cell = [PFHomeCell cellWithTableView:tableView];
    
    switch (indexPath.row) {
        case 0:
            [cell setValues:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2317499888,864114656&fm=116&gp=0.jpg" tailImg:@"" title:@"《让子弹飞》拍片任务接收"];
            
            break;
        case 1:
            [cell setValues:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2317499888,864114656&fm=116&gp=0.jpg" tailImg:@"film_index_task_finished" title:@"《让子弹飞》拍片任务已完成"];
            
            break;
        case 2:
            [cell setValues:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2317499888,864114656&fm=116&gp=0.jpg" tailImg:@"film_index_task_lost" title:@"《让子弹飞》拍片任务已失败"];
            
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55*autoSizeScaleY;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 101*autoSizeScaleY;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PFHomeSectionView *sectionView = [[PFHomeSectionView alloc] initWithType:@"1" imageName:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2317499888,864114656&fm=116&gp=0.jpg" titleStr:@"《让子弹飞》排片任务" bigNumStr:@"8" smallNumStr:@"0.5"];
    
    
    //背景色
    if ([self.issselectedArray[section]  isEqual: @YES]) {
        sectionView.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
    }else{
        sectionView.backgroundColor = [UIColor whiteColor];
    }
    
    
    //展开图标
    
    if ([self.isshowArray[section]  isEqual: @YES]) {
        [sectionView operateSection:YES];
    }else{
        [sectionView operateSection:NO];
    }
    __unsafe_unretained typeof(self) weakSelf = self;
//    __unsafe_unretained typeof(sectionView) weaksectionView = sectionView;
    [sectionView setBlock:^{
        
        if ([weakSelf.isshowArray[section]  isEqual: @YES]) {
            [weakSelf.isshowArray replaceObjectAtIndex:section withObject:@(NO)];
//            weaksectionView.isOpen = NO;
        }else{
            [weakSelf.isshowArray replaceObjectAtIndex:section withObject:@(YES)];
//            weaksectionView.isOpen = YES;
        }
        
        
        
        
        
        
        
        [weakSelf.issselectedArray replaceObjectAtIndex:section withObject:@YES];
        
        for (int i = 0;i < weakSelf.issselectedArray.count;i++){
            if (i != section){
                [weakSelf.issselectedArray replaceObjectAtIndex:i withObject:@NO];
            }
        }
        
        //刷新表格
        [weakSelf.tableView reloadData];
        

    }];
    return sectionView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"toUnDoVC" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"toDoneVC" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"toFailedVC" sender:self];
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//滑动

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    
    //图片高度
    CGFloat imageHeight = self.head.frame.size.height;
    //图片宽度
    CGFloat imageWidth = screenWidth;
    //图片上下偏移量
    CGFloat imageOffsetY = scrollView.contentOffset.y;
    
//    NSLog(@"图片上下偏移量 imageOffsetY:%f ->",imageOffsetY);
    
    
    
    //上移
    if (imageOffsetY < 0) {
        CGFloat totalOffset = imageHeight + ABS(imageOffsetY);
        CGFloat f = totalOffset / imageHeight;
        
        self.topView.frame = CGRectMake(-(imageWidth * f - imageWidth) * 0.5, imageOffsetY, imageWidth * f, totalOffset);
    }
    
        //下移
        if (imageOffsetY > 0) {
            CGFloat totalOffset = imageHeight + ABS(imageOffsetY);
//            CGFloat f = totalOffset / imageHeight;
    
            [self.topView setFrame:CGRectMake(0, -imageOffsetY/2, imageWidth, totalOffset)];
        }


    return;
}




//处理视图位置的变化
- (void)handleViewPosition:(UIScrollView *)sc{
    
    
    
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
