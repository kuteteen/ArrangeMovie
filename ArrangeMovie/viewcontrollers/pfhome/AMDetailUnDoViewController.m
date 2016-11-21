//
//  AMDetailUnDoViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/27.
//  Copyright © 2016年 EMI. All rights reserved.
//  排片任务已接受但是未完成（1.暂无排片2.已有排片，但是无审核的勾）

#import "AMDetailUnDoViewController.h"
#import "UIImageView+WebCache.h"
#import "UIView+Shadow.h"
#import "SCFadeSlideView.h"
#import "SCSlidePageView.h"
#import "UIView+SDAutoLayout.h"
#import "ProgressView.h"
#import "PYPhotoBrowseView.h"

@interface AMDetailUnDoViewController ()<SCFadeSlideViewDelegate,SCFadeSlideViewDataSource>
@property (nonatomic,strong) NSMutableArray *array;//数据源
@property (nonatomic,strong) SCFadeSlideView *slideView;//添加滑动的图片浏览

@property (strong,nonatomic) ProgressView *proView;
@end

@implementation AMDetailUnDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"排片详情";
    
    [self setRightNav:@""];
    
    self.array = [[NSMutableArray alloc] initWithCapacity:0];
    
    //假数据
    [self.array addObject:@"http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580"];
    [self.array addObject:@"http://img.hb.aicdn.com/d2024a8a998c8d3e4ba842e40223c23dfe1026c8bbf3-OudiPA_fw580"];
    
    [self initViews];
    
    [AppDelegate storyBoradAutoLay:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if ([headImgUrl isEqualToString:@""]) {
        headImgView.image = [UIImage imageNamed:@"miller"];
    }else{
        [headImgView sd_setImageWithURL:[NSURL URLWithString:headImgUrl] placeholderImage:[UIImage imageNamed:@"miller"]];
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
    
    ///添加初始的暂无排片按钮图片
    
    if (self.array.count == 0) {
        self.slideView.orginPageCount = 1;
    }else{
        self.slideView.orginPageCount = self.array.count;
    }
    
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
            CGFloat ratio = 1.f/self.array.count;
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
    //    跳转到排片详情的图片浏览器
    // 1. 创建photoBroseView对象
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
    
    // 2.1 设置图片源(UIImageView)数组
    //    photoBroseView.sourceImgageViews = imageViews;
    photoBroseView.imagesURL = self.array;
    // 2.2 设置初始化图片下标（即当前点击第几张图片）
    photoBroseView.currentIndex = 0;
    
    // 3.显示(浏览)
    [photoBroseView show];
}



#pragma mark SCFadeSlideView datasource
-(NSInteger)numberOfPagesInSlideView:(SCFadeSlideView *)slideView {
    
    if (self.array.count == 0) {
        return 1;
    }else{
        return self.array.count;

    }
}

-(UIView *)slideView:(SCFadeSlideView *)slideView cellForPageAtIndex:(NSInteger)index {
    SCSlidePageView *pageView = (SCSlidePageView *)[slideView dequeueReusableCell];
    if(!pageView){
        pageView = [[SCSlidePageView alloc] initWithFrame:CGRectMake(0, 0, (375)*autoSizeScaleX-84, 397*autoSizeScaleY)];
        pageView.layer.cornerRadius = 4;
        pageView.layer.masksToBounds = YES;
        pageView.backgroundColor = [UIColor clearColor];
        pageView.coverView.backgroundColor = [UIColor clearColor];
        
        EMIShadowImageView *shadowImageView;
        shadowImageView = [[EMIShadowImageView alloc] initWithFrame:pageView.frame];
        shadowImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if(self.array.count>0&&index<self.array.count){
            
            
            
            [shadowImageView setRectangleBorder:self.array[index]];
            
            [pageView addSubview:shadowImageView];
            
            //添加时间label
            //下方圆角
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, (397-61.5)*autoSizeScaleY, (375)*autoSizeScaleX-84, 61.5*autoSizeScaleY)];
            label.textColor = [UIColor colorWithHexString:@"15151b" alpha:1];
            label.font = [UIFont fontWithName:@"DroidSansFallback" size:18.f*autoSizeScaleY];
            label.text = @"2016-09-21排片情况";
            label.backgroundColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [shadowImageView addSubview:label];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:label.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(2, 2)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = label.bounds;
            maskLayer.path = maskPath.CGPath;
            label.layer.mask = maskLayer;
            
        }else{
            [shadowImageView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor colorWithHexString:@"162271"] shadowOffset:CGSizeZero shadowOpacity:0.15 shadowRadius:10 image:@"" placeholder:@"scfade_bg"];
            [pageView addSubview:shadowImageView];
            //添加"暂无排片"图片
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(85.5*autoSizeScaleX, 143.5*autoSizeScaleY, 120*autoSizeScaleX, 110*autoSizeScaleY)];
            [button setImage:[UIImage imageNamed:@"row_piece_move"] forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
            [pageView addSubview:button];
            
            //添加"暂无排片"Label
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 283.5*autoSizeScaleY, 291*autoSizeScaleX, 40*autoSizeScaleY)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"暂无排片，请稍后";
            label.textColor = [UIColor colorWithHexString:@"#aeafb3"];
            label.font = [UIFont fontWithName:@"DroidSansFallback" size:18.f*autoSizeScaleY];
            [pageView addSubview:label];
        }
        
        
        
        
    }
    return pageView;
}

//滚动到了第几页
- (void)didScrollToPage:(NSInteger)pageNumber inSlideView:(SCFadeSlideView *)slideView{
    NSLog(@"%ld",pageNumber);
    [self setProgressView:pageNumber];
}
//根据当前页数组的索引设置进度条的长度
- (void)setProgressView:(NSInteger)pageNumber{
    if (self.proView != nil) {
        CGFloat ratio = ((CGFloat)(pageNumber))/self.array.count;
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
