//
//  AMDetailFailedViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/27.
//  Copyright © 2016年 EMI. All rights reserved.
//  排片失败

#import "AMDetailFailedViewController.h"
#import "UIImageView+WebCache.h"
#import "UIView+Shadow.h"
#import "SCFadeSlideView.h"
#import "SCSlidePageView.h"
#import "UIView+SDAutoLayout.h"
#import "ProgressView.h"
#import "PYPhotoBrowseView.h"
#import "UIImage+GIF.h"
#import "MBProgressHUD.h"
#import "PFAMDetailWebInterface.h"
#import "SCHttpOperation.h"
#import "TaskDetail.h"

@interface AMDetailFailedViewController ()<SCFadeSlideViewDelegate,SCFadeSlideViewDataSource>
@property (nonatomic,strong) NSMutableArray *array;//数据源
@property (nonatomic,strong) SCFadeSlideView *slideView;//添加滑动的图片浏览

@property (strong,nonatomic) ProgressView *proView;

@property (strong,nonatomic) MBProgressHUD *HUD;

@end

@implementation AMDetailFailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"排片详情";
    
    [self setRightNav:self.selectedTakeTask.headimg];
    
    self.array = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    [self initViews];
    
    [AppDelegate storyBoradAutoLay:self.view];
    
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//请求网络数据
- (void)fetchData{
    //加载动图
    UIImageView *loadimageView = [[UIImageView alloc] initWithImage:[UIImage sd_animatedGIFNamed:@"loading_120"]];
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.2];
    self.HUD.bezelView.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:0.8];
    //        HUD.bezelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_bj"]];
    //        HUD.bezelView.tintColor = [UIColor clearColor];
    
    self.HUD.bezelView.layer.cornerRadius = 16;
    self.HUD.mode = MBProgressHUDModeCustomView;
    //        HUD.mode = MBProgressHUDModeIndeterminate;
    self.HUD.customView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    self.HUD.customView = loadimageView;
    self.HUD.margin = 5;
    NSLog(@"HUD的margin:%f",self.HUD.margin);
    //    HUD.delegate = self;
    self.HUD.square = YES;
    [self.HUD showAnimated:YES];
    
    __unsafe_unretained typeof (self) weakself = self;
    PFAMDetailWebInterface *pfamdetailInterface = [[PFAMDetailWebInterface alloc] init];
     NSDictionary *param = [pfamdetailInterface inboxObject:@[@(self.user.userid),@(self.selectedTaskId),@(self.selectedTakeTask.taskdetailid),@(self.user.usertype)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:pfamdetailInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSMutableArray *result = [pfamdetailInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            self.array = [[NSMutableArray alloc] initWithArray:result[1]];
            //刷新
            [self.slideView reloadData];
        }else{
            [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
        }
        [self.HUD hideAnimated:YES];
    } WithErrorCodeBlock:^(id errorCode) {
        [weakself.view makeToast:@"请求出错" duration:2.0 position:CSToastPositionCenter];
        [self.HUD hideAnimated:YES];
    } WithFailureBlock:^{
        [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
        [self.HUD hideAnimated:YES];
    }];
    
}


/**
 *  设置右边的头像
 *
 *  @param headImgUrl 网络地址
 */
- (void)setRightNav:(NSString *)headImgUrl{
    
    UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    //圆角
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.cornerRadius = 14;
    
    if ([headImgUrl isEqualToString:@""] || headImgUrl == nil) {
        headImgView.image = defaultheadimage;
    }else{
        [headImgView sd_setImageWithURL:[NSURL URLWithString:headImgUrl] placeholderImage:defaultheadimage];
    }
    
    UIBarButtonItem *rightNav = [[UIBarButtonItem alloc] initWithCustomView:headImgView];
    self.navigationItem.rightBarButtonItem = rightNav;
}

-(void)initViews {
    //添加滑动的图片浏览
    self.slideView = [[SCFadeSlideView alloc] initWithFrame:CGRectMake(0, 0, 375*autoSizeScaleX, 397*autoSizeScaleY)];
    self.slideView.backgroundColor = [UIColor clearColor];
    self.slideView.delegate = self;
    self.slideView.datasource = self;
    self.slideView.minimumPageAlpha = 0.4;
    self.slideView.minimumPageScale = 0.85;
    
    ///添加初始的添加按钮图片
    self.slideView.orginPageCount = 1;
    self.slideView.orientation = SCFadeSlideViewOrientationHorizontal;
    
    /****************************
     使用导航控制器(UINavigationController)
     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
     请使用UIScrollView作为SCFadeSlideView的容器View,才会显示正常,如下
     *****************************/
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 94, 375, 397)];
    [bottomScrollView addSubview:self.slideView];
    [self.view addSubview:bottomScrollView];
    
    
    //进度条
    self.proView = [[ProgressView alloc] initWithNewFrame:CGRectMake(89.5, 563, 196, 3)];
    [self.view addSubview:self.proView];
    [self showProView];
    
}


//控制进度条显示与隐藏
- (void)showProView{
    if (self.proView != nil) {
        if (self.array.count > 0) {
            self.proView.hidden = NO;
            CGFloat ratio = 1.f/(self.array.count+1);
            [self.proView setTopViewWithRatio:ratio];
        }else{
            self.proView.hidden = YES;
        }
    }
}

#pragma mark SCFadeSlideView delegate
-(CGSize)sizeForPageInSlideView:(SCFadeSlideView *)slideView {
     return CGSizeMake((375)*autoSizeScaleX-84, 397*autoSizeScaleY);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    NSLog(@"点击了第%ld项",(long)subIndex);
    
    if (subIndex != 0) {
        TaskDetail *taskdetail = [TaskDetail mj_objectWithKeyValues:self.array[subIndex-1]];
        //    跳转到排片详情的图片浏览器
        // 1. 创建photoBroseView对象
        PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
        
        // 2.1 设置图片源(UIImageView)数组
        //    photoBroseView.sourceImgageViews = imageViews;
        photoBroseView.imagesURL = taskdetail.imgs;
        // 2.2 设置初始化图片下标（即当前点击第几张图片）
        photoBroseView.currentIndex = 0;
        
        // 3.显示(浏览)
        [photoBroseView show];
    }
    
}



#pragma mark SCFadeSlideView datasource
-(NSInteger)numberOfPagesInSlideView:(SCFadeSlideView *)slideView {
    
    return self.array.count+1;
}

-(UIView *)slideView:(SCFadeSlideView *)slideView cellForPageAtIndex:(NSInteger)index {
    SCSlidePageView *pageView = (SCSlidePageView *)[slideView dequeueReusableCell];
    if(!pageView){
        pageView = [[SCSlidePageView alloc] initWithFrame:CGRectMake(0, 0, (375)*autoSizeScaleX-84, 397*autoSizeScaleY)];
        pageView.layer.cornerRadius = 2;
        pageView.layer.masksToBounds = YES;
        pageView.backgroundColor = [UIColor clearColor];
        pageView.coverView.backgroundColor = [UIColor clearColor];
        
        EMIShadowImageView *shadowImageView;
        shadowImageView = [[EMIShadowImageView alloc] initWithFrame:CGRectMake(9*autoSizeScaleX, 9*autoSizeScaleY, pageView.frame.size.width-18*autoSizeScaleX, pageView.frame.size.height-18*autoSizeScaleY)];
        shadowImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if(index != 0){
            
            TaskDetail *taskdetail = [TaskDetail mj_objectWithKeyValues:self.array[index-1]];
            
            [shadowImageView setRectangleBorder:taskdetail.imgs[0]];
            
            [pageView addSubview:shadowImageView];
            
            //添加时间label
            //下方圆角
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, (397-61.5-18)*autoSizeScaleY, (375)*autoSizeScaleX-84-18*autoSizeScaleX, 61.5*autoSizeScaleY)];
            label.textColor = [UIColor colorWithHexString:@"aeafb3" alpha:1];
            label.font = [UIFont fontWithName:@"DroidSansFallback" size:18.f*autoSizeScaleY];
            label.text = [NSString stringWithFormat:@"%@排片详情",taskdetail.imgdate];
            label.backgroundColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [shadowImageView addSubview:label];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:label.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(2, 2)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = label.bounds;
            maskLayer.path = maskPath.CGPath;
            label.layer.mask = maskLayer;
            
        }else{
            [shadowImageView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor colorWithHexString:@"162271"] shadowOffset:CGSizeZero shadowOpacity:0.15 shadowRadius:9 image:@"" placeholder:@"scfade_bg"];
            [pageView addSubview:shadowImageView];
            //添加"排片未完成"图片
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(85.5*autoSizeScaleX, 143.5*autoSizeScaleY, 120*autoSizeScaleX, 110*autoSizeScaleY)];
            [button setImage:[UIImage imageNamed:@"row_piece_unfinished"] forState:UIControlStateNormal];
            //            [button addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
            [pageView addSubview:button];
            
            //添加"排片未完成""Label
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 283.5*autoSizeScaleY, 291*autoSizeScaleX, 40*autoSizeScaleY)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"排片任务未完成";
            label.textColor = [UIColor colorWithHexString:@"#aeafb3"];
            label.font = [UIFont fontWithName:@"DroidSansFallback" size:18.f*autoSizeScaleY];
            [pageView addSubview:label];
        }
        
        
        
        
    }
    return pageView;
}

//滚动到了第几页
- (void)didScrollToPage:(NSInteger)pageNumber inSlideView:(SCFadeSlideView *)slideView{
    NSLog(@"%ld",(long)pageNumber);
    [self setProgressView:pageNumber];
}
//根据当前页数组的索引设置进度条的长度
- (void)setProgressView:(NSInteger)pageNumber{
    if (self.proView != nil) {
        CGFloat ratio = ((CGFloat)(pageNumber))/(self.array.count+1);
        [self.proView setXWithRatio:ratio];
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
