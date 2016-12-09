//
//  NSDictionary+ToJsonStr.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/23.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "NSDictionary+ToJsonStr.h"

@implementation NSDictionary (ToJsonStr)
- (NSString *)getJson{
    
    //options  NSJSONWritingPrettyPrinted :格式化输出json，提高可读性
    // 不设置就输出一整行
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:nil  error:nil];
    
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr=%@",json);
    return json;
    
    //以上方法得到的字符串顺序是乱的，有一些关键情况，比如签名或加密时，传的字符串不同，影响很大

}
@end
