//
//  RegViewController.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/13.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "UIView+Shadow.h"
#import "ValidateMobile.h"
#import "YZMButton.h"
#import "UIView+SDAutoLayout.h"
#import "LFLUISegmentedControl.h"
#import "LCActionSheet.h"
#import "TZImagePickerController.h"
#import "EMICamera.h"
#import "UIView+Shadow.h"
#import "EMINavigationController.h"


@interface RegViewController : EMIBaseViewController

@property (weak, nonatomic) IBOutlet EMIShadowImageView *headImg;

@property (weak, nonatomic) IBOutlet UIView *segmentView;//滑动菜单父视图
@property (weak, nonatomic) IBOutlet UIImageView *nickNameImg;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@property (weak, nonatomic) IBOutlet UIView *nickNameLineView;


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
@property (weak, nonatomic) IBOutlet UIButton *regBtn;
@property (weak, nonatomic) IBOutlet UIView *yzmView;
//获取验证码按钮
@property (strong,nonatomic) YZMButton *yzmBtn;

//滑动菜单
@property (strong,nonatomic) LFLUISegmentedControl *mainSegView;
//拍照
@property (strong,nonatomic) EMICamera *camera;
@end
