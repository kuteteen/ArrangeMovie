//
//  RSAUtil.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/23.
//  Copyright © 2016年 EMI. All rights reserved.
//  RSA加密

#import <Foundation/Foundation.h>

@interface RSAUtil : NSObject
+ (NSString *)sign:(NSString *)data privatekey:(NSString *)privatekey;
@end
