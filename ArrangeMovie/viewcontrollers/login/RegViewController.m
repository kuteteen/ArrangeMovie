//
//  RegViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/13.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "RegViewController.h"
#import "PFHomeViewController.h"
#import "EMIRootViewController.h"
#import "MakeTaskViewController.h"
#import "UploadFile.h"
#import "MobileCodeWebInterface.h"
#import "SCHttpOperation.h"
#import "RegisterWebInterface.h"
#import "Encryption.h"
#import "LoginWebInterface.h"

@interface RegViewController ()<LFLUISegmentedControlDelegate,LCActionSheetDelegate,RESideMenuDelegate,UploadFileDelegate>
@property (nonatomic,strong)NSMutableArray <UITextField *>*tfArrays;
@property (nonatomic,strong)NSMutableArray <UIImageView *>*imgArrays;
@property (nonatomic,strong)NSMutableArray <UIView *> *lineArrays;
@property (nonatomic,strong)NSMutableArray <NSString *> *imgnameArrays;


//用户类型
@property (nonatomic,assign) int usertype;

@property (nonatomic,strong)UIImage *lastHead;//最后要上传的image，为空就不传

@property (nonatomic,strong)UploadFile *uploadUtil;//上传图片的类
@end

@implementation RegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initView];
    
    
    [AppDelegate storyBoradAutoLay:self.view];
    [AppDelegate storyBoardAutoLabelFont:self.view];
    self.yzmBtn.layer.cornerRadius = self.yzmBtn.frame.size.height/2;
    self.headImg.frame = CGRectMake(self.headImg.frame.origin.x, self.headImg.frame.origin.y, self.headImg.frame.size.height, self.headImg.frame.size.height);
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = self.headImg.frame.size.height/2;
    self.tfArrays = [[NSMutableArray alloc] initWithArray:@[self.nickNameTF,self.phoneTF,self.yzmTF,self.npwdTF,self.anpwdTF]];
    self.imgArrays = [[NSMutableArray alloc] initWithArray:@[self.nickNameImg,self.phoneImg,self.yzmImg,self.npwdImg,self.anpwdImg]];
    self.lineArrays = [[NSMutableArray alloc] initWithArray:@[self.nickNameLineView,self.phoneLineView,self.yzmLineView,self.npwdLineView,self.anpwdLineView]];
    self.imgnameArrays = [[NSMutableArray alloc] initWithArray:@[@"Icon---Username",@"login_input_tel",@"register_verification_code",@"login_imput_-password",@"login_imput_-password"]];
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
    if ([self.npwdTF isFirstResponder]||[self.anpwdTF isFirstResponder]) {
        frame.origin.y = -CGRectGetMaxY(self.headImg.frame)+64;
    }
    
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
    
    //上传图片的工具类
    if (self.uploadUtil == nil) {
        self.uploadUtil = [[UploadFile alloc] initWithViewController:self];
        self.uploadUtil.delegate = self;
    }
    
    //头像
    self.headImg.userInteractionEnabled = YES;
    [self.headImg setImage:[UIImage imageNamed:@"register_head"]];
    
    //滑动菜单
    self.mainSegView = [[LFLUISegmentedControl alloc] initWithFrame:CGRectMake(0,0,  self.segmentView.frame.size.width, self.segmentView.frame.size.height)];
    self.mainSegView.isClickable = YES;
    self.mainSegView.delegate = self;
    self.mainSegView.lineColor = [UIColor colorWithHexString:@"162271"];
    self.mainSegView.LFLBackGroundColor = [UIColor whiteColor];
    self.mainSegView.titleColor = [UIColor colorWithHexString:@"162271"];
    self.mainSegView.titleFont = [UIFont fontWithName:@"DroidSansFallback" size:18.f*autoSizeScaleY];
    self.mainSegView.selectColor = [UIColor colorWithHexString:@"162271"];
    self.mainSegView.selectFont = [UIFont fontWithName:@"DroidSansFallback" size:18.f*autoSizeScaleY];
    [self.mainSegView AddSegumentArray:[NSArray arrayWithObjects:@"片方",@"院线经理", nil]];
    [self.segmentView addSubview:self.mainSegView];
    [self.view bringSubviewToFront:self.segmentView];
    //提交按钮阴影
    [self.regBtn setShadowWithshadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.26 shadowRadius:5];
    
    
    //获取验证码按钮
    self.yzmBtn = [[YZMButton alloc] initWithTime:60];
    self.yzmBtn.frame = CGRectMake(230, 18, 101, 28);
    [self.yzmView addSubview:self.yzmBtn];
    self.yzmBtn.layer.cornerRadius = self.yzmBtn.frame.size.height/2;
     __unsafe_unretained typeof(self) weakself = self;
    self.yzmBtn.clickBlock = ^(){
        
        //获取验证码
        MobileCodeWebInterface *codeInterface = [[MobileCodeWebInterface alloc] init];
        NSDictionary *param = [codeInterface inboxObject:@[weakself.phoneTF.text]];
        [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:codeInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
            NSMutableArray *result = [codeInterface unboxObject:returnValue];
            if ([result[0] intValue] == 1) {
                [weakself.view makeToast:@"验证码发送成功" duration:2.0 position:CSToastPositionCenter];
            }else{
                [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
            }
        } WithErrorCodeBlock:^(id errorCode) {
            [weakself.view makeToast:@"请求出错" duration:2.0 position:CSToastPositionCenter];
        } WithFailureBlock:^{
            [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
        }];
        
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
    if ([self.nickNameTF isFirstResponder]) {
        [self.nickNameTF resignFirstResponder];
    }
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
//拍照选头像
- (IBAction)takePhoto:(UITapGestureRecognizer *)sender {

    LCActionSheet *actionAlert = [LCActionSheet sheetWithTitle:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍一张",@"从手机相册中选择", nil];
    [actionAlert show];
}

//弹出框点击事件代理
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    __unsafe_unretained typeof(self) weakSelf = self;
    
    
    
    if (buttonIndex == 1) {
        //拍照
        self.camera = [[EMICamera alloc] init];
        [self.camera takePhoto:self];
        //获的照片的回调
        
        [self.camera setBlock:^(UIImagePickerController *picker, NSDictionary<NSString *,id> *info) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            //获取图片
            UIImage *currentimage = [info objectForKey:UIImagePickerControllerOriginalImage];
            //相机需要把图片存进相蒲
        
            if (currentimage != nil) {
                //存进相蒲
//                UIImageWriteToSavedPhotosAlbum(currentimage, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                weakSelf.headImg.image = currentimage;
                weakSelf.lastHead = currentimage;
            }
            
        }];
    }
    if (buttonIndex == 2) {
        //从相册选
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
        [imagePicker.navigationBar setBarTintColor:[UIColor colorWithHexString:@"162271"]];
        //隐藏内部拍照按钮
        imagePicker.allowTakePicture = NO;
        [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL flag) {
            weakSelf.headImg.image = photos[0];
            weakSelf.lastHead = photos[0];
        }];
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}


//上传图片
- (void)uploadHead:(UIImage *)image{
    
    if (image == nil) {
        //直接请求注册接口
        __unsafe_unretained typeof(self) weakself = self;
        RegisterWebInterface *regInterface = [[RegisterWebInterface alloc] init];
        NSDictionary *param = [regInterface inboxObject:@[self.phoneTF.text,@(self.usertype),self.yzmTF.text,[Encryption md5EncryptWithString:self.npwdTF.text],self.nickNameTF.text]];
        [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:regInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
            NSMutableArray *result = [regInterface unboxObject:returnValue];
            if ([result[0] intValue] == 1) {
                [weakself.view makeToast:@"注册成功" duration:2.0 position:CSToastPositionCenter];
                
                //使线程睡眠4秒，页面跳转
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    //注册成功后 回到登录页，自己去登
                    
                    if (weakself.usertype == 0) {
                        //片方返回登录页
                        [weakself.navigationController popViewControllerAnimated:YES];
                    }
                    
                    //                //院线经理跳至认证院线经理
                    //                if (weakself.usertype == 1) {
                    //                    [weakself performSegueWithIdentifier:@"toLoginAuthVC" sender:weakself];
                    //                }
                    if (weakself.usertype == 1) {
                        //院线经理返回登录页
                        [weakself.navigationController popViewControllerAnimated:YES];
                    }
                    
                });
                
                
            }else{
                [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
            }
        } WithErrorCodeBlock:^(id errorCode) {
            [weakself.view makeToast:@"请求出错" duration:2.0 position:CSToastPositionCenter];
        } WithFailureBlock:^{
             [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
        }];
    }else{
        NSData *imgdata = UIImagePNGRepresentation(image);
        
        [self.uploadUtil uploadFileWithURL:[NSURL URLWithString:imgUploadServerIP] data:imgdata];
    }
   
    

}

//图片上传成功的回调(图片完整地址)
- (void)returnImagePath:(NSArray *)resultimg{
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:resultimg[1]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        
        //头像加载成功，再去请求注册接口
        __unsafe_unretained typeof(self) weakself = self;
        RegisterWebInterface *regInterface = [[RegisterWebInterface alloc] init];
        NSDictionary *param = [regInterface inboxObject:@[self.phoneTF.text,@(self.usertype),self.yzmTF.text,[Encryption md5EncryptWithString:self.npwdTF.text],resultimg[0],self.nickNameTF.text]];
        [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:regInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
            NSMutableArray *result = [regInterface unboxObject:returnValue];
            if ([result[0] intValue] == 1) {
                [weakself.view makeToast:@"注册成功" duration:2.0 position:CSToastPositionCenter];
                
                //使线程睡眠4秒，页面跳转
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    //注册成功后 回到登录页，自己去登
                    
                    if (weakself.usertype == 0) {
                        //片方返回登录页
                        [weakself.navigationController popViewControllerAnimated:YES];
                    }
                    
                    //                //院线经理跳至认证院线经理
                    //                if (weakself.usertype == 1) {
                    //                    [weakself performSegueWithIdentifier:@"toLoginAuthVC" sender:weakself];
                    //                }
                    if (weakself.usertype == 1) {
                        //院线经理返回登录页
                        [weakself.navigationController popViewControllerAnimated:YES];
                    }
                });
                
                
                    
                    
                    
                    
                
                
            }else{
                [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
            }
        } WithErrorCodeBlock:^(id errorCode) {
            [weakself.view makeToast:@"请求出错" duration:2.0 position:CSToastPositionCenter];
        } WithFailureBlock:^{
            [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
        }];
    }];
}
- (IBAction)touchNicknameTF:(UITextField *)sender {
    [self changeHighLighted:0];
}

- (IBAction)touchPhoneTF:(UITextField *)sender {
    [self changeHighLighted:1];
}
- (IBAction)touchYzmTF:(UITextField *)sender {
    [self changeHighLighted:2];
}
- (IBAction)touchNpwdTF:(UITextField *)sender {
    [self changeHighLighted:3];
}
- (IBAction)touchAnpwdTF:(UITextField *)sender {
    [self changeHighLighted:4];
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
    if ([self.nickNameTF.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入昵称" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    if (![self.anpwdTF.text isEqualToString:self.npwdTF.text]) {
        [self.view makeToast:@"两次输入密码不一致" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    self.usertype = (int)(self.mainSegView.selectSeugment);
    
    [self uploadHead:self.lastHead];

    
    
    
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
