//
//  AMDetailDoneViewController.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/27.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "TakeTask.h"

@interface AMDetailDoneViewController : EMIBaseViewController

@property (nonatomic,assign) int selectedTaskId;//任务id

@property (nonatomic,strong) TakeTask *selectedTakeTask;//选中的院线经理接受任务记录

@property (nonatomic,assign) int showOKBtn;//是否显示沟按钮0显示，1不显示
@end
