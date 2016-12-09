//
//  MeBankCardTableViewCell.m
//  ArrangeMovie
//
//  Created by Emi-iMac on 16/10/10.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeBankCardTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AMAlertView.h"
#import "CKAlertViewController.h"
#import "DeleteBankWebInterface.h"
#import "SCHttpOperation.h"

@interface MeBankCardTableViewCell()
{
    CKAlertViewController *ckAlertVC;
}
@end

@implementation MeBankCardTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MeBankCardTableViewCell";
    MeBankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MeBankCardTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setViewValues:(BankCard *)bankcard{
    self.bankcard = bankcard;
    [self.bankCardImgView sd_setImageWithURL:[NSURL URLWithString:self.bankcard.img] placeholderImage:defaultheadimage];
    self.bankCardNameLabel.text = self.bankcard.openaccount;
    self.bankCardAccountLabel.text = [NSString stringWithFormat:@"**** **** **** %@",[self.bankcard.account substringFromIndex:self.bankcard.account.length-3]];
}

- (IBAction)deleteBankCard:(UIButton *)sender {
    AMAlertView *amalertview = [[AMAlertView alloc] initWithconsFrame:CGRectMake(43.5*autoSizeScaleX, (667/2-95.5)*autoSizeScaleY, 288*autoSizeScaleX, 191*autoSizeScaleY)];
    [amalertview setTitle:@"解除绑定"];
    UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 288*autoSizeScaleX, 145*autoSizeScaleY)];
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(24*autoSizeScaleX, 77*autoSizeScaleY, 240*autoSizeScaleX, 41*autoSizeScaleY);
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"alert_jiechu"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(delTask:) forControlEvents:UIControlEventTouchUpInside];
    [childView addSubview:sureBtn];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(24*autoSizeScaleX, 0, 240*autoSizeScaleX, 77*autoSizeScaleY)];
    lab.font = [UIFont fontWithName:@"DroidSansFallback" size:17.f*autoSizeScaleY];
    lab.textColor = [UIColor colorWithHexString:@"15151b"];
    lab.text = @"确认是否解除绑定的银行卡?";
    lab.textAlignment = NSTextAlignmentCenter;
    [childView addSubview:lab];
    
    [amalertview setChildView:childView];
    ckAlertVC = [[CKAlertViewController alloc] initWithAlertView:amalertview];
    
    [self.viewController presentViewController:ckAlertVC animated:NO completion:nil];
}

-(void)delTask:(id)sender {
    __unsafe_unretained typeof (self) weakself = self;
    DeleteBankWebInterface *medeleteInterface = [[DeleteBankWebInterface alloc] init];
    NSDictionary *param = [medeleteInterface inboxObject:@[@(self.viewController.user.userid),@(self.viewController.user.usertype),@(self.bankcard.bankid)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:medeleteInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [medeleteInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            [weakself.viewController.view makeToast:@"删除成功" duration:2.0 position:CSToastPositionCenter];
            [weakself.viewController viewWillAppear:YES];
        }else{
            [weakself.viewController.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
        }
    } WithErrorCodeBlock:^(id errorCode) {
        [weakself.viewController.view makeToast:@"请求错误" duration:2.0 position:CSToastPositionCenter];
    } WithFailureBlock:^{
        [weakself.viewController.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
    }];
    [ckAlertVC dismissViewControllerAnimated:NO completion:nil];
}
@end
