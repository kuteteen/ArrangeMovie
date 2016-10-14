//
//  RegViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/13.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "RegViewController.h"

@interface RegViewController ()<LFLUISegmentedControlDelegate>

@end

@implementation RegViewController

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
    self.title = @"注册";
    
    //滑动菜单
    self.mainSegView = [[LFLUISegmentedControl alloc] initWithFrame:CGRectMake(0,0,  screenWidth, self.segmentView.frame.size.height)];
    self.mainSegView.delegate = self;
    [self.mainSegView AddSegumentArray:[NSArray arrayWithObjects:@"片方",@"院线经理", nil]];
    [self.segmentView addSubview:self.mainSegView];
    
    //提交按钮阴影
    [self.regBtn setShadowWithshadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.3 shadowRadius:5];
    
    
    //获取验证码按钮
    self.yzmBtn = [[YZMButton alloc] initWithTime:60];
    
    [self.yzmView addSubview:self.yzmBtn];
    self.yzmBtn.sd_layout.centerYEqualToView(self.yzmView).rightSpaceToView(self.yzmView,0).heightRatioToView(self.yzmView,0.41).widthRatioToView(self.yzmView,0.27);
    self.yzmBtn.layer.cornerRadius = (screenWidth-34)*0.27/9;
    //    __unsafe_unretained typeof(self) weakSelf = self;
    self.yzmBtn.clickBlock = ^(){
        
        
        //网络请求
        
        
    };
}

//左滑右滑手势方法
- (IBAction)selectSegment:(UISwipeGestureRecognizer *)sender {
    //向左滑
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.mainSegView.selectSeugment == 0) {
            [self.mainSegView selectTheSegument:1];
        }
    }
    //向右滑
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.mainSegView.selectSeugment == 1) {
            [self.mainSegView selectTheSegument:0];
        }
    }
}



//segment点击代理
-(void)uisegumentSelectionChange:(NSInteger)selection{
//    NSLog(@"%ld",selection);
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
//拍照选头像
- (IBAction)takePhoto:(UITapGestureRecognizer *)sender {
}
//检测手机号是否合法
- (IBAction)checkTelphone:(UITextField *)sender {
    if ([ValidateMobile ValidateMobile:self.phoneTF.text]) {
        
        if ([self.yzmBtn.titleLabel.text isEqualToString:@"获取验证码"]) {
            self.yzmBtn.enabled = YES;
        }
        
        self.regBtn.enabled = YES;
    }else{
        self.yzmBtn.enabled = NO;
        self.regBtn.enabled = NO;
    }
}
//检测密码是否一致
- (IBAction)checkPwd:(UITextField *)sender {
    if (![self.anpwdTF.text isEqualToString:self.npwdTF.text]) {
        [self.view makeToast:@"两次输入密码不一致" duration:1.5 position:CSToastPositionCenter];
    }
}
//立即注册
- (IBAction)registerClicked:(UIButton *)sender {
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
