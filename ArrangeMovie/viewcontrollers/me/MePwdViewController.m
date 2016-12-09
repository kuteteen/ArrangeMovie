//
//  MePwdViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/13.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MePwdViewController.h"
#import "ChangePswWebInterface.h"
#import "SCHttpOperation.h"
#import "Encryption.h"

@interface MePwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdNewTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdNew2TextField;
@property (weak, nonatomic) IBOutlet UILabel *dnLabel;

@end

@implementation MePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.contents = [UIColor whiteColor];
    
    self.dnLabel.text = self.user.dn;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField isEqual:self.oldPwdTextField]){
        [self.oldPwdTextField resignFirstResponder];
        [self.pwdNewTextField becomeFirstResponder];
    }
    if ([textField isEqual:self.pwdNewTextField]) {
        [self.pwdNewTextField resignFirstResponder];
        [self.pwdNew2TextField becomeFirstResponder];
    }
    if ([textField isEqual:self.pwdNew2TextField]) {
        [self.pwdNew2TextField resignFirstResponder];
        
        [self checkPwd];
    }
    return YES;
}

-(void)checkPwd {
    NSString *oldPwd = self.oldPwdTextField.text;
    if (oldPwd.length>0) {
        
        NSString *pwdNew = self.pwdNewTextField.text;
        NSString *pwdNew2 = self.pwdNew2TextField.text;
        if([pwdNew isEqualToString:pwdNew2]&&pwdNew.length>0){
            //修改密码
            __unsafe_unretained typeof (self) weakself = self;
            ChangePswWebInterface *changepwdInterface = [[ChangePswWebInterface alloc] init];
            NSDictionary *param = [changepwdInterface inboxObject:@[self.dnLabel.text,[Encryption md5EncryptWithString:self.oldPwdTextField.text],[Encryption md5EncryptWithString:self.pwdNewTextField.text]]];
            [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:changepwdInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
                NSArray *result = [changepwdInterface unboxObject:returnValue];
                if ([result[0] intValue] == 1) {
                    [weakself.view makeToast:@"修改成功" duration:2.0 position:CSToastPositionCenter];
                    //返回上一页
                    [weakself.navigationController popViewControllerAnimated:YES];
                }else{
                    [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
                }
            } WithErrorCodeBlock:^(id errorCode) {
                [weakself.view makeToast:@"请求错误" duration:2.0 position:CSToastPositionCenter];
            } WithFailureBlock:^{
                [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
            }];
        }else{
            [self.view makeToast:@"请输入新密码!或两次新密码不一致" duration:3.0 position:CSToastPositionCenter];
        }
        
    }else {
        [self.view makeToast:@"请输入原密码!" duration:3.0 position:CSToastPositionCenter];
    }
}

- (IBAction)savePwd:(id)sender {
    [self.oldPwdTextField resignFirstResponder];
    [self.pwdNewTextField resignFirstResponder];
    [self.pwdNew2TextField resignFirstResponder];
    
    [self checkPwd];
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
