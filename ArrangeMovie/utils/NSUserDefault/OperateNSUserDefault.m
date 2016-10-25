//
//  OperateNSUserDefault.m
//  yunya
//
//  Created by 陈凯 on 16/3/21.
//  Copyright © 2016年 emi365. All rights reserved.
//

#import "OperateNSUserDefault.h"

@implementation OperateNSUserDefault


//新增临时userdefault的值
+ (void)addUserDefaultWithKeyAndValue:(NSString *)key value:(id)value{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    //同步到磁盘
    [userDefaults synchronize];
}
//读取临时userdefaultd的值
+ (NSString *)readUserDefaultWithKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [userDefaults objectForKey:key];
    return value;
}

+ (void)removeUserDefaultWithKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    //同步到磁盘
    [userDefaults synchronize];
}
@end
