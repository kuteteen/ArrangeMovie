//
//  AMActionSheet.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "AMActionSheet.h"

@interface AMActionSheet ()
@property(nonatomic,strong) void(^ clickBlock)(AMActionSheet *amactionsheet);
@property (strong, nonatomic) UIButton *cancelBtn;//取消按钮
@property (strong, nonatomic) UIButton *surelBtn;//确定按钮

@end

@implementation AMActionSheet

- (instancetype)initWithBlock:(void (^)(AMActionSheet *))sureBlock frame:(CGRect)frame childView:(UIView *)childView{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.clickBlock = sureBlock;
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelBtn.frame = CGRectMake(5, 2, 50, 20*autoSizeScaleY);
        self.cancelBtn.titleLabel.font = [UIFont fontWithName:@"DroidSansFallback" size:14.f*autoSizeScaleY];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor colorWithHexString:@"d9dbe0"] forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelBtn];
        self.surelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.surelBtn.frame = CGRectMake(frame.size.width-5-50, 2, 50, 20*autoSizeScaleY);
        self.surelBtn.titleLabel.font = [UIFont fontWithName:@"DroidSansFallback" size:14.f*autoSizeScaleY];
        [self.surelBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.surelBtn setTitleColor:[UIColor colorWithHexString:@"162271"] forState:UIControlStateNormal];
        self.surelBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.surelBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.surelBtn];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 2, screenWidth-120, 20*autoSizeScaleY)];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.textColor = [UIColor colorWithHexString:@"162271"];
        [self addSubview:self.titleLab];
        
        [self addSubview:childView];
    }
    return self;
}
- (void)setTitle:(NSString *)title{
    self.titleLab.text = title;
}
- (void)cancel:(UIButton *)sender{
    [[self getCurrentViewController] dismissViewControllerAnimated:NO completion:nil];
}
- (void)sure:(UIButton *)sender{
    self.clickBlock(self);
}
- (void)setSureBtnHidden:(BOOL)flag{
    self.surelBtn.hidden = flag;
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
