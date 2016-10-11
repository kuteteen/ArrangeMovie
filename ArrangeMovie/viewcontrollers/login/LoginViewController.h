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
#import "EMIShadowImageView.h"
#import "UIView+Shadow.h"
#import "UIColor+Hex.h"


@interface LoginViewController : EMIBaseViewController
@property (weak, nonatomic) IBOutlet EMIShadowImageView *headImgView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
//输入框外层view
@property (weak, nonatomic) IBOutlet UIView *outTFView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *leftLineView;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

@end
