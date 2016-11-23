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
#import "LCActionSheet.h"
#import "TZImagePickerController.h"
#import "EMICamera.h"
//#import "EMIShadowImageView.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface MeAuthViewController ()<SCFadeSlideViewDelegate,SCFadeSlideViewDataSource,LCActionSheetDelegate> {
    SCFadeSlideView *_slideView;
}

@property(nonatomic,strong) EMICamera *camera;
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

//    self.array = [[NSMutableArray alloc] init];
    self.array = @[@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580"];
    [self initViewsWithUserType:self.user.usertype];
    [AppDelegate storyBoradAutoLay:self.view];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu"
                                                        object:self
                                                      userInfo:nil];
}

-(void)initViewsWithUserType:(int)type {
    //添加滑动的图片浏览
    _slideView = [[SCFadeSlideView alloc] initWithFrame:CGRectMake(0, 0, 375*autoSizeScaleX, 397*autoSizeScaleY)];
    _slideView.backgroundColor = [UIColor clearColor];
    _slideView.delegate = self;
    _slideView.datasource = self;
    _slideView.minimumPageAlpha = 0.4;
    _slideView.minimumPageScale = 0.85;

    ///添加初始的添加按钮图片
    _slideView.orginPageCount = 1;
    _slideView.orientation = SCFadeSlideViewOrientationHorizontal;

    /****************************
     使用导航控制器(UINavigationController)
     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
     请使用UIScrollView作为SCFadeSlideView的容器View,才会显示正常,如下
     *****************************/
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 94, 375, 397)];
    [bottomScrollView addSubview:_slideView];
    [self.view addSubview:bottomScrollView];


    if(type==0){
        //片方,添加圆形打钩按钮
        EMIShadowImageView *OKImgView = [[EMIShadowImageView alloc] initWithFrame:CGRectMake(150.5, 550, 74, 74)];
        //    [OKImgView setShadowWithType:EMIShadowPathRound shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeZero shadowOpacity:0.35 shadowRadius:10 image:@"" placeholder:@"row_piece_review"];
        OKImgView.image = [UIImage imageNamed:@"row_piece_review"];
        //        OKImgView setHighlightedImage:[UIImage imageNamed:row]
        [self.view addSubview:OKImgView];
        OKImgView.userInteractionEnabled = YES;
        //打钩的点击手势
        UITapGestureRecognizer *okGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(okImgClicked:)];
        [OKImgView addGestureRecognizer:okGesture];
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

//蓝色完成圆勾点击事件
- (void)okImgClicked:(UITapGestureRecognizer *)sender{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SCFadeSlideView delegate
-(CGSize)sizeForPageInSlideView:(SCFadeSlideView *)slideView {
    return CGSizeMake(375*autoSizeScaleX-84, (397)*autoSizeScaleY);
}

//- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
//    NSLog(@"点击了第%ld项",(long)subIndex);
////    [self takePicture];
//}

#pragma mark SCFadeSlideView datasource
-(NSInteger)numberOfPagesInSlideView:(SCFadeSlideView *)slideView {
    return self.array.count+1;
}

-(UIView *)slideView:(SCFadeSlideView *)slideView cellForPageAtIndex:(NSInteger)index {
    SCSlidePageView *pageView = (SCSlidePageView *)[slideView dequeueReusableCell];
    if(!pageView){
       pageView = [[SCSlidePageView alloc] initWithFrame:CGRectMake(0, 0, 375*autoSizeScaleX-84, (397)*autoSizeScaleY)];
        pageView.layer.cornerRadius = 2;
        pageView.layer.masksToBounds = YES;
        pageView.backgroundColor = [UIColor clearColor];
//        pageView.coverView.backgroundColor =
        pageView.coverView.backgroundColor = [UIColor clearColor];

        EMIShadowImageView *shadowImageView;
        shadowImageView = [[EMIShadowImageView alloc] initWithFrame:CGRectMake(9*autoSizeScaleX, 9*autoSizeScaleY, pageView.frame.size.width-18*autoSizeScaleX, pageView.frame.size.height-18*autoSizeScaleY)];
        shadowImageView.contentMode = UIViewContentModeScaleAspectFit;

        if(self.array.count>0&&index<self.array.count){
            
            [shadowImageView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeZero shadowOpacity:0.26 shadowRadius:10 image:self.array[index] placeholder:@""];


            //删除按钮
            UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake((375-41)*autoSizeScaleX-84, 12*autoSizeScaleY, 29*autoSizeScaleX, 29*autoSizeScaleY)];
            delBtn.tag = index;
            [delBtn addTarget:self action:@selector(delPhoto:) forControlEvents:UIControlEventTouchUpInside];
            [delBtn setBackgroundImage:[UIImage imageNamed:@"photo_del"] forState:UIControlStateNormal];


            //todo
            [pageView addSubview:shadowImageView];
            [pageView addSubview:delBtn];
        }else{
            [shadowImageView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor colorWithHexString:@"162271"] shadowOffset:CGSizeZero shadowOpacity:0.15 shadowRadius:9 image:@"" placeholder:@"scfade_bg"];
            [pageView addSubview:shadowImageView];
            //添加"上传公司证件审核"图片
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(85.5*autoSizeScaleX, 143.5*autoSizeScaleY, 120*autoSizeScaleX, 110*autoSizeScaleY)];
            [button setImage:[UIImage imageNamed:@"row_piece_upload_photo"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
            [pageView addSubview:button];
            //添加"上传公司证件审核"Label
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 283.5*autoSizeScaleY, 291*autoSizeScaleX, 40*autoSizeScaleY)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"上传认证资质材料";
            label.textColor = [UIColor colorWithHexString:@"#aeafb3"];
            label.font = [UIFont fontWithName:@"DroidSansFallback" size:18.f*autoSizeScaleY];
            [pageView addSubview:label];
        }

    }
    return pageView;
}

-(void)delPhoto:(id)sender {
    UIButton *btn = sender;
    NSInteger tag = btn.tag;
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for(int i = 0;i<self.array.count;i++){
        if(i!=tag){
            [tempArray addObject:self.array[i]];
        }
    }
    self.array = [[NSMutableArray alloc] initWithArray:tempArray];
    [_slideView reloadData];
}

-(void)takePicture {
    LCActionSheet *actionAlert = [LCActionSheet sheetWithTitle:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [actionAlert show];
}

//弹出框点击事件代理
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //拍照
        self.camera = [[EMICamera alloc] init];
        [self.camera takePhoto:self];
        //获的照片的回调
        __unsafe_unretained typeof(self) weakSelf = self;
        [self.camera setBlock:^(UIImagePickerController *picker, NSDictionary<NSString *,id> *info) {
            NSLog(@"%@",info);
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    if (buttonIndex == 2) {
        //从相册选
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
        //隐藏内部拍照按钮
        imagePicker.allowTakePicture = NO;
        [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL flag) {
            NSLog(@"%@",photos[0]);
        }];

        [self presentViewController:imagePicker animated:YES completion:nil];
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
