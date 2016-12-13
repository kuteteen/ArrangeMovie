//
//  PayOrderModel.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/12/13.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayOrderModel : NSObject
+ (instancetype)sharedInstance;

@property(nonatomic,assign) int chargeid;
@property(nonatomic,strong) NSString *orderno;

//请求交易结果
- (NSDictionary *)requestPayState;
@end
