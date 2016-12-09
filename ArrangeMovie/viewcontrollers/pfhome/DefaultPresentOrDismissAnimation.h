//
//  DefaultPresentOrDismissAnimation.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/12/1.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultPresentOrDismissAnimation : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic,assign) int type;//0为present1为dismiss

+ (instancetype)transitionWithTransitionType:(int)type;

- (instancetype)initWithTransitionType:(int)type;
@end
