//
//  YZMButton.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/13.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"
#import "UIView+SDAutoLayout.h"


@interface YZMButton : UIButton


//点击回调
@property(nonatomic,strong) void(^ clickBlock)(void);

//倒计时时长
@property(nonatomic,assign) int time;

//计时器
@property(strong,nonatomic) NSTimer *timer;
/**
 *  初始化方法
 *
 *  @param time 倒计时时长
 *
 *  @return 返回self
 */
- (instancetype)initWithTime:(int)time;
@end
