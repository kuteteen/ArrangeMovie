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
        self.bottomView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:self.bottomView];
        
        [self setCorner:self.bottomView];
        //顶层
        self.topView = [[UIView alloc] init];
        self.topView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.topView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:self.topView];
        [self setCorner:self.topView];
    }
    return self;
}
//设置topView宽度比例
- (void)setTopViewWithRatio:(CGFloat)ratio{
    [UIView animateWithDuration: 0.35 delay: 0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{
        self.topView.frame = CGRectMake(0, 0, ratio*self.frame.size.width, self.frame.size.height);
    } completion: ^(BOOL finished) {
        
    }];
    
}
//设置topView的X
- (void)setXWithRatio:(CGFloat)ratio{
    [UIView animateWithDuration: 0.35 delay: 0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{
        self.topView.frame = CGRectMake(self.frame.size.width*ratio, 0, self.topView.frame.size.width, self.frame.size.height);
    } completion: ^(BOOL finished) {
        
    }];
}
//设置圆角
- (void)setCorner:(UIView *)corView{
    corView.layer.masksToBounds = YES;
    corView.layer.cornerRadius = corView.frame.size.height/2;
}
@end
