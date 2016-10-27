//
//  User.h
//  ArrangeMovie
//  用户
//  Created by WongSuechang on 2016/10/9.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

//@property (nonatomic,copy) NSString *msg;//登录失败信息
///用户id
@property (nonatomic,copy) NSString *userid;
///手机号码
@property (nonatomic,copy) NSString *dn;
///用户类型 0:片方 1:院线经理
@property (nonatomic,assign) int usertype;
///昵称
@property (nonatomic,copy) NSString *nickname;
///姓名
@property (nonatomic,copy) NSString *name;
///性别 0:女 1:男
@property (nonatomic,assign) int sex;
///头像地址
@property (nonatomic,copy) NSString *headimg;
///用户积分
@property (nonatomic,copy) NSString *userpoints;
///院线等级id
@property (nonatomic,copy) NSString *gradeid;
///院线等级名称
@property (nonatomic,copy) NSString *gradename;
///院线等级图标
@property (nonatomic,copy) NSString *gradeicon;

@end
