//
//  LoginViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/10.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//初始化视图
- (void)initView{
    
    //加载头像
    [self.headImgView setShadowWithType:EMIShadowPathRound shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.5 shadowRadius:5 image:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580" placeholder:@"miller"];
    
    //outTFView阴影
    [self.outTFView setShadowWithshadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.3 shadowRadius:10];
    
    //登录按钮圆角
//    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 20;
    [self.loginBtn setShadowWithshadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.3 shadowRadius:5];
    
    
    //忘记密码居中
    self.forgetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //忘记密码左右的渐变线
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];  // 设置渐变效果
    gradientLayer1.bounds = self.leftLineView.bounds;
    gradientLayer1.borderWidth = 0;
    
    gradientLayer1.frame = self.leftLineView.bounds;
    gradientLayer1.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor colorWithHexString:@"#465485"] CGColor],
                             (id)[[UIColor colorWithHexString:@"#4E5D8A"] CGColor],(id)[[UIColor colorWithHexString:@"#54628F"] CGColor], nil];
    gradientLayer1.startPoint = CGPointMake(0, 0);
    gradientLayer1.endPoint = CGPointMake(1, 0);
    
    [self.leftLineView.layer addSublayer:gradientLayer1];
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];  // 设置渐变效果
    gradientLayer2.bounds = self.rightLineView.bounds;
    gradientLayer2.borderWidth = 0;
    
    gradientLayer2.frame = self.rightLineView.bounds;
    gradientLayer2.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor colorWithHexString:@"#3C4F87"] CGColor],
                             (id)[[UIColor colorWithHexString:@"#42568A"] CGColor],(id)[[UIColor colorWithHexString:@"#516195"] CGColor], nil];
//    [NSArray arrayWithObjects:
//     (id)[[UIColor colorWithHexString:@"#465485"] CGColor],
//     (id)[[UIColor colorWithHexString:@"#4E5D8A"] CGColor],(id)[[UIColor colorWithHexString:@"#54628F"] CGColor], nil]
    gradientLayer2.startPoint = CGPointMake(1, 0);
    gradientLayer2.endPoint = CGPointMake(0, 0);
    [self.rightLineView.layer addSublayer:gradientLayer2];
    
}


//隐藏键盘
- (IBAction)hideKeyBoard:(UITapGestureRecognizer *)sender {
    if ([self.phoneTF isFirstResponder]) {
        [self.phoneTF resignFirstResponder];
    }
    if ([self.pwdTF isFirstResponder]) {
        [self.pwdTF resignFirstResponder];
    }
    
}
//监测手机号，当合法时，请求头像，登录按钮可点击
- (IBAction)checkTelphoneNum:(UITextField *)sender {
    if ([ValidateMobile ValidateMobile:self.phoneTF.text]) {
        
    }
}
//登录首页
- (IBAction)toHome:(UIButton *)sender {
}
//忘记密码
- (IBAction)forgetPwd:(UIButton *)sender {
}
//立即注册
- (IBAction)toRegister:(UITapGestureRecognizer *)sender {
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
