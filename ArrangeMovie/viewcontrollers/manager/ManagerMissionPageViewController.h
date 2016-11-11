//
//  ManagerMissionPageViewController.h
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/3.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagerMissionTableViewCell.h"

@protocol ManagerMissionPageViewControllerDelegate <NSObject>

-(void)checkMission:(ManagerMissionTableViewCell *)cell;

@end


@interface ManagerMissionPageViewController : UIViewController
///第N页
@property (nonatomic, assign) NSInteger pageIndex;
@property(assign,nonatomic)id<ManagerMissionPageViewControllerDelegate> delegate;

@end
