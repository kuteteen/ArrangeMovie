//
//  MePwdViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/13.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MePwdViewController.h"

@interface MePwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdNewTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdNew2TextField;

@end

@implementation MePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.contents = [UIColor whiteColor];
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
