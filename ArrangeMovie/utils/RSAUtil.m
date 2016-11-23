//
//  RSAUtil.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/23.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "RSAUtil.h"

@implementation RSAUtil
/**
 *  用私钥签名
 *
 *  @param data
 *  @param privatekey
 *
 *  @return
 */
+ (NSString *)sign:(NSString *)data privatekey:(NSString *)privatekey{
    NSData *encodeData = [self encryptByPrivateKey:[data dataUsingEncoding:NSUTF8StringEncoding] privatekey:privatekey];
    return nil;
}


+ (NSData *)encryptByPrivateKey:(NSData *)data privatekey:(NSString *)privatekey{
    //对秘钥解密
    return nil;
}
@end
