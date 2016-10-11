//
//  UIView+Shadow.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/10.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "UIView+Shadow.h"

@implementation UIView (Shadow)

- (void)setShadowWithshadowColor:(UIColor *)color
                    shadowOffset:(CGSize)offset
                   shadowOpacity:(float)opacity
                    shadowRadius:(CGFloat)radius{
    self.layer.shadowColor = color.CGColor;//阴影颜色
    self.layer.shadowOffset = offset;//偏移距离
    self.layer.shadowOpacity = opacity;//不透明度
    self.layer.shadowRadius = radius;//半径
}
@end
