//
//  PFUploadImgViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/28.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "PFUploadImgViewController.h"
#import "SCFadeSlideView.h"
#import "SCSlidePageView.h"
#import "UIView+SDAutoLayout.h"
#import "UIView+Toast.h"
#import "ManagerIndexViewController.h"

@interface PFUploadImgViewController ()<SCFadeSlideViewDelegate,SCFadeSlideViewDataSource,LCActionSheetDelegate>
@property (nonatomic,strong) NSMutableArray *array;//数据源
@property (nonatomic,strong) SCFadeSlideView *slideView;//添加滑动的图片浏览
@end

@implementation PFUploadImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"上传图片";
    self.array = [[NSMutableArray alloc] initWithCapacity:0];
    [self initViews];
}

-(void)initViews {
    //添加滑动的图片浏览
    self.slideView = [[SCFadeSlideView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-143-104)];
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
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, screenWidth, screenHeight-143-104)];
    [bottomScrollView addSubview:self.slideView];
    [self.view addSubview:bottomScrollView];
    
    //片方,添加圆形打钩按钮
    EMIShadowImageView *OKImgView = [[EMIShadowImageView alloc] initWithFrame:CGRectMake((screenWidth-58)/2, screenHeight-100, 58, 58)];
    [OKImgView setShadowWithType:EMIShadowPathRound shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeZero shadowOpacity:0.35 shadowRadius:10 image:@"" placeholder:@"row_piece_review"];
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
    
    
}



#pragma mark SCFadeSlideView delegate
-(CGSize)sizeForPageInSlideView:(SCFadeSlideView *)slideView {
    return CGSizeMake(slideView.frame.size.width-84, slideView.frame.size.height);
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
            }
            
        }];
    }
    if (buttonIndex == 2) {
        //从相册选
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:9-self.array.count delegate:nil];
        //隐藏内部拍照按钮
        imagePicker.allowTakePicture = NO;
        [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL flag) {
            for (UIImage *item in photos) {
                [weakSelf.array addObject:item];
            }
            [weakSelf.slideView reloadData];
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
        pageView = [[SCSlidePageView alloc] initWithFrame:CGRectMake(0, 0, slideView.frame.size.width-84, slideView.frame.size.height)];
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
            //删除按钮
            UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(slideView.frame.size.width-84-36, 10, 26, 30)];
            delBtn.tag = index;
            [delBtn addTarget:self action:@selector(delPhoto:) forControlEvents:UIControlEventTouchUpInside];
            [delBtn setBackgroundImage:[UIImage imageNamed:@"del_normal"] forState:UIControlStateNormal];
            [pageView addSubview:delBtn];
            
        }else{
            [shadowImageView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeZero shadowOpacity:0.26 shadowRadius:10 image:@"" placeholder:@""];
            [pageView addSubview:shadowImageView];
            //添加"上传图片"图片
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((pageView.frame.size.width-120)/2, (pageView.frame.size.height-110)/2, 120, 110)];
            [button setImage:[UIImage imageNamed:@"row_piece_upload_photo"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
            [pageView addSubview:button];
            //添加"上传图片"Label
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"上传图片";
            label.textColor = [UIColor colorWithHexString:@"#999999"];
            label.font = [UIFont systemFontOfSize:18.f];
            [pageView addSubview:label];
            label.sd_layout.topSpaceToView(button,15).widthRatioToView(pageView,1).leftSpaceToView(pageView,0).heightIs(40);
        }
        
        
        
        
    }
    return pageView;
}


//新增照片
- (void)takePicture{
    if (self.array.count == 9) {
        [self.view makeToast:@"最多只能选择九张图片!" duration:2.0 position:CSToastPositionCenter];
    }else{
        //点击了最后一个加图的按钮
        LCActionSheet *actionAlert = [LCActionSheet sheetWithTitle:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
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
