//
//  OuPresentAnimation.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/12/13.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "OuPresentAnimation.h"
@interface OuPresentAnimation ()
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic, assign) CGRect finalRect;
@property (nonatomic, weak) UIImageView* imageView;
@end
@implementation OuPresentAnimation
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.4;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    self.transitionContext = transitionContext;
    self.finalRect =  self.desRect;
    
        [self startPresentAnimation];
    
    
    
}


-(void)startPresentAnimation{
    
    UIView* contentView = [self.transitionContext containerView];
    [contentView addSubview:[self bgView]];
    UIViewController* toVc = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.imageRect];
    self.imageView = imageView;
    imageView.image = self.image;
    imageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(0, 0);
    imageView.layer.shadowOpacity = 5;
    imageView.layer.shadowRadius = 5;
    [contentView addSubview:imageView];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.transform = CGAffineTransformScale(imageView.transform, 1.2, 1.2);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            imageView.frame = self.finalRect;
            imageView.transform = CGAffineTransformScale(imageView.transform, 1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                imageView.frame = self.finalRect;
                self.finalRect = imageView.frame;
            } completion:^(BOOL finished) {
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    imageView.layer.shadowRadius = 0;
                    
                    [contentView addSubview:toVc.view];
                    [self setupCircleAnimation];
                    [contentView bringSubviewToFront:imageView];
                    imageView.alpha = 0;
                });
                
            }];
            
            
        }];
        
    }];
    
}
-(UIView*)bgView{
    UIView* view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.tag = 1;
    UIView* topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 220)];
    view.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    topView.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    [view addSubview:topView];
    
    view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 1;
    }];
    return view;
}
-(void)setupCircleAnimation{
    CGPoint point = CGPointMake(20, 150);
    UIBezierPath* origionPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x + self.imageRect.size.width / 2, point.y + self.imageRect.size.height / 2, 0, 0)];
    
    CGFloat X = [UIScreen mainScreen].bounds.size.width - point.x;
    CGFloat Y = [UIScreen mainScreen].bounds.size.height - point.y;
    CGFloat radius = sqrtf(X * X + Y * Y);
    UIBezierPath* finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(point.x + self.imageRect.size.width / 2, point.y + self.imageRect.size.height / 2, 0, 0), -radius, -radius)];
    
    UIViewController* toVc = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.path = finalPath.CGPath;
    toVc.view.layer.mask = layer;
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.delegate = self;
    animation.fromValue = (__bridge id _Nullable)(origionPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(finalPath.CGPath);
    animation.duration = 0.3;
    [layer addAnimation:animation forKey:@"path"];
    
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
        
        [self.transitionContext completeTransition:YES];
        
        
        [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
        [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
        
        
    
    
}
@end
