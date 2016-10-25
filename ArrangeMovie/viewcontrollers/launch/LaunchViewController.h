//
//  LaunchViewController.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/19.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (strong,nonatomic) UIPageControl *pageControl;
@property (strong,nonatomic) NSMutableArray<UIImage *> *imageArray;
@property (strong,nonatomic) UIButton *btn;
@end
