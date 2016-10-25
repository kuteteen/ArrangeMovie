//
//  AMAlertView.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/19.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;//关闭按钮
@property (weak, nonatomic) IBOutlet UIView *contentView;//视图中自定义子势图
@property (weak, nonatomic) IBOutlet UIView *lineView;//分割线


- (instancetype)initWithconsFrame:(CGRect)frame;

- (void)setTitle:(NSString *)title;

- (void)setChildView:(UIView *)childView;
@end
