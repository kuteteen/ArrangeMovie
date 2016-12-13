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
#import "OuPresentAnimation.h"

@interface LoginSuccessViewController ()<RESideMenuDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet EMIShadowImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;

@end

@implementation LoginSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transitioningDelegate = self;
    
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
    [UIView animateWithDuration:2.0f animations:^{
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
            double delayInSeconds = 2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [weakself jumpMethod];
                
                
            });
        }];
    }
}

- (void)jumpMethod{
//    [self performSegueWithIdentifier:@"loginsuccesstowelcomeback" sender:self];
    
    if (self.user.usertype == 0) {
        UIStoryboard *pfhome = [UIStoryboard storyboardWithName:@"pfhome" bundle:nil];
        PFHomeViewController *viewController = [pfhome instantiateViewControllerWithIdentifier:@"pfhome"];
        EMINavigationController *nav = [[EMINavigationController alloc] initWithRootViewController:viewController];
        nav.transitioningDelegate = self;
        [self presentViewController:nav animated:YES completion:nil];
    }
    if (self.user.usertype == 1) {
        UIStoryboard *manager = [UIStoryboard storyboardWithName:@"manager" bundle:nil];
        ManagerIndexViewController *managerIndexVC = [manager instantiateViewControllerWithIdentifier:@"manager"];
        EMINavigationController *managerNav = [[EMINavigationController alloc] initWithRootViewController:managerIndexVC];
        managerNav.transitioningDelegate = self;
        [self presentViewController:managerNav animated:YES completion:nil];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return NO;
}

// present动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    OuPresentAnimation *animation = [[OuPresentAnimation alloc] init];
    animation.imageRect = self.headImgView.frame;
    
    
    // 1.加载原图
    UIImage *oldImage = self.headImgView.image;
    
    CGFloat imageWidth = self.headImgView.frame.size.width + 2 * 1;
    
    CGFloat imageHeight = self.headImgView.frame.size.width + 2 * 1;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHeight), NO, 0.0);
    
    UIGraphicsGetCurrentContext();
    
    CGFloat radius = self.headImgView.frame.size.width/2;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(imageWidth * 0.5, imageHeight * 0.5) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    bezierPath.lineWidth = 1;
    
    [bezierPath stroke];
    
    [bezierPath addClip];
    
    [oldImage drawInRect:CGRectMake(1, 1, self.headImgView.frame.size.width, self.headImgView.frame.size.width)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    
    
    animation.image = newImage;
    animation.desRect = CGRectMake(11*autoSizeScaleX,64+22*autoSizeScaleY,118*autoSizeScaleY,118*autoSizeScaleY);
    return animation;
    
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
