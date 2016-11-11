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

@interface MeMissionTableViewCell : SCTableViewCell
@property (weak, nonatomic) IBOutlet EMIShadowImageView *postImgView;
@property (nonatomic, strong) Task *task;
@property (nonatomic, assign) CGRect imgRect;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskdateLabel;

@end
