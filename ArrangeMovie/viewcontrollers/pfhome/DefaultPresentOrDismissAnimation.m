//
//  DefaultPresentOrDismissAnimation.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/12/1.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "DefaultPresentOrDismissAnimation.h"

@implementation DefaultPresentOrDismissAnimation
+ (instancetype)transitionWithTransitionType:(int)type{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(int)type{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    switch (_type) {
        case 0:
            return 0.2;
            break;
            
        case 1:
            return 0.2;
            break;
    }
    
    return 0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //为了将两种动画的逻辑分开，变得更加清晰，我们分开书写逻辑，
    switch (_type) {
        case 0:
            [self presentAnimation:transitionContext];
            break;
            
        case 1:
            [self dismissAnimation:transitionContext];
            break;
    }
}


/**
 *  实现present动画
 */
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{

    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView * container = [transitionContext containerView];
    
    [container addSubview:toVC.view];
    [container bringSubviewToFront:toVC.view];
    toVC.view.frame = CGRectMake(0, screenHeight, screenWidth, screenHeight);
    fromVC.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    
    // 动画
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        toVC.view.frame = CGRectMake(0,0,screenWidth,screenHeight);
    } completion:^(BOOL finished) {
        //转场执行完成
        [transitionContext completeTransition: ![transitionContext transitionWasCancelled]];
    }];
}

/**
 *  实现dimiss动画
 */
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    //注意在dismiss的时候fromVC就是vc2了，toVC才是VC1了，注意理解这个逻辑关系
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * container = [transitionContext containerView];
    
    [container addSubview:toVC.view];
    [container bringSubviewToFront:fromVC.view];
    toVC.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    fromVC.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    // 动画
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromVC.view.frame = CGRectMake(0,screenHeight,screenWidth,screenHeight);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition: ![transitionContext transitionWasCancelled]]; // 如果参数写成yes，当用户取消pop时，会继续执行动画，也就是让detailVC消失，设置成这个参数，会避免这样的错误
    }];
}
@end
