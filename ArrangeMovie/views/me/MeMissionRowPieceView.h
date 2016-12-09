//
//  MeMissionRowPieceView.h
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/9.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakeTask.h"
#import "EMIShadowImageView.h"
#import "MeMissionDetailViewController.h"

@interface MeMissionRowPieceView : UIView

@property (nonatomic,strong) MeMissionDetailViewController *viewController;


@property (assign,nonatomic)int taskid;

@property (strong,nonatomic)TakeTask *taketask;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet EMIShadowImageView *headimg;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UIView *redLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redWidth;
@property (weak, nonatomic) IBOutlet UIView *lightBlueLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lightBlueWidth;
@property (weak, nonatomic) IBOutlet UIView *blueLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueWidth;

-(instancetype)initNibWithFrame:(CGRect)frame;

- (void)setTakeTaskValues:(TakeTask *)taketask;
@end
