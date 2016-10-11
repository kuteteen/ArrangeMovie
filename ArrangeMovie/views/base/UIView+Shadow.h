//
//  UIView+Shadow.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/10.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Shadow)

- (void)setShadowWithshadowColor:(UIColor *)color
     shadowOffset:(CGSize)offset
    shadowOpacity:(float)opacity
     shadowRadius:(CGFloat)radius;
@end
