//
//  Encryption.h
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/22.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface Encryption : NSObject

//md5加密方法
+ (NSString *)md5EncryptWithString:(NSString *)inputStr;

@end
