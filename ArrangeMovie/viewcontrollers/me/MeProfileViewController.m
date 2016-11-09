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

@interface MeProfileViewController()<LCActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIView *headBackView;
@property (weak, nonatomic) IBOutlet EMIShadowImageView *headImgView;
@property (weak, nonatomic) IBOutlet EMIShadowImageView *editHeadImageView;
@property (weak, nonatomic) IBOutlet UITextField *NickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet BEMCheckBox *maleCheck;
@property (weak, nonatomic) IBOutlet BEMCheckBox *femaleCheck;
@property (weak, nonatomic) IBOutlet UIView *maleView;
@property (weak, nonatomic) IBOutlet UIView *femaleView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveProfileBtn;


@property(nonatomic,strong) EMICamera *camera;

@end

@implementation MeProfileViewController

-(void)viewDidLoad {
    self.title = @"我的资料";
    self.headBackView.layer.contents = (__bridge id _Nullable)(([UIImage imageNamed:@"head_bg"].CGImage));
    
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu"
                                                        object:self
                                                      userInfo:nil];
}

-(void)showUser {
    [self.headImgView setShadowWithType:EMIShadowPathCircle shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.35 shadowRadius:10 image:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580" placeholder:@"miller"];
    
    [self.NickNameTextField setText:self.user.nickname];
    [self.nameTextField setText:self.user.name];
    if(self.user.sex==1){
        [self setMale];
    }else{
        [self setFemale];
    }
    self.phoneLabel.text = self.user.dn;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)setMale {
    [_maleCheck setOn:YES];
    [_femaleCheck setOn:NO];
    self.user.sex = 1;
}

-(void)setFemale {
    [_maleCheck setOn:NO];
    [_femaleCheck setOn:YES];
    self.user.sex = 0;
}

-(void)takePicture {
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
            NSLog(@"%@",info);
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    if (buttonIndex == 2) {
        //从相册选
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
        //隐藏内部拍照按钮
        imagePicker.allowTakePicture = NO;
        [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL flag) {
            NSLog(@"%@",photos[0]);
        }];
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)saveUser {
    UpdateProfileWebInterface *webInterface = [[UpdateProfileWebInterface alloc] init];
    NSDictionary *param = [webInterface inboxObject:self.user];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:webInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        if (returnValue) {
            NSArray *result = [webInterface unboxObject:returnValue];
            
        }
    } WithErrorCodeBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
}

@end
