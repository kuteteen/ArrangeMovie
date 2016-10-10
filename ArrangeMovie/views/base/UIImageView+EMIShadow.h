//
//  UIImageView+EMIShadow.h
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/10.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (EMIShadow)
typedef enum {
    EMIShadowPathRectangle = 0,//矩形图片四周阴影
    EMIShadowPathRound
}EMIShadowPathType;

/**
 *  为图片添加阴影
 *
 *  @param pathType 圆形路径阴影或者矩形图片的阴影
 *  @param color    阴影颜色
 *  @param offset   阴影偏移  1,CGSizeMake(4, 4):添加两个边阴影;2,CGSizeMake(0, 0):添加四个边阴影
 *  @param opacity  透明度
 *  @param radius   阴影半径
 */
-(UIImageView *)setShadowWithType:(EMIShadowPathType)pathType shadowColor:(UIColor *)color shadowOffset:(CGSize)offset shadowOpacity:(float)opacity shadowRadius:(CGFloat)radius;


@end
