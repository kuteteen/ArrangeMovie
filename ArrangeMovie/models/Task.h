//
//  Task.h
//  ArrangeMovie
//  任务
//  Created by 王雪成 on 2016/10/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TakeTask.h"

@interface Task : NSObject

///任务id
@property (nonatomic,copy) NSString *taskid;
///任务名称(让子弹飞 排片任务)
@property (nonatomic,copy) NSString *taskname;
///院线经理接受任务
@property (nonatomic,strong) NSArray<TakeTask*> *data;
///任务发布者id
@property (nonatomic,copy) NSString *userid;
///电影id
@property (nonatomic,copy) NSString *filmid;
///电影名称
@property (nonatomic, strong) NSString *filmname;
///导演
@property (nonatomic, strong) NSString *filmdirector;
///主演
@property (nonatomic, strong) NSString *filmstars;
///任务份数
@property (nonatomic,copy) NSString *tasknum;
///任务剩余份数
@property (nonatomic,copy) NSString *surplusnum;
///任务积分
@property (nonatomic,copy) NSString *taskpoints;
///开始时间
@property (nonatomic,copy) NSString *startdate;
///结束时间
@property (nonatomic,copy) NSString *enddate;
///院线级别id
@property (nonatomic,copy) NSString *gradeid;
///院线级别名称
@property (nonatomic,copy) NSString *gradename;
///任务类型（排片任务、宣传任务）
@property (nonatomic,copy) NSString *tasktype;

@end
