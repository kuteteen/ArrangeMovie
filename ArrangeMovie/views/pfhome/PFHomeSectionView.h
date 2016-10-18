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


@interface PFHomeSectionView : UIView
@property (weak, nonatomic) IBOutlet EMIShadowImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *groupImgView;//分组箭头
@property (weak, nonatomic) IBOutlet UILabel *bigNumLab;//大数字
@property (weak, nonatomic) IBOutlet UILabel *bigSymbLab;//大百分比
@property (weak, nonatomic) IBOutlet UIImageView *stateImgView;//上升/下降箭头
@property (weak, nonatomic) IBOutlet UILabel *smallNumLab;//小数字
@property (weak, nonatomic) IBOutlet UILabel *smallSymbLab;//小百分比

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
@end
