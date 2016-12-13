//
//  DismissAnimation.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/24.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "DismissAnimation.h"
#import "MeViewController.h"
#import "PFHomeViewController.h"

@implementation DismissAnimation
// 返回动画的时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    MeViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * container = [transitionContext containerView];
    
    [container addSubview:toVC.view];
    [container bringSubviewToFront:fromVC.view];
    toVC.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    fromVC.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);

    // 动画
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromVC.view.frame = CGRectMake(screenWidth,0,screenWidth,screenHeight);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition: ![transitionContext transitionWasCancelled]]; // 如果参数写成yes，当用户取消pop时，会继续执行动画，也就是让detailVC消失，设置成这个参数，会避免这样的错误
    }];
    
}
@end
