//
//  NSData+Base64.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)


+ (NSData *)dataWithBase64EncodedString:(NSString *)string;

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;

- (NSString *)base64EncodedString;

@end
