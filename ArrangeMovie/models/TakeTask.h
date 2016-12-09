//
//  TakeTask.h
//  ArrangeMovie
//  接受任务
//  Created by 王雪成 on 2016/10/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakeTask : NSObject

///院线接受任务记录id
@property (nonatomic,assign) int taskdetailid;
//0接受 1完成  2放弃 3片方审核未完成 4片方审核完成 5平台审核未完成 6平台审核完成
@property (nonatomic,assign) int taskdetailstatus;
///任务接受时间
@property (nonatomic,copy) NSString *taskdetaildate;
///任务接受信息
@property (nonatomic,copy) NSString *taskinfo;
///接受任务的院线头像地址
@property (nonatomic,copy) NSString *headimg;
///接受任务的院线id
@property (nonatomic,assign) int userid;
//接受任务的用户手机号码
@property (nonatomic,copy) NSString *dn;
//任务完成度
@property (nonatomic,copy) NSString *rate;

@end
