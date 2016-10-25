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
    SCFadeSlideView *slideView;
}

@property(nonatomic,strong)UIImagePickerController *camera;
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
    
}

-(void)initViewsWithUserType:(int)type {
    //添加滑动的图片浏览
    slideView = [[SCFadeSlideView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-143-104)];
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
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, Width, Height-143-104)];
    [bottomScrollView addSubview:slideView];
    [self.view addSubview:bottomScrollView];
    
    
    if(type==0){
        //片方,添加圆形打钩按钮
        EMIShadowImageView *OKImgView = [[EMIShadowImageView alloc] initWithFrame:CGRectMake((Width-58)/2, Height-110, 58, 58)];
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
    return CGSizeMake(slideView.frame.size.width-84, slideView.frame.size.height);
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
        pageView = [[SCSlidePageView alloc] initWithFrame:CGRectMake(0, 0, slideView.frame.size.width-84, slideView.frame.size.height)];
        pageView.layer.cornerRadius = 4;
        pageView.layer.masksToBounds = YES;
        pageView.backgroundColor = [UIColor clearColor];
        pageView.coverView.backgroundColor = [UIColor clearColor];
        
        EMIShadowImageView *shadowImageView;
        shadowImageView = [[EMIShadowImageView alloc] initWithFrame:pageView.frame];
        shadowImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if(self.array.count>0&&index<self.array.count){
            
            [shadowImageView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.3 shadowRadius:10 image:self.array[index] placeholder:@""];
            
            //添加删除按钮
            UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(pageView.frame.size.width-36, 10, 26, 30)];
            delBtn.tag = index;
            [delBtn addTarget:self action:@selector(delPhoto:) forControlEvents:UIControlEventTouchUpInside];
            [delBtn setBackgroundImage:[UIImage imageNamed:@"del_normal"] forState:UIControlStateNormal];
            
            
            //todo
            [pageView addSubview:shadowImageView];
            [pageView addSubview:delBtn];
        }else{
            [shadowImageView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.3 shadowRadius:10 image:@"" placeholder:@""];
            //添加"上传公司证件审核"图片
            [pageView addSubview:shadowImageView];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((pageView.frame.size.width-120)/2, (pageView.frame.size.height-110)/2, 120, 110)];
            [button setImage:[UIImage imageNamed:@"row_piece_upload_photo"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
            [pageView addSubview:button];
            
            //添加"上传公司证件审核"Label
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.origin.y+120+30, pageView.frame.size.width, 40)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"上传公司证件审核";
            [shadowImageView addSubview:label];
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
    [slideView reloadData];
}

-(void)takePicture {
    LCActionSheet *actionAlert = [LCActionSheet sheetWithTitle:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [actionAlert show];
}

//弹出框点击事件代理
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //拍照
//        self.camera = [[EMICamera alloc] init];
//        [self.camera takePhoto:self];
//        //获的照片的回调
//        __unsafe_unretained typeof(self) weakSelf = self;
//        [self.camera setBlock:^(UIImagePickerController *picker, NSDictionary<NSString *,id> *info) {
//            NSLog(@"%@",info);
//            [weakSelf dismissViewControllerAnimated:YES completion:nil];
//        }];
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
