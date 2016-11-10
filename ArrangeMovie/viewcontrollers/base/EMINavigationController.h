//
//  SCNavigationController.h
//  EMINest
//
//  Created by WongSuechang on 16-2-22.
//  Copyright (c) 2016年 emi365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBarButtonItem+Extension.h"
#import "EMIShadowImageView.h"
#import "OUNavAnimation.h"

@interface EMINavigationController : UINavigationController

@property (nonatomic, strong) OUNavAnimation* animation;

/**
 *  push 方法
 *
 *  @param viewController 目标控制器
 *  @param imageView      所要移动的ImageView
 *  @param origin         原始位置
 *  @param desRect        目标位置矩形
 */
-(void)pushViewController:(UIViewController *)viewController withImageView:(EMIShadowImageView*)imageView originRect:(CGRect)originRect desRect:(CGRect)desRect;

@end
