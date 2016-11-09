//
//  MeMissionPageViewController.h
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/2.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "Task.h"
#import "MeMissionTableViewCell.h"


@protocol MeMissionPageViewControllerDelegate <NSObject>

-(void)checkMission:(MeMissionTableViewCell *)cell;

@end

@interface MeMissionPageViewController : EMIBaseViewController

///第N页
@property (nonatomic, assign) NSInteger pageIndex;
@property(assign,nonatomic)id<MeMissionPageViewControllerDelegate> delegate;

@end
