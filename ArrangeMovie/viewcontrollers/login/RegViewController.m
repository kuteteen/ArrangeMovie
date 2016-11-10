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
#import "RESideMenu.h"

@interface RegViewController ()<LFLUISegmentedControlDelegate,LCActionSheetDelegate,RESideMenuDelegate>

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
    
    
    [AppDelegate storyBoradAutoLay:self.view];
    
    self.yzmBtn.layer.cornerRadius = self.yzmBtn.frame.size.height/2;
    self.headImg.frame = CGRectMake(self.headImg.frame.origin.x, self.headImg.frame.origin.y, self.headImg.frame.size.height, self.headImg.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    dispatch_async(dispatch_get_main_queue(), ^{
    
//    });
}

- (void)viewWillDisappear:(BOOL)animated{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    //    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    CGFloat height = keyboardFrame.origin.y;
    CGRect frame = self.view.frame;
    frame.origin.y = -self.segmentView.frame.origin.y+64;
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
    
    //头像
    self.headImg.userInteractionEnabled = YES;
    [self.headImg setImage:[UIImage imageNamed:@"register_head"]];
    
    //滑动菜单
    self.mainSegView = [[LFLUISegmentedControl alloc] initWithFrame:CGRectMake(0,0,  self.segmentView.frame.size.width, self.segmentView.frame.size.height)];
    self.mainSegView.isClickable = YES;
    self.mainSegView.delegate = self;
    [self.mainSegView AddSegumentArray:[NSArray arrayWithObjects:@"片方",@"院线经理", nil]];
    [self.segmentView addSubview:self.mainSegView];
    
    //提交按钮阴影
    [self.regBtn setShadowWithshadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.26 shadowRadius:5];
    
    
    //获取验证码按钮
    self.yzmBtn = [[YZMButton alloc] initWithTime:60];
    self.yzmBtn.frame = CGRectMake(230, 18, 101, 28);
    [self.yzmView addSubview:self.yzmBtn];
    self.yzmBtn.layer.cornerRadius = self.yzmBtn.frame.size.height/2;
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

    LCActionSheet *actionAlert = [LCActionSheet sheetWithTitle:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
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
                weakSelf.headImg.image = nil;
                [weakSelf.headImg setCircleBorder:currentimage];
            }
            
        }];
    }
    if (buttonIndex == 2) {
        //从相册选
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
        //隐藏内部拍照按钮
        imagePicker.allowTakePicture = NO;
        [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL flag) {
            weakSelf.headImg.image = nil;
            [weakSelf.headImg setCircleBorder:photos[0]];
        }];
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
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
//        self.regBtn.enabled = NO;
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
    //片方跳至首页
    if (self.mainSegView.selectSeugment == 0) {
        UIStoryboard *pfhome = [UIStoryboard storyboardWithName:@"pfhome" bundle:nil];
        PFHomeViewController *viewController = [pfhome instantiateViewControllerWithIdentifier:@"pfhome"];
        EMINavigationController *nav = [[EMINavigationController alloc] initWithRootViewController:viewController];
        UIStoryboard *me = [UIStoryboard storyboardWithName:@"me" bundle:nil];
        MeViewController *meVC = [me instantiateViewControllerWithIdentifier:@"me"];
        EMINavigationController *meNav = [[EMINavigationController alloc] initWithRootViewController:meVC];
        
        
        EMIRootViewController *sideMenuViewController = [[EMIRootViewController alloc] initWithContentViewController:nav leftMenuViewController:nil rightMenuViewController:meNav];
            sideMenuViewController.backgroundImage = [UIImage imageNamed:@"all_bg"];
            sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
            sideMenuViewController.delegate = self;
            sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
            sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
            sideMenuViewController.contentViewShadowOpacity = 0.6;
            sideMenuViewController.contentViewShadowRadius = 12;
            sideMenuViewController.contentViewShadowEnabled = YES;
        
        
            sideMenuViewController.scaleContentView = NO;
            sideMenuViewController.scaleMenuView = NO;
            sideMenuViewController.panGestureEnabled = YES;
            sideMenuViewController.contentViewInPortraitOffsetCenterX = screenWidth;
        
        [self presentViewController:sideMenuViewController animated:YES completion:nil];
    }
    //院线经理跳至认证院线经理
    if (self.mainSegView.selectSeugment == 1) {
        [self performSegueWithIdentifier:@"toLoginAuthVC" sender:self];
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
