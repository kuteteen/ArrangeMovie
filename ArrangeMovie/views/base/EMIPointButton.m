//
//  EMIPointButton.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/12.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "EMIPointButton.h"
#import "UIColor+Hex.h"
#import "UIImage+SCUtil.h"

@implementation EMIPointButton

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
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    // 文字对齐
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    // 文字颜色
    [self setTitleColor:[UIColor colorWithHexString:@"EDEDEE"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"FFFFFF" alpha:0.14]] forState:UIControlStateHighlighted];
    // 字体
    // 高亮的时候不需要调整内部的图片为灰色
    self.adjustsImageWhenHighlighted = NO;
    [self.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [self.layer setCornerRadius:10];
    [self.layer setBorderWidth:0.5];//设置边界的宽度
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){1,1,1,1});
    self.layer.borderColor = color;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageX = 20;
    CGFloat imageY = 7;
    CGFloat imageW = 19;
    CGFloat imageH = 20;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    
    CGFloat titleX = 45;
    CGFloat titleY = 7;
    CGFloat titleW = contentRect.size.width-45-8;
    CGFloat titleH = 20;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end
