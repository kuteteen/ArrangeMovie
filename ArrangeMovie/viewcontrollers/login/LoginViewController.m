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
#import "Encryption.h"
#import "LoginWebInterface.h"
#import "SCHttpOperation.h"
#import "MBProgressHUD.h"
#import "UIImage+GIF.h"

@interface LoginViewController ()
@property(strong,nonatomic)MBProgressHUD *HUD;
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

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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

    if (self.headimg == nil) {
        [self.headImgView setImage:defaultheadimage];// todo
    }else{
        //有默认用户头像
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.headimg] placeholderImage:defaultheadimage];
    }
    
    if (self.dn != nil) {
        //有默认用户手机号
        self.phoneTF.text = self.dn;
        self.loginBtn.enabled = YES;
    }
    
    
}

//选中部分字色的变化

//开始输入手机号
- (IBAction)touchPhoneTF:(UITextField *)sender {
    self.phoneLab.textColor = [UIColor colorWithHexString:@"162271"];
    self.phoneTF.textColor = [UIColor colorWithHexString:@"162271"];
    self.phoneLineView.backgroundColor = [UIColor colorWithHexString:@"162271"];
    //阴影
    [self.phoneLineView setShadowWithshadowColor:[UIColor colorWithHexString:@"162271"] shadowOffset:CGSizeZero shadowOpacity:0.9 shadowRadius:2];
    
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
    [self.pwdLineView setShadowWithshadowColor:[UIColor colorWithHexString:@"162271"] shadowOffset:CGSizeZero shadowOpacity:0.9 shadowRadius:2];
    
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
    
    
    //进行网络请求，请求成功,有头像就加载头像，加载完成跳至登陆成功页面
    LoginWebInterface *loginInterface = [[LoginWebInterface alloc] init];
    NSDictionary *paramDic = [loginInterface inboxObject: @[self.phoneTF.text,[Encryption md5EncryptWithString:self.pwdTF.text]]];
    __unsafe_unretained typeof(self) weakself = self;
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:loginInterface.url withparameter:paramDic WithReturnValeuBlock:^(id returnValue) {
        NSMutableArray *result = [loginInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            [weakself.view makeToast:@"登录成功" duration:2.0 position:CSToastPositionCenter];
            //登录成功后保存user信息到userDefault
            User *loginuser = result[1];
            //给个默认性别
            if (loginuser.sex == nil || [loginuser.sex isEqualToString:@""]) {
                loginuser.sex = @"男";
            }
            
            [OperateNSUserDefault saveUser:loginuser];
            //手机号(先清除旧的，再添新的)
            [OperateNSUserDefault removeUserDefaultWithKey:@"dn"];//清除旧的
            [OperateNSUserDefault addUserDefaultWithKeyAndValue:@"dn" value:loginuser.dn];//添加新的
            
            [OperateNSUserDefault removeUserDefaultWithKey:@"headimg"];//清除旧的
            if (loginuser.headimg != nil) {
                [OperateNSUserDefault addUserDefaultWithKeyAndValue:@"headimg" value:loginuser.headimg];
                //加载完头像进入登录成功页
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage sd_animatedGIFNamed:@"loading_120"]];
                weakself.HUD = [MBProgressHUD showHUDAddedTo:weakself.view animated:YES];
                weakself.HUD.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.2];
                weakself.HUD.bezelView.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:0.8];
                //        HUD.bezelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_bj"]];
                //        HUD.bezelView.tintColor = [UIColor clearColor];
                
                weakself.HUD.bezelView.layer.cornerRadius = 16;
                weakself.HUD.mode = MBProgressHUDModeCustomView;
                //        HUD.mode = MBProgressHUDModeIndeterminate;
                weakself.HUD.customView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
                weakself.HUD.customView = imageView;
                weakself.HUD.margin = 5;
                NSLog(@"HUD的margin:%f",self.HUD.margin);
                //    HUD.delegate = self;
                weakself.HUD.square = YES;
                [weakself.HUD showAnimated:YES];
                [weakself.headImgView sd_setImageWithURL:[NSURL URLWithString:loginuser.headimg] placeholderImage:defaultheadimage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    [weakself.HUD hideAnimated:YES];
                    
                    //进入登录成功页
                    [weakself performSegueWithIdentifier:@"logintologinsuccess" sender:weakself];
                }];
            }else{
                //进入登录成功页
                [weakself performSegueWithIdentifier:@"logintologinsuccess" sender:weakself];
            }
            
            
        }else{
            [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
        }
    } WithErrorCodeBlock:^(id errorCode) {
        [weakself.view makeToast:@"请求出错" duration:2.0 position:CSToastPositionCenter];
    } WithFailureBlock:^{
        [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
    }];
   
    
    
    
    
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
//        WelcomeBackViewController *welVC = segue.destinationViewController;
    }
}


@end
