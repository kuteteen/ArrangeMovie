//
//  ManagerMissionBtnTableViewCell.h
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/10/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "SCTableViewCell.h"
#import "ManagerMissionDetailViewController.h"
#import "Task.h"

@interface ManagerMissionBtnTableViewCell : SCTableViewCell

@property (nonatomic, strong) Task *task;

@property (nonatomic,assign) int flag;

@property (strong,nonatomic) ManagerMissionDetailViewController *viewController;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
