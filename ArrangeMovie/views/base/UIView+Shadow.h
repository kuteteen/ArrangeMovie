//
//  UIView+Shadow.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/10.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"
#import "UIImageView+CornerRadius.h"

@interface UIView (Shadow)

- (void)setShadowWithshadowColor:(UIColor *)color
     shadowOffset:(CGSize)offset
    shadowOpacity:(float)opacity
     shadowRadius:(CGFloat)radius;

//圆角阴影

- (void)setCornerRadiusShadowWithshadowColor:(UIColor *)color
                                shadowOffset:(CGSize)offset
                               shadowOpacity:(float)opacity
                                shadowRadius:(CGFloat)radius;

//设置一个环形边框,给头像用的
- (void)setCircleBorder:(UIImage *)image;

//设置一个方形边框,给图片浏览器用的（加载相册图片）
- (void)setRectangleBorder:(id)image;
@end
