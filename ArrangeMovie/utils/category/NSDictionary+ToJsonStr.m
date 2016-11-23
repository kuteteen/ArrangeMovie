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
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted  error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr=%@",json);
    return json;
}
@end
