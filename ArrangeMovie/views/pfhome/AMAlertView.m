//
//  AMAlertView.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/19.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "AMAlertView.h"

@implementation AMAlertView

- (instancetype)initWithconsFrame:(CGRect)frame{
    self = [[[NSBundle mainBundle] loadNibNamed:@"AMAlertView" owner:nil options:nil] objectAtIndex:0];
    if (self) {
        self.frame = frame;
        self.topViewHeight.constant = 46*autoSizeScaleY;
        self.titleLabelHeight.constant = 22*autoSizeScaleY;
        self.titleLabel.font = [UIFont systemFontOfSize:18.f*autoSizeScaleY];
        self.closeBtnWidth.constant = 22*autoSizeScaleY;
        self.closeBtnHeight.constant = 22*autoSizeScaleY;
        self.alpha = 1;
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

- (void)setChildView:(UIView *)childView{
    [self.contentView addSubview:childView];
}

//关闭当前视图
- (IBAction)closeView:(UIButton *)sender {
    [[self getCurrentViewController] dismissViewControllerAnimated:NO completion:nil];
}


/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}
@end
