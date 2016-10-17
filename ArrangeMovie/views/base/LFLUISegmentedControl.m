//
//  LFLUISegmentedControl.m
//  SegmentedLFL
//
//  Created by vintop_xiaowei on 16/1/2.
//  Copyright © 2016年 vintop_DragonLi. All rights reserved.
//

#import "LFLUISegmentedControl.h"

@interface LFLUISegmentedControl ()<LFLUISegmentedControlDelegate>
{
    CGFloat widthFloat;
    UIView* buttonDown;
}
@end

@implementation LFLUISegmentedControl

-(void)AddSegumentArray:(NSArray *)SegumentArray
{
    NSInteger seugemtNumber=SegumentArray.count;
    widthFloat=(self.bounds.size.width)/seugemtNumber;
    for (int i=0; i<SegumentArray.count; i++) {
        UIButton* button=[[UIButton alloc]initWithFrame:CGRectMake(i*widthFloat, 0, widthFloat, self.bounds.size.height-3)];
        [button setTitle:SegumentArray[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:self.titleFont];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectColor forState:UIControlStateSelected];
        [button setTag:i];
        [button addTarget:self action:@selector(changeTheSegument:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            //            默认下划线高  3
            buttonDown=[[UIView alloc]initWithFrame:CGRectMake(i*widthFloat, self.bounds.size.height-3, widthFloat, 3)];
            
#pragma mark -----buttonDown 设置下划线颜色
            [buttonDown setBackgroundColor:self.lineColor];
            [self addSubview:buttonDown];
        }
        [self addSubview:button];
        [self.ButtonArray addObject:button];
    }
    [[self.ButtonArray firstObject] setSelected:YES];
    [((UIButton *)[self.ButtonArray firstObject]).titleLabel setFont:self.selectFont];
}
-(void)changeTheSegument:(UIButton*)button
{
    [self selectTheSegument:button.tag];
}
-(void)selectTheSegument:(NSInteger)segument
{
    if (self.selectSeugment!=segument) {
        [self.ButtonArray[self.selectSeugment] setSelected:NO];
        [((UIButton *)self.ButtonArray[self.selectSeugment]).titleLabel setFont:self.titleFont];
        [self.ButtonArray[segument] setSelected:YES];
        [((UIButton *)self.ButtonArray[segument]).titleLabel setFont:self.selectFont];
        [UIView animateWithDuration:0.1 animations:^{
            [buttonDown setFrame:CGRectMake(segument*widthFloat,self.bounds.size.height-3, widthFloat, 3)];
        }];
        self.selectSeugment=segument;
        [self.delegate uisegumentSelectionChange:self.selectSeugment];
    }
}
/**
 34 ---默认高度,可以根据项目需求自己更改
 */
-(instancetype)initWithFrame:(CGRect)frame
{
    self.selectSeugment=0;
    self.ButtonArray=[NSMutableArray arrayWithCapacity:_ButtonArray.count];
    self.titleFont=[UIFont systemFontOfSize:18.0];
    self.selectFont = [UIFont systemFontOfSize:18.0];
    self=[super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    self.LFLBackGroundColor = [UIColor clearColor];
    self.titleColor = [UIColor whiteColor];
    self.selectColor=[UIColor whiteColor];
    self.lineColor = [UIColor colorWithHexString:@"#84C343"];
    //    整体背景颜色
    self.backgroundColor = self.LFLBackGroundColor;
    return self;
}

//-(void)setLineColor:(UIColor *)lineColor{
//    self.lineColor = lineColor;
//}
//-(void)setLFLBackGroundColor:(UIColor *)LFLBackGroundColor{
//    self.LFLBackGroundColor = LFLBackGroundColor;
//}
//-(void)setTitleFont:(UIFont *)titleFont{
//    self.titleFont = titleFont;
//}
//-(void)setSelectFont:(UIFont *)selectFont{
//    self.selectFont = selectFont;
//}
//-(void)setTitleColor:(UIColor *)titleColor{
//    self.titleColor = titleColor;
//}
//-(void)setSelectColor:(UIColor *)selectColor{
//    self.selectColor = selectColor;
//}
@end
