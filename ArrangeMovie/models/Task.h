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
@property (nonatomic,assign) int taskid;
///任务名称(让子弹飞 排片任务)
@property (nonatomic,copy) NSString *taskname;
///院线经理接受任务
@property (nonatomic,strong) NSArray<TakeTask*> *data;
///任务发布者id
@property (nonatomic,assign) int userid;
///任务发布者手机号码
@property (nonatomic,copy) NSString *dn;
///任务发布者头像
@property (nonatomic,copy) NSString *headimg;
///电影id
@property (nonatomic,assign) int filmid;
///电影名称
@property (nonatomic, copy) NSString *filmname;
///导演
@property (nonatomic, copy) NSString *filmdirector;
///主演
@property (nonatomic, copy) NSString *filmstars;
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
@property (nonatomic,assign) int gradeid;
///院线级别名称
@property (nonatomic,copy) NSString *gradename;
///任务类型（排片任务、宣传任务）
@property (nonatomic,copy) NSString *tasktype;
///排片量
@property (nonatomic,copy) NSString *shownum;

//排片率
@property (nonatomic,assign) double rate;

//上升下降百分比例
@property (nonatomic,assign) double percent;//小于0下降

//任务封面
@property (nonatomic,copy) NSString *img;

//0全部1待审核2已发布3已支付
@property (nonatomic,assign) int taskstatus;

@property (nonatomic,assign) int taskdetailid;

//封面，院线经理首页用
@property (nonatomic,copy) NSString *filmimg;

@end
