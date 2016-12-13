//
//  OuPresentAnimation.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/12/13.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OuPresentAnimation : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) CGRect imageRect;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, assign) CGRect desRect;
@end
