//
//  UIScrollView+AllowPanGestureEventPass.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/29.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "UIScrollView+AllowPanGestureEventPass.h"

@implementation  UIScrollView (AllowPanGestureEventPass)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
 {
       if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
                      && [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
        {
            return YES;
        }
        else
        {
            return  NO;
        }
}
@end
