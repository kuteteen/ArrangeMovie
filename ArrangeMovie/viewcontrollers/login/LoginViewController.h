//
//  LoginViewController.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/10.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "ValidateMobile.h"
#import "UIImageView+WebCache.h"
#import "UIView+Shadow.h"
#import "UIColor+Hex.h"


@interface LoginViewController : EMIBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;//手机号标签

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;//手机号输入框
@property (weak, nonatomic) IBOutlet UIView *phoneLineView;//手机号分割线
@property (weak, nonatomic) IBOutlet UILabel *pwdLab;//密码标签
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;//密码输入框
@property (weak, nonatomic) IBOutlet UIView *pwdLineView;//密码分割线

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

@end
