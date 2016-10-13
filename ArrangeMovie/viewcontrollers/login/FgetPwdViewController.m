//
//  FgetPwdViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/11.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "FgetPwdViewController.h"

@interface FgetPwdViewController ()

@end

@implementation FgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self initView];
    
    //    if (iPhonePlus) {
    //
    //    }else{
    //键盘弹出收起的通知事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //    }
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
    frame.origin.y = -140;
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
    [self.headImgView setShadowWithType:EMIShadowPathCircle shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.5 shadowRadius:5 image:@"miller" placeholder:@"miller"];
    //提交按钮阴影
    [self.tjBtn setShadowWithshadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.3 shadowRadius:5];
    
    
    //获取验证码按钮
    self.yzmBtn = [[YZMButton alloc] initWithTime:60];
    
    [self.yzmView addSubview:self.yzmBtn];
    self.yzmBtn.sd_layout.centerYEqualToView(self.yzmView).rightSpaceToView(self.yzmView,0).heightRatioToView(self.yzmView,0.41).widthRatioToView(self.yzmView,0.27);
    self.yzmBtn.layer.cornerRadius = (screenWidth-34)*0.27/8;
//    __unsafe_unretained typeof(self) weakSelf = self;
    self.yzmBtn.clickBlock = ^(){
        
        
        //网络请求
        
        
    };
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
