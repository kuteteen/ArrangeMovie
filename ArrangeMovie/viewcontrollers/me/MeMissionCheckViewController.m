//
//  MeMissionCheckViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/19.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeMissionCheckViewController.h"
#import "SCFadeSlideView.h"
#import "SCSlidePageView.h"
#import "PYPhotoBrowseView.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface MeMissionCheckViewController ()<SCFadeSlideViewDelegate,SCFadeSlideViewDataSource> {
    SCFadeSlideView *slideView;
    UIView *lineBgView;
    UIView *pageControlView;
}
@property (nonatomic,strong) NSMutableArray *array;//数据源

@end

@implementation MeMissionCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"排片详情";
    
    self.array = @[@"http://cdnq.duitang.com/uploads/item/201506/05/20150605124315_xFQtw.thumb.700_0.jpeg",@"http://b.hiphotos.baidu.com/baike/c0%3Dbaike272%2C5%2C5%2C272%2C90/sign=529c869ec7fc1e17e9b284632bf99d66/1e30e924b899a9015d3d6abe15950a7b0208f529.jpg",@"http://p0.qhimg.com/t017f06c5631452f6bd.jpg"];
    [self initViews];
}

-(void)initViews {
    UIScrollView *bottomScrollView;
    if(self.isFinished){
        //需要添加审核通过按钮,形如✔️
        bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 94, Width, Height-123-64-30)];
        
        //片方,添加圆形打钩按钮
        EMIShadowImageView *OKImgView = [[EMIShadowImageView alloc] initWithFrame:CGRectMake((Width-58)/2, Height-110, 58, 58)];
        [OKImgView setShadowWithType:EMIShadowPathRound shadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.3 shadowRadius:10 image:@"" placeholder:@"row_piece_review"];
        
        UITapGestureRecognizer *authTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authMission)];
        [OKImgView addGestureRecognizer:authTap];
        
        [self.view addSubview:OKImgView];
    }else{
        bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, Width, Height-141-64-40)];
    }
    
    
    //添加滑动的图片浏览
    slideView = [[SCFadeSlideView alloc] initWithFrame:CGRectMake(0, 0, Width, bottomScrollView.frame.size.height)];
    slideView.backgroundColor = [UIColor clearColor];
    slideView.delegate = self;
    slideView.datasource = self;
    slideView.minimumPageAlpha = 0.4;
    slideView.minimumPageScale = 0.85;
    
    ///添加初始的添加按钮图片
    slideView.orginPageCount = 1;
    slideView.orientation = SCFadeSlideViewOrientationHorizontal;
    
    /****************************
     使用导航控制器(UINavigationController)
     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
     请使用UIScrollView作为SCFadeSlideView的容器View,才会显示正常,如下
     *****************************/
    
    [bottomScrollView addSubview:slideView];
    [self.view addSubview:bottomScrollView];
    
    
    //添加滑动的类pageControl
    if(self.array.count>0){
        lineBgView = [[UIView alloc] initWithFrame:CGRectMake(90, bottomScrollView.frame.origin.y+bottomScrollView.frame.size.height+45, Width-180, 3)];
        lineBgView.layer.masksToBounds = YES;
        lineBgView.layer.cornerRadius = 1.5;
        lineBgView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF" alpha:0.4];
        
        pageControlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (Width-180)/self.array.count, 3)];
        pageControlView.layer.masksToBounds = YES;
        pageControlView.layer.cornerRadius = 1.5;
        pageControlView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        
        [lineBgView addSubview:pageControlView];
        
        [self.view addSubview:lineBgView];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SCFadeSlideView delegate
-(CGSize)sizeForPageInSlideView:(SCFadeSlideView *)slideView {
    return CGSizeMake(slideView.frame.size.width-84, slideView.frame.size.height);
}

-(void)didScrollToPage:(NSInteger)pageNumber inSlideView:(SCFadeSlideView *)slideView {
    [UIView animateWithDuration: 0.35 delay: 0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{
        pageControlView.center = CGPointMake((2*pageNumber+1)*(Width-180)/self.array.count/2, 1.5);
    } completion: ^(BOOL finished) {
        
    }];
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    NSLog(@"点击了第%ld项",(long)subIndex);
    
//    跳转到排片详情的图片浏览器
    // 1. 创建photoBroseView对象
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
    
    // 2.1 设置图片源(UIImageView)数组
//    photoBroseView.sourceImgageViews = imageViews;
    photoBroseView.imagesURL = @[@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580",@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580"];
    // 2.2 设置初始化图片下标（即当前点击第几张图片）
    photoBroseView.currentIndex = 0;
    
    // 3.显示(浏览)
    [photoBroseView show];
}

#pragma mark SCFadeSlideView datasource
-(NSInteger)numberOfPagesInSlideView:(SCFadeSlideView *)slideView {
    if(self.array.count==0){
        return 1;
    }
    return self.array.count;
}

-(UIView *)slideView:(SCFadeSlideView *)slideView cellForPageAtIndex:(NSInteger)index {
    SCSlidePageView *pageView = (SCSlidePageView *)[slideView dequeueReusableCell];
    if(!pageView){
        pageView = [[SCSlidePageView alloc] initWithFrame:CGRectMake(0, 0, slideView.frame.size.width-84, slideView.frame.size.height)];
        pageView.layer.cornerRadius = 4;
        pageView.layer.masksToBounds = YES;
        pageView.backgroundColor = [UIColor clearColor];
        pageView.coverView.backgroundColor = [UIColor clearColor];
        
        EMIShadowImageView *shadowImageView;
        shadowImageView = [[EMIShadowImageView alloc] initWithFrame:pageView.frame];
        shadowImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if(self.array.count>0&&index<self.array.count){
            
            [shadowImageView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.8 shadowRadius:10 image:self.array[index] placeholder:@""];
            [pageView addSubview:shadowImageView];
            
            
            //添加时间label
            //下方圆角
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, pageView.frame.size.height-62, pageView.frame.size.width, 62)];
            label.textColor = [UIColor colorWithHexString:@"15151b" alpha:1];
            label.font = [UIFont systemFontOfSize:18.f];
            label.text = @"2016/09/21排片情况";
            label.backgroundColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [shadowImageView addSubview:label];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:label.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(2, 2)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = label.bounds;
            maskLayer.path = maskPath.CGPath;
            label.layer.mask = maskLayer;
            
            
        }else{
            [shadowImageView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.3 shadowRadius:10 image:@"" placeholder:@""];
            //添加"上传公司证件审核"图片
            [pageView addSubview:shadowImageView];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((pageView.frame.size.width-120)/2, (pageView.frame.size.height-110)/2, 120, 110)];
            [button setImage:[UIImage imageNamed:@"row_piece_unfinished"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
            [pageView addSubview:button];
            
            //添加"上传公司证件审核"Label
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.origin.y+120+30, pageView.frame.size.width, 40)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"排片任务未完成";
            [shadowImageView addSubview:label];
        }
        
    }
    return pageView;
}


-(void)authMission {
    
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
