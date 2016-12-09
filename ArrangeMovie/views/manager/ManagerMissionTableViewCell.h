//
//  ManagerMissionTableViewCell.h
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/10/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "SCTableViewCell.h"
#import "EMIShadowImageView.h"
#import "Task.h"
#import "ManagerMissionViewController.h"

@interface ManagerMissionTableViewCell : SCTableViewCell

@property (nonatomic,strong) ManagerMissionViewController *viewController;

@property (nonatomic,assign) int pageIndex;

@property (nonatomic, strong) Task *task;
@property (weak, nonatomic) IBOutlet UILabel *flagLabel;
@property (weak, nonatomic) IBOutlet UIButton *delTaskBtn;

@property (weak, nonatomic) IBOutlet EMIShadowImageView *postImgView;

@property (nonatomic, assign) CGRect imgRect;
@end
