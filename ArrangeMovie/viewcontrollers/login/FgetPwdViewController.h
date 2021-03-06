//
//  FgetPwdViewController.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/11.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "UIView+Shadow.h"
#import "ValidateMobile.h"
#import "YZMButton.h"
#import "UIView+SDAutoLayout.h"
#import "UIImageView+WebCache.h"


@interface FgetPwdViewController : EMIBaseViewController
@property (weak, nonatomic) IBOutlet EMIShadowImageView *headImgView;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImg;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIView *phoneLineView;
@property (weak, nonatomic) IBOutlet UIImageView *yzmImg;
@property (weak, nonatomic) IBOutlet UITextField *yzmTF;
@property (weak, nonatomic) IBOutlet UIView *yzmLineView;
@property (weak, nonatomic) IBOutlet UIImageView *npwdImg;
@property (weak, nonatomic) IBOutlet UITextField *npwdTF;
@property (weak, nonatomic) IBOutlet UIView *npwdLineView;
@property (weak, nonatomic) IBOutlet UIImageView *anpwdImg;
@property (weak, nonatomic) IBOutlet UITextField *anpwdTF;
@property (weak, nonatomic) IBOutlet UIView *anpwdLineView;
@property (weak, nonatomic) IBOutlet UIButton *tjBtn;
@property (weak, nonatomic) IBOutlet UIView *yzmView;
//获取验证码按钮
@property (strong,nonatomic) YZMButton *yzmBtn;
@end
