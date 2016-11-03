//
//  AppDelegate.h
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/8.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


//storyboard 按比例自适应view
@property float autoSizeScaleX;
@property float autoSizeScaleY;


+ (void)storyBoradAutoLay:(UIView *)allView;
@end

