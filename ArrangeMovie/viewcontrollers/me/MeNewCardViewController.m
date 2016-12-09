//
//  MeNewCardViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/11.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeNewCardViewController.h"
#import "AddBankWebInterface.h"
#import "SCHttpOperation.h"

@interface MeNewCardViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *noTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveBankBtn;
@property (weak, nonatomic) IBOutlet UILabel *bankTypeLabel;

@end

@implementation MeNewCardViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定银行卡";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.contents = [UIColor whiteColor];
    
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.bankTypeDic != nil) {
        self.bankTypeLabel.text = [self.bankTypeDic objectForKey:@"name"];
    }

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.nameTextField]) {
        [self.nameTextField resignFirstResponder];
        [self.noTextField becomeFirstResponder];
    }else if ([textField isEqual:self.noTextField]){
        [self.noTextField resignFirstResponder];
        [self.bankNameTextField becomeFirstResponder];
    }else{
        [self.bankNameTextField resignFirstResponder];
    }
    return YES;
}

//添加银行卡
- (IBAction)addBankCard:(UIButton *)sender {
    
    if (self.nameTextField.text == nil || [self.nameTextField.text isEqualToString:@""]) {
        [self.view makeToast:@"请填写持卡人姓名" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    if (self.noTextField.text == nil || [self.noTextField.text isEqualToString:@""]) {
        [self.view makeToast:@"请填写卡号" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    if (self.bankNameTextField.text == nil || [self.bankNameTextField.text isEqualToString:@""]) {
        [self.view makeToast:@"请填写开户行" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    if (self.bankTypeLabel.text == nil || [self.bankTypeLabel.text isEqualToString:@"选择银行类型"]) {
        [self.view makeToast:@"请选择银行类型" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    __unsafe_unretained typeof (self) weakself = self;
    AddBankWebInterface *addbankInterface = [[AddBankWebInterface alloc] init];
    NSDictionary *param = [addbankInterface inboxObject:@[@(self.user.userid),@(self.user.usertype),@"",[self.bankTypeDic objectForKey:@"id"],self.bankNameTextField.text,self.nameTextField.text,self.noTextField.text,self.currentAllBankCardCounts == 0 ? @(1):@(0)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:addbankInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [addbankInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            [weakself.view makeToast:@"添加银行卡成功" duration:2.0 position:CSToastPositionCenter];
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
}
- (IBAction)selectBankType:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"tobanktypeVC" sender:self];
}

@end
