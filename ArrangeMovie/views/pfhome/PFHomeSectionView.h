//
//  PFHomeSectionView.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMIShadowImageView.h"
#import "UIColor+Hex.h"
#import "UILabel+StringFrame.h"
#import "UIView+SDAutoLayout.h"
#import "TableWithNoDataView.h"


@interface PFHomeSectionView : UIView
@property (weak, nonatomic) IBOutlet EMIShadowImageView *headImgView;
@property (weak, nonatomic) IBOutlet UIImageView *groupImgView;//分组箭头
@property (weak, nonatomic) IBOutlet UILabel *bigNumLab;//大数字
@property (weak, nonatomic) IBOutlet UILabel *bigSymbLab;//大百分比
@property (weak, nonatomic) IBOutlet UIImageView *stateImgView;//上升/下降箭头
@property (weak, nonatomic) IBOutlet UILabel *smallNumLab;//小数字
@property (weak, nonatomic) IBOutlet UILabel *smallSymbLab;//小百分比
@property (weak, nonatomic) IBOutlet UIView *lineView;//分割线，展开式显示


//标题
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIScrollView *labScrollView;//用于承载过长的标题

//点击手势
@property(strong,nonatomic)UITapGestureRecognizer *tapGesture;
//点击回调
@property(strong,nonatomic)tabBlock selectSectionBlock;

//是否展开
@property(assign,nonatomic)BOOL isOpen;//yes打开，no关闭
/**
 *  <#Description#>
 *
 *  @param type        0上升，1下降
 *  @param imageName   图片
 *  @param titleStr    标题
 *  @param bigNumStr
 *  @param smallNumStr 
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithType:(NSString *)type imageName:(NSString *)imageName titleStr:(NSString *)titleStr bigNumStr:(NSString *)bigNumStr smallNumStr:(NSString *)smallNumStr;


//展开/关闭section
- (void)operateSection:(BOOL) state;

//设置回调
- (void)setBlock:(tabBlock)block;
@end
