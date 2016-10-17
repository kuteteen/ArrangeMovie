//
//  TableWithNoDataView.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SDAutoLayout.h"


typedef  void (^tabBlock)(void);
@interface TableWithNoDataView : UIView
//点击手势
@property(strong,nonatomic)UITapGestureRecognizer *tapGesture;
//无数据提示
@property(strong,nonatomic)UILabel *txtLab;
//点击回调
@property(strong,nonatomic)tabBlock tapGestureBlock;
//初始化方法
/**
 *  初始化
 *
 *  @param text 无数据提示
 *
 *  @return 返回self
 */
- (instancetype)initWithText:(NSString *)text;

/**
 *  给label赋值，需用在父视图位置以确定的情况下
 *
 *  @param text text
 */
- (void)initLabel:(NSString *)text;
/**
 *  设置回调
 *
 *  @param block 
 */
- (void)setBlock:(tabBlock)block;
@end
