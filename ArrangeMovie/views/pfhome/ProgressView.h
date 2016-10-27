//
//  ProgressView.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/27.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView
@property (strong,nonatomic) UIView *bottomView;//底层
@property (strong,nonatomic) UIView *topView;//表层

- (instancetype)initWithNewFrame:(CGRect)frame;

//设置topView宽度比例
- (void)setTopViewWithRatio:(CGFloat)ratio;
@end
