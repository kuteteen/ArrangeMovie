//
//  TableWithNoDataView.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "TableWithNoDataView.h"

@implementation TableWithNoDataView

- (instancetype)initGesture{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf:)];
        
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

//点击刷新表格
- (void)tapSelf:(UITapGestureRecognizer *)sender{
    self.tapGestureBlock();
}

- (void)initLabel:(NSString *)text{
    self.txtLab = [[UILabel alloc] init];
    [self addSubview:self.txtLab];
    self.txtLab.text = text;
    self.txtLab.textAlignment = NSTextAlignmentCenter;
    self.txtLab.textColor = [UIColor grayColor];
    self.txtLab.font = [UIFont systemFontOfSize:23.f];
    //自动布局
    self.txtLab.sd_layout.centerXEqualToView(self).centerYEqualToView(self).heightIs(30).widthRatioToView(self,0.8);
    
    //点击刷新的提示
    UILabel *refLab = [[UILabel alloc] init];
    [self addSubview:refLab];
    refLab.text = @"点击刷新";
    refLab.textAlignment = NSTextAlignmentCenter;
    refLab.textColor = [UIColor grayColor];
    refLab.font = [UIFont systemFontOfSize:18.f];
    //自动布局
    refLab.sd_layout.centerXEqualToView(self).topSpaceToView(self.txtLab,15).heightIs(20).widthRatioToView(self,0.8);
    
}

- (void)setBlock:(tabBlock)block{
    self.tapGestureBlock = block;
}
@end
