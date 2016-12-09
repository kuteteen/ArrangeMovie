//
//  MeBankCardTableViewCell.h
//  ArrangeMovie
//
//  Created by Emi-iMac on 16/10/10.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "SCTableViewCell.h"
#import "BankCard.h"
#import "MeBankCardViewController.h"

@interface MeBankCardTableViewCell : SCTableViewCell

@property (nonatomic,strong) MeBankCardViewController *viewController;

@property (strong,nonatomic) BankCard *bankcard;//银行卡信息实体

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *bankCardImgView;
@property (weak, nonatomic) IBOutlet UILabel *bankCardNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *bankCardAccountLabel;


- (void)setViewValues:(BankCard *)bankcard;
@end
