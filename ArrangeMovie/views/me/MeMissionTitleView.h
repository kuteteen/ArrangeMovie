//
//  MissionTitleView.h
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/8.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMIShadowImageView.h"

@interface MeMissionTitleView : UIView
@property (weak, nonatomic) IBOutlet EMIShadowImageView *postImgView;
@property (weak, nonatomic) IBOutlet UILabel *filmNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

-(instancetype)initNibWithFrame:(CGRect)frame;

@end
