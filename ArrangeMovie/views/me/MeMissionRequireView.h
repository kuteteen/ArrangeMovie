//
//  MeMissionRequireView.h
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/9.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTopLeftAlignLabel.h"

@interface MeMissionRequireView : UIView

@property (weak, nonatomic) IBOutlet SCTopLeftAlignLabel *requireContentLabel;
-(instancetype)initNibWithFrame:(CGRect)frame;
@property (weak, nonatomic) IBOutlet UILabel *taskCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *cinemaLevelLabel;

@end
