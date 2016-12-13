//
//  OperateNSUserDefault.m
//  yunya
//
//  Created by 陈凯 on 16/3/21.
//  Copyright © 2016年 emi365. All rights reserved.
//

#import "OperateNSUserDefault.h"




//爱排片 NSUserDefaults存取一览：key   type       decription    usage        清除时间
                            //user   User类     用户所有信息    很多地方要用   退出登录时
                            //headimg Nsstring  头像地址       user已有，单独再存为了重新登录时有个默认用户      登陆了新的用户
                            //dn     NSstring   用户手机号     user已有，单独再存为了重新登录时有个默认用户       登陆了新的用户
                            //isFirstUse NSString  是否第一次使用(0或nil(没设置过为nil)是，1不是)  决定首页的引导图是否显示      退出登录时
                            //password  NSString(MD5加密）  登录，修改密码，退出登录
@implementation OperateNSUserDefault

//返回[NSUserDefaults standardUserDefaults]
+ (NSUserDefaults *)shareInstance{
    return [NSUserDefaults standardUserDefaults];
}

//将user信息存入userDefault中
+ (void)saveUser:(User *)user{
    
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [userDic setObject:@(user.userid) forKey:@"userid"];
    
    [userDic setObject:user.dn forKey:@"dn"];
    
    [userDic setObject:@(user.usertype) forKey:@"usertype"];
    @try {
        
       [userDic setObject:user.nickname forKey:@"nickname"];
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    
    [userDic setObject:user.name forKey:@"name"];
    
    [userDic setObject:user.sex forKey:@"sex"];
    
    [userDic setObject:@(user.userpoints) forKey:@"userpoints"];
    
    [userDic setObject:@(user.userstatus) forKey:@"userstatus"];
    @try {
    
        [userDic setObject:user.headimg forKey:@"headimg"];
   
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    @try {
        
        [userDic setObject:@(user.gradeid) forKey:@"gradeid"];
        
        [userDic setObject:user.gradename forKey:@"gradename"];
        
        [userDic setObject:user.gradeicon forKey:@"gradeicon"];
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    
    
    
    [[self shareInstance] setObject:userDic forKey:@"user"];
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


/*
 本项目
 userDefault使用记录
 
 filmCover:电影封面图片
 */
@end
