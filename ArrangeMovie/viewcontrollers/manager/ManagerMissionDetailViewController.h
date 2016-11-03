//
//  ManagerMissionDetailViewController.h
//  ArrangeMovie
//
//  Created by 王雪成 on 16/10/25.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "Task.h"

@interface ManagerMissionDetailViewController : EMIBaseViewController

@property (nonatomic, strong) Task *task;
//0,新任务 1,已领取 2,审核中 3,已完成
@property (nonatomic, assign) NSInteger flag;

@end
