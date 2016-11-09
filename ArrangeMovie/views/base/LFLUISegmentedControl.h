//
//  LFLUISegmentedControl.h
//  SegmentedLFL
//
//  Created by vintop_xiaowei on 16/1/2.
//  Copyright © 2016年 vintop_DragonLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"

@protocol LFLUISegmentedControlDelegate< NSObject>

@optional
/**
 外界调用获取点击下标
 */
-(void)uisegumentSelectionChange:(NSInteger)selection;
@end
@interface LFLUISegmentedControl : UIView

@property(nonatomic,strong)id <LFLUISegmentedControlDelegate>delegate;
@property(nonatomic,strong)NSMutableArray *ButtonArray;/**< 对应的标题文字 */
@property(strong,nonatomic)UIColor *LFLBackGroundColor;/**< BackGround颜色 */
@property(strong,nonatomic)UIColor *titleColor;/**< 标题文字颜色 */
@property(strong,nonatomic)UIColor *selectColor;/**< 选中按钮的颜色 */
@property(strong,nonatomic)UIFont *titleFont;/**< 字体大小 */
@property(strong,nonatomic)UIFont *selectFont;/**< 选中字体大小 */
@property(strong,nonatomic)UIColor *lineColor;/**< 下划线的颜色 */
@property(assign,nonatomic)NSInteger selectSeugment;//当前选中的位置
@property(assign,nonatomic)BOOL isClickable;//按钮是否可以点击 ,默认不可以点击

-(void)AddSegumentArray:(NSArray *)SegumentArray;
-(instancetype)initWithFrame:(CGRect)frame;
-(void)selectTheSegument:(NSInteger)segument;
@end
