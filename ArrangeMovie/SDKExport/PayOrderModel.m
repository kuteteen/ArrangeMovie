//
//  PayOrderModel.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/12/13.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "PayOrderModel.h"
#import "SCHttpOperation.h"

@implementation PayOrderModel
static PayOrderModel *_instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

//请求交易结果
- (NSDictionary *)requestPayState{
    NSMutableDictionary *resultDic;
    if (self.chargeid != 0&&self.orderno != nil) {
        [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:@"http://116.62.42.99/app/appnotify.do" withparameter:@{@"chargeid":@(self.chargeid),@"orderno":self.orderno} WithReturnValeuBlock:^(id returnValue) {
            
        } WithErrorCodeBlock:^(id errorCode) {
            
        } WithFailureBlock:^{
            
        }];
    }else{
        return nil;
    }
     return nil;
}
@end
