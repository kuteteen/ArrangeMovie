//
//  ToTaskSegue.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/16.
//  Copyright © 2016年 EMI. All rights reserved.
//  跳转至发布任务的界面，要求从下至上出现新页面

#import "ToTaskSegue.h"

@implementation ToTaskSegue
//重写perform
- (void)perform{
    UIViewController *current = self.sourceViewController;
    
    UIViewController *next = self.destinationViewController;
    
    UIView *firstVCView = self.sourceViewController.view;
    UIView *secondVCView = self.destinationViewController.view;
    
    
    secondVCView.frame = CGRectMake(0.0, screenHeight, screenWidth, screenHeight);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window insertSubview:secondVCView aboveSubview:firstVCView];
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        secondVCView.frame = CGRectOffset(secondVCView.frame, 0.0, screenHeight);
    } completion:^(BOOL finished) {
        [current.navigationController pushViewController:next animated:NO];
    }];
    

    
    
}
@end
