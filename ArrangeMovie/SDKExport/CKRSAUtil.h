//
//  CKRSAUtil.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#import "NSData+Base64.h"


#define kSHA1ChosenDigestLength CC_SHA1_DIGEST_LENGTH  // SHA-1消息摘要的数据位数160位
#define kMD5ChosenDigestLength CC_MD5_DIGEST_LENGTH  //  
@interface CKRSAUtil : NSObject
//SHA1签名
+(NSString *)signTheDataSHA1WithRSA:(NSString *)plainText;
//MD5签名
+(NSString *)signTheDataMD5WithRSA:(NSString *)plainText;
@end
