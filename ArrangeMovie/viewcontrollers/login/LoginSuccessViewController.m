//
//  LoginSuccessViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/11.
//  Copyright © 2016年 EMI. All rights reserved.
//  登录成功

#import "LoginSuccessViewController.h"
#import "PFHomeViewController.h"
#import "EMINavigationController.h"
#import "EMIRootViewController.h"
#import "ManagerIndexViewController.h"

@interface LoginSuccessViewController ()<RESideMenuDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet EMIShadowImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;

@end

@implementation LoginSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    //禁止返回
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    [AppDelegate storyBoradAutoLay:self.view];
    //字体大小
    [AppDelegate storyBoardAutoLabelFont:self.view];
    self.headImgView.frame = CGRectMake(self.headImgView.frame.origin.x, self.headImgView.frame.origin.y, self.headImgView.frame.size.height, self.headImgView.frame.size.height);
    self.headImgView.layer.masksToBounds = YES;
     self.headImgView.layer.cornerRadius = self.headImgView.frame.size.height/2;
    [self setHead];
    
    //动画改变视图透明度和位置
    [UIView animateWithDuration:3.0f animations:^{
        self.headImgView.alpha = 1;
        CGRect headframe = self.headImgView.frame;
        headframe.origin.y = 92*autoSizeScaleY;
        self.headImgView.frame = headframe;
        
        self.nameLab.alpha = 1;
        CGRect nameframe = self.nameLab.frame;
        nameframe.origin.y = 228*autoSizeScaleY;
        self.nameLab.frame = nameframe;
        
        self.bottomView.alpha = 1;
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setHead{
    
    self.nameLab.text = self.user.nickname;
    
    //加载头像
    if (self.headimg == nil) {
        [self.headImgView setImage:defaultheadimage];// todo
        
        //使线程睡眠4秒，页面跳转
        double delayInSeconds = 4.0;
        __block LoginSuccessViewController* bself = self;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [bself jumpMethod];
            
            
        });
        
        
        
    }else{
        //有默认用户头像
         __unsafe_unretained typeof(self) weakself = self;
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.headimg] placeholderImage:defaultheadimage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            
            //使线程睡眠4秒，页面跳转
            double delayInSeconds = 4.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [weakself jumpMethod];
                
                
            });
        }];
    }
}

- (void)jumpMethod{
    [self performSegueWithIdentifier:@"loginsuccesstowelcomeback" sender:self];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return NO;
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
