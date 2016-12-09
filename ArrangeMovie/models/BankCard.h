//
//  BankCard.h
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/10/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankCard : NSObject
//银行id
@property (nonatomic,assign) int bankid;
//银行名称
@property (nonatomic,copy) NSString *bankname;
//开户行
@property (nonatomic,copy) NSString *openaccount;
//开户人姓名
@property (nonatomic,copy) NSString *name;
//卡号
@property (nonatomic,copy) NSString *account;
//是否默认 1：默认 0：非默认
@property (nonatomic,assign) int isdefault;
//银行卡图标
@property (nonatomic,copy) NSString *img;

@end
