//
//  LoginAuthViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "LoginAuthViewController.h"
#import "SCFadeSlideView.h"
#import "SCSlidePageView.h"
#import "UIView+SDAutoLayout.h"
#import "UIView+Toast.h"
#import "ManagerIndexViewController.h"
#import "MeViewController.h"
#import "EMIRootViewController.h"

@interface LoginAuthViewController ()<SCFadeSlideViewDelegate,SCFadeSlideViewDataSource,LCActionSheetDelegate,RESideMenuDelegate>
@property (nonatomic,strong) NSMutableArray *array;//数据源
@property (nonatomic,strong) SCFadeSlideView *slideView;//添加滑动的图片浏览
@end

@implementation LoginAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"认证院线经理";
    
    self.array = [[NSMutableArray alloc] initWithCapacity:0];
    [self initViews];
    
    [AppDelegate storyBoradAutoLay:self.view];
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
    
    //注
    UILabel *zhuLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 501, 341, 40)];
    zhuLabel.font = [UIFont fontWithName:@"DroidSansFallback" size:16.f];
    zhuLabel.textAlignment = NSTextAlignmentCenter;
    zhuLabel.numberOfLines = 0;
    zhuLabel.text = @"注:认证院线等级越高，可以接到奖励更高的任务";
    zhuLabel.textColor = [UIColor colorWithHexString:@"#9FA6BC"];
    [self.view addSubview:zhuLabel];
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//蓝色完成圆勾点击事件
- (void)okImgClicked:(UITapGestureRecognizer *)sender{
    //上传完图片后到院方首页
    
    
        UIStoryboard *manager = [UIStoryboard storyboardWithName:@"manager" bundle:nil];
        ManagerIndexViewController *managerIndexVC = [manager instantiateViewControllerWithIdentifier:@"manager"];
        //假数据 用户
        User *user = [[User alloc] init];
    
        user.name = @"冯小刚";
        user.dn = @"1577470000";
        user.usertype = 0;
        user.sex = @"男";
        user.headimg = @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580";
        user.gradename = @"A级影院";
        managerIndexVC.user = user;
        EMINavigationController *managerNav = [[EMINavigationController alloc] initWithRootViewController:managerIndexVC];
        [self presentViewController:managerNav animated:YES completion:nil];
}



#pragma mark SCFadeSlideView delegate
-(CGSize)sizeForPageInSlideView:(SCFadeSlideView *)slideView {
    return CGSizeMake(375*autoSizeScaleX-84, (397)*autoSizeScaleY);
}

//- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
//    NSLog(@"点击了第%ld项",(long)subIndex);
//    
//}

//弹出框点击事件代理
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    __unsafe_unretained typeof(self) weakSelf = self;
    if (buttonIndex == 1) {
        //拍照
        self.camera = [[EMICamera alloc] init];
        [self.camera takePhoto:self];
        //获的照片的回调
        
        [self.camera setBlock:^(UIImagePickerController *picker, NSDictionary<NSString *,id> *info) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            //获取图片
            UIImage *currentimage = [info objectForKey:UIImagePickerControllerOriginalImage];
            //相机需要把图片存进相蒲
            
            if (currentimage != nil) {
                //存进相蒲
                //                UIImageWriteToSavedPhotosAlbum(currentimage, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                [weakSelf.array addObject:currentimage];
                [weakSelf.slideView reloadData];
                //刷新后得重置其子视图的位置
//                [AppDelegate storyBoradAutoLay:weakSelf.slideView];
            }
            
        }];
    }
    if (buttonIndex == 2) {
        //从相册选
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:9-self.array.count delegate:nil];
        [imagePicker.navigationBar setBarTintColor:[UIColor colorWithHexString:@"162271"]];
        //隐藏内部拍照按钮
        imagePicker.allowTakePicture = NO;
        [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL flag) {
            for (UIImage *item in photos) {
                [weakSelf.array addObject:item];
            }
            [weakSelf.slideView reloadData];
            //刷新后得重置其子视图的位置
//            [AppDelegate storyBoradAutoLay:weakSelf.slideView];
        }];
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

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
//        [pageView setCornerRadiusShadowWithshadowColor:[UIColor colorWithHexString:@"162271"] shadowOffset:CGSizeZero shadowOpacity:0.15 shadowRadius:4.5*autoSizeScaleY];
        pageView.backgroundColor = [UIColor clearColor];
        pageView.coverView.backgroundColor = [UIColor clearColor];
        
        EMIShadowImageView *shadowImageView;
        shadowImageView = [[EMIShadowImageView alloc] initWithFrame:CGRectMake(9*autoSizeScaleX, 9*autoSizeScaleY, pageView.frame.size.width-18*autoSizeScaleX, pageView.frame.size.height-18*autoSizeScaleY)];
        shadowImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if(self.array.count>0&&index<self.array.count){
            
            [shadowImageView setRectangleBorder:self.array[index]];
            
            [pageView addSubview:shadowImageView];
            //删除按钮
            UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake((375-41)*autoSizeScaleX-84, 12*autoSizeScaleY, 29*autoSizeScaleX, 29*autoSizeScaleY)];
            delBtn.tag = index;
            [delBtn addTarget:self action:@selector(delPhoto:) forControlEvents:UIControlEventTouchUpInside];
            [delBtn setBackgroundImage:[UIImage imageNamed:@"photo_del"] forState:UIControlStateNormal];
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


//滚动到了第几页
- (void)didScrollToPage:(NSInteger)pageNumber inSlideView:(SCFadeSlideView *)slideView{
    NSLog(@"%ld",pageNumber);
}

//新增照片
- (void)takePicture{
    if (self.array.count == 9) {
        [self.view makeToast:@"最多只能选择九张图片!" duration:2.0 position:CSToastPositionCenter];
    }else{
        //点击了最后一个加图的按钮
        LCActionSheet *actionAlert = [LCActionSheet sheetWithTitle:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍一张",@"从手机相册中选择", nil];
        [actionAlert show];
    }
    
    
}

//删除照片
- (void)delPhoto:(UIButton *)sender{
    [self.array removeObjectAtIndex:sender.tag];
    [self.slideView reloadData];
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
