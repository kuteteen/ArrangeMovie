//
//  FgetPwdViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/11.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "FgetPwdViewController.h"

@interface FgetPwdViewController ()
@property (nonatomic,strong)NSMutableArray <UITextField *>*tfArrays;
@property (nonatomic,strong)NSMutableArray <UIImageView *>*imgArrays;
@property (nonatomic,strong)NSMutableArray <UIView *> *lineArrays;
@property (nonatomic,strong)NSMutableArray <NSString *> *imgnameArrays;
@end

@implementation FgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self initView];
    
    
    
    [AppDelegate storyBoradAutoLay:self.view];
    [AppDelegate storyBoardAutoLabelFont:self.view];
    self.yzmBtn.layer.cornerRadius = self.yzmBtn.frame.size.height/2;
    self.headImgView.frame = CGRectMake(self.headImgView.frame.origin.x, self.headImgView.frame.origin.y, self.headImgView.frame.size.height, self.headImgView.frame.size.height);
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = self.headImgView.frame.size.height/2;
    self.tfArrays = [[NSMutableArray alloc] initWithArray:@[self.phoneTF,self.yzmTF,self.npwdTF,self.anpwdTF]];
    self.imgArrays = [[NSMutableArray alloc] initWithArray:@[self.phoneImg,self.yzmImg,self.npwdImg,self.anpwdImg]];
    self.lineArrays = [[NSMutableArray alloc] initWithArray:@[self.phoneLineView,self.yzmLineView,self.npwdLineView,self.anpwdLineView]];
    self.imgnameArrays = [[NSMutableArray alloc] initWithArray:@[@"login_input_tel",@"register_verification_code",@"login_imput_-password",@"login_imput_-password"]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
    CGRect frame = self.view.frame;
    frame.origin.y = -CGRectGetMaxY(self.headImgView.frame)-6+64;
    self.view.frame = frame;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    //恢复到默认y为0的状态，有时候要考虑导航栏要+64
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
}

- (void)initView{
    
    self.title = @"忘记密码";
    //头像
    [self setHead];
    
    
    //获取验证码按钮
    self.yzmBtn = [[YZMButton alloc] initWithTime:60];
    
    self.yzmBtn.frame = CGRectMake(230, 20, 101, 28);
    [self.yzmView addSubview:self.yzmBtn];
    self.yzmBtn.layer.cornerRadius = self.yzmBtn.frame.size.height/2;
//    __unsafe_unretained typeof(self) weakSelf = self;
    self.yzmBtn.clickBlock = ^(){
        
        
        //网络请求
        
        
    };
    
}

- (void)setHead{
    //加载头像
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:@"http://static.cnbetacdn.com/topics/6b6702c2167e5a2.jpg"]];// placeholderImage:[UIImage imageNamed:@"default_head"]
}
//隐藏键盘
- (IBAction)hideKeyBoard:(UITapGestureRecognizer *)sender {
    if ([self.phoneTF isFirstResponder]) {
        [self.phoneTF resignFirstResponder];
    }
    if ([self.yzmTF isFirstResponder]) {
        [self.yzmTF resignFirstResponder];
    }
    if ([self.npwdTF isFirstResponder]) {
        [self.npwdTF resignFirstResponder];
    }
    if ([self.anpwdTF isFirstResponder]) {
        [self.anpwdTF resignFirstResponder];
    }
    
    [self changeHighLighted:-1];
}
- (IBAction)touchPhone:(UITextField *)sender {
    [self changeHighLighted:0];
}
- (IBAction)touchYzm:(UITextField *)sender {
    [self changeHighLighted:1];
}
- (IBAction)touchNpwd:(UITextField *)sender {
    [self changeHighLighted:2];
}
- (IBAction)touchAnpwd:(UITextField *)sender {
    [self changeHighLighted:3];
}

//检查手机号
- (IBAction)checkTelPhone:(UITextField *)sender {
    if ([ValidateMobile ValidateMobile:self.phoneTF.text]) {
        
        if ([self.yzmBtn.titleLabel.text isEqualToString:@"获取验证码"]) {
            self.yzmBtn.enabled = YES;
        }
        
        self.tjBtn.enabled = YES;
    }else{
        self.yzmBtn.enabled = NO;
        self.tjBtn.enabled = NO;
    }
}
//检查两次密码是否一致
- (IBAction)checkPwd:(UITextField *)sender {
    if (![self.anpwdTF.text isEqualToString:self.npwdTF.text]) {
        [self.view makeToast:@"两次输入密码不一致" duration:1.5 position:CSToastPositionCenter];
    }
}

//提交
- (IBAction)submit:(UIButton *)sender {
    //返回登录界面
    [self.navigationController popViewControllerAnimated:YES];
}
//改变点击高亮效果
//传入-1，全不高亮
- (void)changeHighLighted:(int)whichOne{
    for (int i = 0; i < self.tfArrays.count; i++) {
        if (i == whichOne) {
            //高亮
            self.imgArrays[i].image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_clicked",self.imgnameArrays[i]]];
            self.tfArrays[i].textColor = [UIColor colorWithHexString:@"162271"];
            self.lineArrays[i].backgroundColor = [UIColor colorWithHexString:@"162271"];
            //阴影
            [self.lineArrays[i] setShadowWithshadowColor:[UIColor colorWithHexString:@"162271"] shadowOffset:CGSizeZero shadowOpacity:0.9 shadowRadius:2];
            
            
        }else{
            //非高亮
            
            self.imgArrays[i].image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imgnameArrays[i]]];
            self.tfArrays[i].textColor = [UIColor colorWithHexString:@"a0a0a0"];
            self.lineArrays[i].backgroundColor = [UIColor colorWithHexString:@"a0a0a0"];
            //阴影
            [self.lineArrays[i] setShadowWithshadowColor:[UIColor clearColor] shadowOffset:CGSizeZero shadowOpacity:0 shadowRadius:0];
        }
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
