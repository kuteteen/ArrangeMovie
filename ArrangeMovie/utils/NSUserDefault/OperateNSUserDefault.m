//
//  OperateNSUserDefault.m
//  yunya
//
//  Created by 陈凯 on 16/3/21.
//  Copyright © 2016年 emi365. All rights reserved.
//

#import "OperateNSUserDefault.h"

@implementation OperateNSUserDefault

//返回[NSUserDefaults standardUserDefaults]
+ (NSUserDefaults *)shareInstance{
    return [NSUserDefaults standardUserDefaults];
}

//将user信息存入userDefault中
+ (void)saveUser:(User *)user{
    [[self shareInstance] setObject:user forKey:@"user"];
    //同步到磁盘
    [[self shareInstance] synchronize];
}
//新增临时userdefault的值
+ (void)addUserDefaultWithKeyAndValue:(NSString *)key value:(id)value{
    
    [[self shareInstance] setObject:value forKey:key];
    //同步到磁盘
    [[self shareInstance] synchronize];
}
//读取临时userdefaultd的值
+ (NSString *)readUserDefaultWithKey:(NSString *)key{
    NSString *value = [[self shareInstance] objectForKey:key];
    return value;
}

+ (void)removeUserDefaultWithKey:(NSString *)key{
    [[self shareInstance] removeObjectForKey:key];
    //同步到磁盘
    [[self shareInstance] synchronize];
}
@end
