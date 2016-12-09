//
//  MeMissionTableViewCell.h
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "SCTableViewCell.h"
#import "Task.h"
#import "EMIShadowImageView.h"
#import "MeMissionViewController.h"

@interface MeMissionTableViewCell : SCTableViewCell

@property (nonatomic,strong) MeMissionViewController *viewController;

@property (weak, nonatomic) IBOutlet EMIShadowImageView *postImgView;

@property (nonatomic,assign) int pageIndex;

@property (nonatomic, strong) Task *task;
@property (nonatomic, assign) CGRect imgRect;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskdateLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskstatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *filmnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskpointLabel;
@property (weak, nonatomic) IBOutlet UIButton *deltaskBtn;

@end
