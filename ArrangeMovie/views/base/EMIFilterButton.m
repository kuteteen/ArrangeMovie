//
//  EMIFilterButton.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/10/31.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "EMIFilterButton.h"
#import "UIImage+SCUtil.h"
#import "UIColor+Hex.h"

@implementation EMIFilterButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initButton];
        
    }
    return self;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [self initButton];
        
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initButton];
    }
    return self;
}


-(void) initButton {
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"cacbcf"]] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"162271" alpha:1]] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 高亮的时候不需要调整内部的图片为灰色
    self.adjustsImageWhenHighlighted = NO;
    [self.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [self.layer setCornerRadius:14];
}


@end
