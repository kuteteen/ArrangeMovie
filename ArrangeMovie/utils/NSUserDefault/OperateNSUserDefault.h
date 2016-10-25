//
//  OperateNSUserDefault.h
//  yunya
//
//  Created by 陈凯 on 16/3/21.
//  Copyright © 2016年 emi365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperateNSUserDefault : NSObject

//新增userdefault的值
+ (void)addUserDefaultWithKeyAndValue:(NSString *)key value:(id)value;
//读取临时userdefaultd的值
+ (NSString *)readUserDefaultWithKey:(NSString *)key;
//删除
+ (void)removeUserDefaultWithKey:(NSString *)key;
@end
