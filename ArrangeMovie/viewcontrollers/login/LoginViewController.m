//
//  LoginViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/10.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "LoginViewController.h"
#import "PFHomeViewController.h"
#import "EMINavigationController.h"
#import "ManagerIndexViewController.h"
#import "WelcomeBackViewController.h"

@interface LoginViewController ()
@property (strong,nonatomic)NSString *tempuserType;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initView];
    
    
    
    
    
    [AppDelegate storyBoradAutoLay:self.view];
    //字体
    [AppDelegate storyBoardAutoLabelFont:self.view];
    
    
    self.headImgView.frame = CGRectMake(self.headImgView.frame.origin.x, self.headImgView.frame.origin.y, self.headImgView.frame.size.height, self.headImgView.frame.size.height);
    self.headImgView.layer.cornerRadius = self.headImgView.frame.size.height/2;
    
    //用一层view替换掉顶部状态栏的颜色
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 20)];
    statusView.backgroundColor = [UIColor colorWithHexString:@"#162271"];
    [self.view addSubview:statusView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    //键盘弹出收起的通知事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)keyboardWillShow:(NSNotification *)notification {
//    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat height = keyboardFrame.origin.y;
//    CGRect frame = self.view.frame;
//    frame.origin.y = -239*autoSizeScaleY;
//    self.view.frame = frame;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    //恢复到默认y为0的状态，有时候要考虑导航栏要+64
//    CGRect frame = self.view.frame;
//    frame.origin.y = 0;
//    self.view.frame = frame;
}

//初始化视图
- (void)initView{
    
    [self setHead];
       
}


- (void)setHead{
    //加载头像
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:@"http://static.cnbetacdn.com/topics/6b6702c2167e5a2.jpg"]];// placeholderImage:[UIImage imageNamed:@"default_head"]
}

//选中部分字色的变化

//开始输入手机号
- (IBAction)touchPhoneTF:(UITextField *)sender {
    self.phoneLab.textColor = [UIColor colorWithHexString:@"162271"];
    self.phoneTF.textColor = [UIColor colorWithHexString:@"162271"];
    self.phoneLineView.backgroundColor = [UIColor colorWithHexString:@"162271"];
    //阴影
    [self.phoneLineView setShadowWithshadowColor:[UIColor colorWithHexString:@"162271"] shadowOffset:CGSizeZero shadowOpacity:0.9 shadowRadius:4];
    
    self.pwdLab.textColor = [UIColor colorWithHexString:@"a0a0a0"];
    self.pwdTF.textColor = [UIColor colorWithHexString:@"a0a0a0"];
    self.pwdLineView.backgroundColor = [UIColor colorWithHexString:@"a0a0a0"];
    //阴影
    [self.pwdLineView setShadowWithshadowColor:[UIColor clearColor] shadowOffset:CGSizeZero shadowOpacity:0 shadowRadius:0];
}
//开始输入密码
- (IBAction)touchPwdTF:(UITextField *)sender {
    self.pwdLab.textColor = [UIColor colorWithHexString:@"162271"];
    self.pwdTF.textColor = [UIColor colorWithHexString:@"162271"];
    self.pwdLineView.backgroundColor = [UIColor colorWithHexString:@"162271"];
    //阴影
    [self.pwdLineView setShadowWithshadowColor:[UIColor colorWithHexString:@"162271"] shadowOffset:CGSizeZero shadowOpacity:0.9 shadowRadius:4];
    
    self.phoneLab.textColor = [UIColor colorWithHexString:@"a0a0a0"];
    self.phoneTF.textColor = [UIColor colorWithHexString:@"a0a0a0"];
    self.phoneLineView.backgroundColor = [UIColor colorWithHexString:@"a0a0a0"];
    //阴影
    [self.phoneLineView setShadowWithshadowColor:[UIColor clearColor] shadowOffset:CGSizeZero shadowOpacity:0 shadowRadius:0];
}
//检查手机号
- (IBAction)checkTelPhone:(UITextField *)sender {
    if ([ValidateMobile ValidateMobile:self.phoneTF.text]) {
        self.loginBtn.enabled = YES;
    }else{
        self.loginBtn.enabled = NO;
    }
}


//隐藏键盘
- (IBAction)hideKeyBoard:(UITapGestureRecognizer *)sender {
    if ([self.phoneTF isFirstResponder]) {
        [self.phoneTF resignFirstResponder];
    }
    if ([self.pwdTF isFirstResponder]) {
        [self.pwdTF resignFirstResponder];
    }
    
    
    
    self.phoneLab.textColor = [UIColor colorWithHexString:@"a0a0a0"];
    self.phoneTF.textColor = [UIColor colorWithHexString:@"a0a0a0"];
    self.phoneLineView.backgroundColor = [UIColor colorWithHexString:@"a0a0a0"];
    //阴影
    [self.phoneLineView setShadowWithshadowColor:[UIColor clearColor] shadowOffset:CGSizeZero shadowOpacity:0 shadowRadius:0];
    
    self.pwdLab.textColor = [UIColor colorWithHexString:@"a0a0a0"];
    self.pwdTF.textColor = [UIColor colorWithHexString:@"a0a0a0"];
    self.pwdLineView.backgroundColor = [UIColor colorWithHexString:@"a0a0a0"];
    //阴影
    [self.pwdLineView setShadowWithshadowColor:[UIColor clearColor] shadowOffset:CGSizeZero shadowOpacity:0 shadowRadius:0];
}

//登录首页
- (IBAction)toHome:(UIButton *)sender {
    if ([self.phoneTF.text isEqualToString:@"0"]) {
        //片方首页
        self.tempuserType = @"0";
        //进入登录欢迎页
        [self performSegueWithIdentifier:@"tologinwelcome" sender:self];
    }
    if ([self.phoneTF.text isEqualToString:@"1"]) {
        //院线经理首页
        self.tempuserType = @"1";
        //进入登录欢迎页
        [self performSegueWithIdentifier:@"tologinwelcome" sender:self];
    }
    
    
    
}
//忘记密码
- (IBAction)forgetPwd:(UIButton *)sender {
    [self performSegueWithIdentifier:@"toFgetPwdVC" sender:self];
}
//立即注册
- (IBAction)toRegister:(UIButton *)sender {

    [self performSegueWithIdentifier:@"toRegVC" sender:self];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"tologinwelcome"]) {
        WelcomeBackViewController *welVC = segue.destinationViewController;
        welVC.tempuserType = self.tempuserType;
    }
}


@end
