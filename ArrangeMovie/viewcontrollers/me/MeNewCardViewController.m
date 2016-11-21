//
//  MeNewCardViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/11.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeNewCardViewController.h"

@interface MeNewCardViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *noTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveBankBtn;

@end

@implementation MeNewCardViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定银行卡";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.contents = [UIColor whiteColor];
    
    
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

@end
