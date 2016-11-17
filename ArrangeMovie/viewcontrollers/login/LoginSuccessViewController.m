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

@interface LoginSuccessViewController ()<RESideMenuDelegate>
@property (weak, nonatomic) IBOutlet EMIShadowImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;

@end

@implementation LoginSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.nameLab.font = [UIFont systemFontOfSize:21.0*autoSizeScaleY];
    self.bottomLab.font = [UIFont systemFontOfSize:19.0*autoSizeScaleY];
    
    //动画改变视图透明度和位置
    [UIView animateWithDuration:3.0f animations:^{
        self.headImgView.alpha = 1;
        CGRect headframe = self.headImgView.frame;
        headframe.origin.y = 94*autoSizeScaleY;
        self.headImgView.frame = headframe;
        
        self.nameLab.alpha = 1;
        CGRect nameframe = self.nameLab.frame;
        nameframe.origin.y = 215*autoSizeScaleY;
        self.nameLab.frame = nameframe;
        
        self.bottomView.alpha = 1;
    }];
    
    //停留5秒，跳至首页
    double delayInSeconds = 2.0;
    __block LoginSuccessViewController* bself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if ([bself.tempuserType isEqualToString:@"0"]) {
            UIStoryboard *pfhome = [UIStoryboard storyboardWithName:@"pfhome" bundle:nil];
            PFHomeViewController *viewController = [pfhome instantiateViewControllerWithIdentifier:@"pfhome"];
            EMINavigationController *nav = [[EMINavigationController alloc] initWithRootViewController:viewController];
            UIStoryboard *me = [UIStoryboard storyboardWithName:@"me" bundle:nil];
            MeViewController *meVC = [me instantiateViewControllerWithIdentifier:@"me"];
            EMINavigationController *meNav = [[EMINavigationController alloc] initWithRootViewController:meVC];
            
            
            EMIRootViewController *sideMenuViewController = [[EMIRootViewController alloc] initWithContentViewController:nav leftMenuViewController:nil rightMenuViewController:meNav];
            sideMenuViewController.backgroundImage = [UIImage imageNamed:@"all_bg"];
            sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
            sideMenuViewController.delegate = bself;
            sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
            sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
            sideMenuViewController.contentViewShadowOpacity = 0.6;
            sideMenuViewController.contentViewShadowRadius = 12;
            sideMenuViewController.contentViewShadowEnabled = YES;
            
            
            sideMenuViewController.scaleContentView = NO;
            sideMenuViewController.scaleMenuView = NO;
            sideMenuViewController.panGestureEnabled = YES;
            sideMenuViewController.contentViewInPortraitOffsetCenterX = screenWidth;
            
            [bself presentViewController:sideMenuViewController animated:YES completion:nil];
        }
        if ([bself.tempuserType isEqualToString:@"1"]) {
            UIStoryboard *manager = [UIStoryboard storyboardWithName:@"manager" bundle:nil];
            ManagerIndexViewController *managerIndexVC = [manager instantiateViewControllerWithIdentifier:@"manager"];
            //假数据 用户
            User *user = [[User alloc] init];
            
            user.name = @"冯小刚";
            user.dn = @"1577470000";
            user.usertype = 0;
            user.sex = 1;
            user.headimg = @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580";
            user.gradename = @"A级影院";
            managerIndexVC.user = user;
            EMINavigationController *managerNav = [[EMINavigationController alloc] initWithRootViewController:managerIndexVC];
            
            
            UIStoryboard *me = [UIStoryboard storyboardWithName:@"me" bundle:nil];
            MeViewController *meVC = [me instantiateViewControllerWithIdentifier:@"me"];
            EMINavigationController *meNav = [[EMINavigationController alloc] initWithRootViewController:meVC];
            EMIRootViewController *sideMenuViewController = [[EMIRootViewController alloc] initWithContentViewController:managerNav
                                                                                                  leftMenuViewController:nil
                                                                                                 rightMenuViewController:meNav];
            sideMenuViewController.backgroundImage = [UIImage imageNamed:@"all_bg"];
            sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
            sideMenuViewController.delegate = bself;
            sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
            sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
            sideMenuViewController.contentViewShadowOpacity = 0.6;
            sideMenuViewController.contentViewShadowRadius = 12;
            sideMenuViewController.contentViewShadowEnabled = YES;
            
            
            sideMenuViewController.scaleContentView = NO;
            sideMenuViewController.scaleMenuView = NO;
            sideMenuViewController.panGestureEnabled = YES;
            sideMenuViewController.contentViewInPortraitOffsetCenterX = screenWidth;
            [bself presentViewController:sideMenuViewController animated:YES completion:nil];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setHead{
    //加载头像
    //加载头像
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:@"http://static.cnbetacdn.com/topics/6b6702c2167e5a2.jpg"]];// placeholderImage:[UIImage imageNamed:@"default_head"]
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
