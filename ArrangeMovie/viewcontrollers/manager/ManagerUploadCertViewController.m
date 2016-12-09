//
//  ManagerUploadCertViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/12/3.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ManagerUploadCertViewController.h"
#import "EMICamera.h"
#import "SCFadeSlideView.h"
#import "UploadFile.h"
#import "LCActionSheet.h"
#import "SCSlidePageView.h"
#import "TZImagePickerController.h"
#import "UploadProofWebInterface.h"
#import "ManagerUploadCertWebInterface.h"
#import "SCDateTools.h"
#import "SCHttpOperation.h"
#import "ManagerToAuthTaskWebInterface.h"
#import "UIView+Shadow.h"
#import "TaskImgWebInterface.h"

@interface ManagerUploadCertViewController ()<SCFadeSlideViewDelegate,SCFadeSlideViewDataSource,LCActionSheetDelegate,UploadFileDelegate>

@property(nonatomic,strong) EMICamera *camera;
@property (nonatomic,strong) NSMutableArray *array;//数据源
@property (nonatomic,strong) SCFadeSlideView *slideView;//添加滑动的图片浏览

@property (nonatomic,strong)UploadFile *uploadUtil;//上传图片的类


@property (nonatomic,strong)NSMutableArray *alreadyImgarrays;//往期已经上传过得图片

//上传后的图片地址数组
@property (nonatomic,strong)NSMutableArray <NSString *> *imgUrlArrays;
@property (nonatomic,strong)NSMutableArray <NSString *> *imgPathArrays;
@end

@implementation ManagerUploadCertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"排片详情";
    
    self.array = [[NSMutableArray alloc] initWithCapacity:0];
    self.alreadyImgarrays = [[NSMutableArray alloc] initWithCapacity:0];
    self.imgUrlArrays = [[NSMutableArray alloc] initWithCapacity:0];
    self.imgPathArrays = [[NSMutableArray alloc] initWithCapacity:0];
    [self initViews];
    [AppDelegate storyBoradAutoLay:self.view];
    
    __unsafe_unretained typeof (self) weakself = self;
    TaskImgWebInterface *pfamdetailInterface = [[TaskImgWebInterface alloc] init];
    NSDictionary *param = [pfamdetailInterface inboxObject:@[@(self.user.userid),@(self.task.taskid),@(self.task.data[0].taskdetailid),@(self.user.usertype)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:pfamdetailInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSMutableArray *result = [pfamdetailInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            weakself.alreadyImgarrays = [[NSMutableArray alloc] initWithArray:result[1]];
        }else{
//            [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
        }
        
    } WithErrorCodeBlock:^(id errorCode) {
//        [weakself.view makeToast:@"请求出错" duration:2.0 position:CSToastPositionCenter];
        
    } WithFailureBlock:^{
//        [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
        
    }];
}

-(void)initViews {
    
    //上传图片的工具类
    if (self.uploadUtil == nil) {
        self.uploadUtil = [[UploadFile alloc] initWithViewController:self];
        self.uploadUtil.delegate = self;
    }
    
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
    
    
    
    
    //片方,添加圆形打钩按钮
    EMIShadowImageView *OKImgView = [[EMIShadowImageView alloc] initWithFrame:CGRectMake(150.5, 550, 74, 74)];
    OKImgView.image = [UIImage imageNamed:@"row_piece_review"];
    //        OKImgView setHighlightedImage:[UIImage imageNamed:row]
    [self.view addSubview:OKImgView];
    OKImgView.userInteractionEnabled = YES;
    //打钩的点击手势
    UITapGestureRecognizer *okGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(okImgClicked:)];
    [OKImgView addGestureRecognizer:okGesture];
    
    
    //右侧navBtn
    UIBarButtonItem *rightNavBtn = [[UIBarButtonItem alloc] initWithTitle:@"审核" style:UIBarButtonItemStyleDone target:self action:@selector(rightNavBtnClicked:)];
    [rightNavBtn setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"DroidSans-Bold" size:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [rightNavBtn setTintColor:[UIColor whiteColor]];
    
    //    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    negativeSpacer.width = 14.2*autoSizeScaleX;
    //    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,rightNavBtn, nil];
    self.navigationItem.rightBarButtonItem = rightNavBtn;
}

//审核
- (void)rightNavBtnClicked:(UIBarButtonItem *)sender{
    
    
    if (self.alreadyImgarrays.count == 0) {
        [self.view makeToast:@"从未上传过任何凭证，无法提交审核" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    
    __unsafe_unretained typeof (self) weakself = self;
    ManagerToAuthTaskWebInterface *pfauthInterface = [[ManagerToAuthTaskWebInterface alloc] init];
    NSDictionary *param = [pfauthInterface inboxObject:@[@(self.user.userid),@(self.task.taskid),@(self.task.taskdetailid),@(self.user.usertype)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:pfauthInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [pfauthInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            [weakself.view makeToast:@"提交审核成功" duration:2.0 position:CSToastPositionCenter];
            //返回上一页的上一页
            int index = (int)[[weakself.navigationController viewControllers]indexOfObject:weakself];
            
            [weakself.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
        }else{
            [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
        }
    } WithErrorCodeBlock:^(id errorCode) {
        [weakself.view makeToast:@"请求错误" duration:2.0 position:CSToastPositionCenter];
    } WithFailureBlock:^{
        [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
    }];
}

//蓝色完成圆勾点击事件
- (void)okImgClicked:(UITapGestureRecognizer *)sender{
    
    if (self.array.count == 0) {
        [self.view makeToast:@"请至少选择一张图片" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    
    [self.uploadUtil uploadFileWithURL:[NSURL URLWithString:imgUploadServerIP] data:UIImagePNGRepresentation(self.array[0])];
    
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
            
            [shadowImageView setRectangleBorder:self.array[index]];
            
            
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
            
            label.text = @"上传电影排片认证";
            
            
            label.textColor = [UIColor colorWithHexString:@"#aeafb3"];
            label.font = [UIFont fontWithName:@"DroidSansFallback" size:18.f*autoSizeScaleY];
            [pageView addSubview:label];
        }
        
    }
    return pageView;
    
}

-(void)delPhoto:(UIButton *)sender {
    [self.array removeObjectAtIndex:sender.tag];
    [self.slideView reloadData];
}

-(void)takePicture {
    if (self.array.count == 9) {
        [self.view makeToast:@"最多只能选择九张图片!" duration:2.0 position:CSToastPositionCenter];
    }else{
        //点击了最后一个加图的按钮
        LCActionSheet *actionAlert = [LCActionSheet sheetWithTitle:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍一张",@"从手机相册中选择", nil];
        [actionAlert show];
    }
}

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

- (void)returnImagePath:(NSArray *)resultimg{
    [self.imgPathArrays addObject:resultimg[0]];
    [self.imgUrlArrays addObject:resultimg[1]];
    if (self.imgUrlArrays.count == self.array.count) {
        
            __unsafe_unretained typeof (self) weakself = self;
            ManagerUploadCertWebInterface *pfauthInterface = [[ManagerUploadCertWebInterface alloc] init];
            NSDictionary *param = [pfauthInterface inboxObject:@[@(self.user.userid),@(1),@(self.task.taskid),@(self.task.taskdetailid),[SCDateTools dateToString:[NSDate date]],self.imgPathArrays,@(self.user.usertype)]];
            [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:pfauthInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
                NSArray *result = [pfauthInterface unboxObject:returnValue];
                if ([result[0] intValue] == 1) {
                    [weakself.view makeToast:@"上传成功" duration:2.0 position:CSToastPositionCenter];
                    //返回上一页
                    [weakself.navigationController popViewControllerAnimated:YES];
                }else{
                    [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
                }
            } WithErrorCodeBlock:^(id errorCode) {
                [weakself.view makeToast:@"请求错误" duration:2.0 position:CSToastPositionCenter];
            } WithFailureBlock:^{
                [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
            }];
        
    }else{
        [self.uploadUtil uploadFileWithURL:[NSURL URLWithString:imgUploadServerIP] data:UIImagePNGRepresentation(self.array[self.imgUrlArrays.count])];
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
