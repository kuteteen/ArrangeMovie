//
//  MeProfileViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/11.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeProfileViewController.h"
#import "BEMCheckBox.h"
#import "LCActionSheet.h"
#import "TZImagePickerController.h"
#import "EMICamera.h"
#import "UpdateProfileWebInterface.h"
#import "SCHttpOperation.h"
#import "UIImageView+Webcache.h"
#import "UploadFile.h"
#import "OperateNSUserDefault.h"

@interface MeProfileViewController()<LCActionSheetDelegate,UITextFieldDelegate,UploadFileDelegate>

@property (weak, nonatomic) IBOutlet UIView *headBackView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet EMIShadowImageView *editHeadImageView;
@property (weak, nonatomic) IBOutlet UITextField *NickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet BEMCheckBox *maleCheck;
@property (weak, nonatomic) IBOutlet BEMCheckBox *femaleCheck;
@property (weak, nonatomic) IBOutlet UIView *maleView;
@property (weak, nonatomic) IBOutlet UIView *femaleView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveProfileBtn;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@property(nonatomic,strong) EMICamera *camera;

@property (nonatomic,strong)UIImage *lastHead;//最后要上传的image，为空就不传

@property (nonatomic,strong)UploadFile *uploadUtil;//上传图片的类
@end

@implementation MeProfileViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资料";
    self.scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    
    //上传图片的工具类
    if (self.uploadUtil == nil) {
        self.uploadUtil = [[UploadFile alloc] initWithViewController:self];
        self.uploadUtil.delegate = self;
    }
    
    self.NickNameTextField.delegate = self;
    self.nameTextField.delegate = self;
    
    [self.editHeadImageView setShadowWithType:EMIShadowPathRound shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.26 shadowRadius:10 image:@"" placeholder:@"profile_revision"];
    
    
    UITapGestureRecognizer *maleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setMale)];
    [_maleView addGestureRecognizer:maleTap];
    UITapGestureRecognizer *femaleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setFemale)];
    [_femaleView addGestureRecognizer:femaleTap];
    
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePicture)];
    self.headImgView.userInteractionEnabled = YES;
    [self.headImgView addGestureRecognizer:headTap];
    
    
    [self showUser];
    
    
    
    [self.saveProfileBtn addTarget:self action:@selector(saveUser) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer *headBGTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
    [self.headBackView addGestureRecognizer:headBGTap];
    UITapGestureRecognizer *bottomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
    [self.bottomView addGestureRecognizer:bottomTap];
}

-(void)hiddenKeyBoard {
    [self.NickNameTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)showUser {
    
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = self.headImgView.frame.size.width/2;
    if (self.headimg == nil) {
        [self.headImgView setImage:defaultheadimage];// todo
    }else{
        //有默认用户头像
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.headimg] placeholderImage:defaultheadimage];
    }
    
    [self.NickNameTextField setText:self.user.nickname == nil ? @"":self.user.nickname];
    [self.nameTextField setText:self.user.name == nil ? @"":self.user.name];
    if(self.user.sex == nil || [self.user.sex isEqualToString:@"男"]){
        [self setMale];
    }else{
        [self setFemale];
    }
    self.phoneLabel.text = self.user.dn == nil ?@"":self.user.dn;
}


-(void)setMale {
    [_maleCheck setOn:YES];
    [_femaleCheck setOn:NO];
    self.user.sex = @"男";
}

-(void)setFemale {
    [_maleCheck setOn:NO];
    [_femaleCheck setOn:YES];
    self.user.sex = @"女";
}

-(void)takePicture {
    [self hiddenKeyBoard];
    
    LCActionSheet *actionAlert = [LCActionSheet sheetWithTitle:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [actionAlert show];
}

//弹出框点击事件代理
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //拍照
        self.camera = [[EMICamera alloc] init];
        [self.camera takePhoto:self];
        //获的照片的回调
        __unsafe_unretained typeof(self) weakSelf = self;
        [self.camera setBlock:^(UIImagePickerController *picker, NSDictionary<NSString *,id> *info) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            //获取图片
            UIImage *currentimage = [info objectForKey:UIImagePickerControllerOriginalImage];
            //相机需要把图片存进相蒲
            
            if (currentimage != nil) {
                //存进相蒲
                //                UIImageWriteToSavedPhotosAlbum(currentimage, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                weakSelf.headImgView.image = currentimage;
                weakSelf.lastHead = currentimage;
            }
        }];
    }
    if (buttonIndex == 2) {
        //从相册选
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
        //隐藏内部拍照按钮
        imagePicker.allowTakePicture = NO;
        __unsafe_unretained typeof(self) weakSelf = self;
        [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL flag) {
            weakSelf.headImgView.image = photos[0];
            weakSelf.lastHead = photos[0];
        }];
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}





//上传图片
- (void)uploadHead:(UIImage *)image{
    
    //原本设置过头像，可以不再设置
    if (image == nil && self.headimg != nil) {
        //直接请求注册接口
        __unsafe_unretained typeof(self) weakself = self;
        UpdateProfileWebInterface *webInterface = [[UpdateProfileWebInterface alloc] init];
        NSDictionary *param = [webInterface inboxObject:@[@(self.user.userid),self.NickNameTextField.text,self.nameTextField.text,self.user.sex,self.headimg,@(self.user.usertype)]];
        [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:webInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
            if (returnValue) {
                NSArray *result = [webInterface unboxObject:returnValue];
                if ([result[0] intValue] == 1) {
                    [weakself.view makeToast:@"修改成功" duration:2.0 position:CSToastPositionCenter];
                    //修改self.user的内容
                    weakself.user.nickname = weakself.NickNameTextField.text;
                    weakself.user.name = weakself.nameTextField.text;
                    weakself.user.sex = weakself.user.sex;
                    [OperateNSUserDefault saveUser:weakself.user];
                    [weakself.navigationController popViewControllerAnimated:YES];
                }else{
                    [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
                }
                
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

//图片上传成功的代理
- (void)returnImagePath:(NSArray *)resultimg{
    
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:resultimg[1]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        
        //头像加载成功，再去请求修改个人资料接口
        __unsafe_unretained typeof(self) weakself = self;
        UpdateProfileWebInterface *webInterface = [[UpdateProfileWebInterface alloc] init];
        NSDictionary *param = [webInterface inboxObject:@[@(self.user.userid),self.NickNameTextField.text,self.nameTextField.text,self.user.sex,resultimg[0],@(self.user.usertype)]];
        [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:webInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
            if (returnValue) {
                NSArray *result = [webInterface unboxObject:returnValue];
                if ([result[0] intValue] == 1) {
                    [weakself.view makeToast:@"修改成功" duration:2.0 position:CSToastPositionCenter];
                    //修改self.user的内容
                    weakself.user.headimg = resultimg[1];
                    weakself.user.nickname = weakself.NickNameTextField.text;
                    weakself.user.name = weakself.nameTextField.text;
                    weakself.user.sex = weakself.user.sex;
                    [OperateNSUserDefault saveUser:weakself.user];
                    
                    
                    //修改头像
                    [OperateNSUserDefault addUserDefaultWithKeyAndValue:@"headimg" value:resultimg[1]];
                    [weakself.navigationController popViewControllerAnimated:YES];
                }else{
                    [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
                }
                
            }
        } WithErrorCodeBlock:^(id errorCode) {
            [weakself.view makeToast:@"请求出错" duration:2.0 position:CSToastPositionCenter];
        } WithFailureBlock:^{
            [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
        }];
    }];
}


-(void)saveUser {
    
    if (self.headimg == nil && self.lastHead == nil) {
        [self.view makeToast:@"请上传一张头像" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.NickNameTextField.text isEqualToString:@""] || self.NickNameTextField.text == nil) {
        [self.view makeToast:@"请输入昵称" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    if ([self.nameTextField.text isEqualToString:@""] || self.nameTextField.text == nil) {
        [self.view makeToast:@"请输入姓名" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    
    [self uploadHead:self.lastHead];
    
    
}


# pragma mark - UITextField delegate 
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.NickNameTextField]) {
        [self.NickNameTextField resignFirstResponder];
        [self.nameTextField becomeFirstResponder];
    }else {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
