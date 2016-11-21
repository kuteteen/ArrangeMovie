//
//  UIView+Shadow.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/10.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "UIView+Shadow.h"
#import "UIImageView+WebCache.h"


@implementation UIView (Shadow)

- (void)setShadowWithshadowColor:(UIColor *)color
                    shadowOffset:(CGSize)offset
                   shadowOpacity:(float)opacity
                    shadowRadius:(CGFloat)radius{
    self.layer.shadowColor = color.CGColor;//阴影颜色
    self.layer.shadowOffset = offset;//偏移距离
    self.layer.shadowOpacity = opacity;//不透明度
    self.layer.shadowRadius = radius;//半径
}

- (void)setCornerRadiusShadowWithshadowColor:(UIColor *)color
                                shadowOffset:(CGSize)offset
                               shadowOpacity:(float)opacity
                                shadowRadius:(CGFloat)radius{
    CALayer *shadowLayer = [CALayer layer];
    
    shadowLayer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0-2, 0-2, self.frame.size.width+4, self.frame.size.height+4) cornerRadius:2].CGPath;
    shadowLayer.shadowColor = color.CGColor;//阴影颜色
    shadowLayer.shadowOffset = offset;//偏移距离
    shadowLayer.shadowOpacity = opacity;//不透明度
    shadowLayer.shadowRadius = radius;//半径
    
    [self.layer insertSublayer:shadowLayer atIndex:0];
}
- (void)setCircleBorder:(UIImage *)image{
    if(self.frame.size.height==self.frame.size.width){
        //新图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        [imageView zy_cornerRadiusRoundingRect];
        
        imageView.image = image;
  
        //清除layer
        //是否已加过渐变layer
        int isgradient = 0;
        for (CALayer *item in self.layer.sublayers) {
            if ([item isKindOfClass:[CAGradientLayer class]]) {
                isgradient = 1;
                item.frame = CGRectMake(0-4, 0-4, self.frame.size.width+8, self.frame.size.height+8);
                item.cornerRadius = (float)(self.layer.frame.size.width+8)/2;
                
            }
            
        }
        if (isgradient == 0) {
            //添加圆形边框
            CAGradientLayer *borderLayer = [CAGradientLayer layer];
            borderLayer.frame = CGRectMake(0-4, 0-4, self.frame.size.width+8, self.frame.size.height+8);
            borderLayer.cornerRadius = (float)(self.layer.frame.size.width+8)/2;
            borderLayer.startPoint = CGPointMake(0, 1);
            borderLayer.endPoint = CGPointMake(1, 0);
            borderLayer.locations  = @[@(0.25), @(1)];
            UIColor *firstColor = [UIColor colorWithHexString:@"375595" alpha:1];
            UIColor *secondColor = [UIColor colorWithHexString:@"7899ce" alpha:1];
            
            borderLayer.colors = [NSArray arrayWithObjects:(id)firstColor.CGColor,(id)secondColor.CGColor,(id)[UIColor greenColor].CGColor, nil];
            [self.layer addSublayer:borderLayer];
        }
        
        //                [self addSubview:self];
        
        //描出圆形图片imageView阴影路径
        self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) cornerRadius:self.frame.size.width/2].CGPath;
        self.layer.shadowColor = [UIColor colorWithHexString:@"0a0e16"].CGColor;//阴影颜色
        self.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
        self.layer.shadowOpacity = 0.26;//不透明度
        self.layer.shadowRadius = 8;//半径
        //清除子视图
        for (UIView *item in self.subviews) {
            
            [item removeFromSuperview];
        }
        [self addSubview:imageView];
    }
}

- (void)setRectangleBorder:(id)image{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    if ([image isKindOfClass:[UIImage class]]) {
        imageView.image = image;
    }
    if ([image isKindOfClass:[NSString class]]) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:image]];
    }
    
    
    
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 2;
    
    
    //描出圆角图片imageView阴影路径
    
    CALayer *shadowLayer = [CALayer layer];
    
    shadowLayer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0-2, 0-2, self.frame.size.width+4, self.frame.size.height+4) cornerRadius:2].CGPath;
    shadowLayer.shadowColor = [UIColor colorWithHexString:@"0a0e16"].CGColor;//阴影颜色
    shadowLayer.shadowOffset = CGSizeZero;//偏移距离
    shadowLayer.shadowOpacity = 0.15;//不透明度
    shadowLayer.shadowRadius = 9;//半径
    
    [self.layer insertSublayer:shadowLayer atIndex:0];
    
    [self addSubview:imageView];
}
@end
