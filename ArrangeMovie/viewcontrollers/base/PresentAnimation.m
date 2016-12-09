//
//  PresentAnimation.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/24.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "PresentAnimation.h"
#import "PFHomeViewController.h"
#import "MeViewController.h"

@implementation PresentAnimation
// 返回动画的时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.8;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MeViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * container = [transitionContext containerView];
    
    [container addSubview:toVC.view];
    [container bringSubviewToFront:fromVC.view];
    toVC.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    fromVC.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);

    
    // 动画
    [UIView animateWithDuration:0.8 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromVC.view.frame = CGRectMake(-screenWidth,0,screenWidth,screenHeight);
    } completion:^(BOOL finished) {
        //转场执行完成
        [transitionContext completeTransition: ![transitionContext transitionWasCancelled]];
    }];
}
@end
