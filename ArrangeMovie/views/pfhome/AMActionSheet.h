//
//  AMActionSheet.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMActionSheet : UIView
@property (strong,nonatomic) UILabel *titleLab;//标题
- (instancetype)initWithBlock:(void(^)(AMActionSheet *amactionsheet))sureBlock frame:(CGRect)frame childView:(UIView *)childView;

- (void)setTitle:(NSString *)title;

- (void)setSureBtnHidden:(BOOL)flag;//隐藏确定按钮；
@end
