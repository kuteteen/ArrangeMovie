//
//  ProgressView.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/27.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ProgressView.h"
#import "UIColor+Hex.h"
#import "UIview+SDAutoLayout.h"

@implementation ProgressView

- (instancetype)initWithNewFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setCorner:self];
        //底层
        self.bottomView = [[UIView alloc] init];
        self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.bottomView.alpha = 0.4;
        [self addSubview:self.bottomView];
        self.bottomView.sd_layout.leftSpaceToView(self,0).topSpaceToView(self,0).bottomSpaceToView(self,0).widthRatioToView(self,1);
        [self setCorner:self.bottomView];
        //顶层
        self.topView = [[UIView alloc] init];
        self.topView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self addSubview:self.topView];
        self.topView.sd_layout.leftSpaceToView(self,0).topSpaceToView(self,0).bottomSpaceToView(self,0).widthIs(frame.size.width);
        [self setCorner:self.topView];
    }
    return self;
}
//设置topView宽度比例
- (void)setTopViewWithRatio:(CGFloat)ratio{
    self.topView.sd_layout.widthIs(self.frame.size.width*ratio);
}

//设置圆角
- (void)setCorner:(UIView *)corView{
    corView.layer.masksToBounds = YES;
    corView.layer.cornerRadius = corView.frame.size.height/2;
}
@end
