//
//  TableWithNoDataView.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "TableWithNoDataView.h"

@implementation TableWithNoDataView

- (instancetype)initWithText:(NSString *)text{
    self = [super init];
    if (self) {
        
        
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
    self.txtLab.sd_layout.centerXEqualToView(self).centerYEqualToView(self).heightIs(60).widthRatioToView(self,0.8);
    
}

- (void)setBlock:(tabBlock)block{
    self.tapGestureBlock = block;
}
@end
