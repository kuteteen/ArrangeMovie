//
//  MeManagerAuthViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/13.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeAuthViewController.h"
#import "SCFadeSlideView.h"
#import "SCSlidePageView.h"
//#import "EMIShadowImageView.h"

#define width [UIScreen mainScreen].bounds.size.width
#define height [UIScreen mainScreen].bounds.size.height

@interface MeAuthViewController ()<SCFadeSlideViewDelegate,SCFadeSlideViewDataSource>

@property (nonatomic,strong) NSMutableArray *array;//数据源

@end

@implementation MeAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.user.usertype==0){
        self.title = @"资料审核";
    }else{
        self.title = @"认证院线经理";
    }
    [self initViewsWithUserType:self.user.usertype];
}

-(void)initViewsWithUserType:(int)type {
    //添加滑动的图片浏览
//    SCFadeSlideView *slideView = [[SCFadeSlideView alloc] initWithFrame:CGRectMake(0, 0, width, height-143)];
//    slideView.backgroundColor = [UIColor clearColor];
//    slideView.delegate = self;
//    slideView.datasource = self;
//    slideView.minimumPageAlpha = 0.4;
//    slideView.minimumPageScale = 0.85;
//    
//    ///添加初始的添加按钮图片
//    slideView.orginPageCount = 1;
//    slideView.orientation = SCFadeSlideViewOrientationHorizontal;
//    
//    /****************************
//     使用导航控制器(UINavigationController)
//     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
//     请使用UIScrollView作为SCFadeSlideView的容器View,才会显示正常,如下
//     *****************************/
//    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height-143)];
//    [bottomScrollView addSubview:slideView];
//    [self.view addSubview:bottomScrollView];
    
    
    if(type==0){
        //片方,添加圆形打钩按钮
        EMIShadowImageView *OKImgView = [[EMIShadowImageView alloc] initWithFrame:CGRectMake((width-58)/2, height-110, 58, 58)];
        [OKImgView setShadowWithType:EMIShadowPathRound shadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.3 shadowRadius:10 image:@"" placeholder:@"row_piece_review"];
//        OKImgView setHighlightedImage:[UIImage imageNamed:row]
        [self.view addSubview:OKImgView];
    }else if(type ==1){
        //添加下部Label文字说明
        
        //添加蓝色按钮"重新认证"

    }
    
    switch (type) {
        case 0:
            
            
            
            
            break;
        case 1:
            
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SCFadeSlideView delegate
-(CGSize)sizeForPageInSlideView:(SCFadeSlideView *)slideView {
    return CGSizeMake(width, height-143);
}

#pragma mark SCFadeSlideView datasource
-(NSInteger)numberOfPagesInSlideView:(SCFadeSlideView *)slideView {
    return self.array.count+1;
}

-(UIView *)slideView:(SCFadeSlideView *)slideView cellForPageAtIndex:(NSInteger)index {
    SCSlidePageView *pageView = (SCSlidePageView *)[slideView dequeueReusableCell];
    if(!pageView){
        pageView = [[SCSlidePageView alloc] initWithFrame:CGRectMake(0, 0, width - 84, height-110)];
        pageView.layer.cornerRadius = 4;
        pageView.layer.masksToBounds = YES;
        
    }
    return pageView;
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
