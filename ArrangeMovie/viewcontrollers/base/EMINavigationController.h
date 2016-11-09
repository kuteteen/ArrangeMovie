//
//  SCNavigationController.h
//  EMINest
//
//  Created by WongSuechang on 16-2-22.
//  Copyright (c) 2016年 emi365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBarButtonItem+Extension.h"

@interface EMINavigationController : UINavigationController

/**
 *  push 方法
 *
 *  @param viewController 目标控制器
 *  @param imageView      所要移动的ImageView
 *  @param origin         原始位置
 *  @param desRect        目标位置矩形
 */
-(void)pushViewController:(UIViewController *)viewController withImageView:(UIImageView*)imageView originRect:(CGRect)originRect desRect:(CGRect)desRect;

@end
