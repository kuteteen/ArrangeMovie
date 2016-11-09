//
//  EMIShadowImageView.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/10.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "EMIShadowImageView.h"
#import "UIColor+Hex.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+CornerRadius.h"

@implementation EMIShadowImageView

/**
 *
 *
 *  @param pathType 阴影路径:圆形/矩形
 *  @param color    阴影颜色
 *  @param offset   偏移位置
 *  @param opacity  不透明度
 *  @param radius   阴影半径
 */
-(void) setShadowWithType:(EMIShadowPathType)pathType
              shadowColor:(UIColor *)color
             shadowOffset:(CGSize)offset
            shadowOpacity:(float)opacity
             shadowRadius:(CGFloat)radius
                    image:(NSString *)image
              placeholder:(NSString *)placeholder {
    switch (pathType) {
        case EMIShadowPathRectangle:
            self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
            self.layer.shadowColor = color.CGColor;//阴影颜色
            self.layer.shadowOffset = offset;//偏移距离
            self.layer.shadowOpacity = opacity;//不透明度
            self.layer.shadowRadius = radius;//半径
            if(image){
                if ([image hasPrefix:@"http"]) {
                    [self sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:placeholder]];
                }else if(image.length>0){
                    self.image = [UIImage imageNamed:image];
                }else if(placeholder.length>0){
                    self.image = [UIImage imageNamed:placeholder];
                }
            }else if(placeholder.length>0){
                self.image = [UIImage imageNamed:placeholder];
            }
            
            
            break;
        case EMIShadowPathCircle:
            //            CGRect selfFrame = self.frame;
            if(self.frame.size.height==self.frame.size.width){
                //新图片
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                
                [imageView zy_cornerRadiusRoundingRect];
                if(image){
                    if ([image hasPrefix:@"http"]) {
                        [imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:placeholder]];
                    }else if(image.length>0){
                        imageView.image = [UIImage imageNamed:image];
                    }else if(placeholder.length>0){
                        imageView.image = [UIImage imageNamed:placeholder];
                    }
                }else if(placeholder.length>0){
                    imageView.image = [UIImage imageNamed:placeholder];
                }
//                imageView.layer.masksToBounds = YES;
//                imageView.layer.cornerRadius = imageView.frame.size.width/2;
                
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
                self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width) cornerRadius:self.frame.size.width/2].CGPath;
                self.layer.shadowColor = color.CGColor;//阴影颜色
                self.layer.shadowOffset = offset;//偏移距离
                self.layer.shadowOpacity = opacity;//不透明度
                self.layer.shadowRadius = radius;//半径
                //清除子视图中的uiimageview
                for (UIView *item in self.subviews) {
                    if ([item isKindOfClass:[UIImageView class]]) {
                        [item removeFromSuperview];
                    }
                    
                }
                [self addSubview:imageView];
            }
            break;
        case EMIShadowPathRound:
            if (self.frame.size.width==self.frame.size.height) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                [imageView zy_cornerRadiusRoundingRect];
                if(image){
                    if ([image hasPrefix:@"http"]) {
                        [imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:placeholder]];
                    }else if(image.length>0){
                        imageView.image = [UIImage imageNamed:image];
                    }else if(placeholder.length>0){
                        imageView.image = [UIImage imageNamed:placeholder];
                    }
                }else if(placeholder.length>0){
                    imageView.image = [UIImage imageNamed:placeholder];
                }
                
//                imageView.layer.masksToBounds = YES;
//                imageView.layer.cornerRadius = imageView.frame.size.width/2;
                
                //描出圆形图片imageView阴影路径
                
                CALayer *shadowLayer = [CALayer layer];
                
                shadowLayer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0-4, 0-4, self.frame.size.width+8, self.frame.size.width+8) cornerRadius:self.frame.size.width/2 + 4].CGPath;
                shadowLayer.shadowColor = color.CGColor;//阴影颜色
                shadowLayer.shadowOffset = offset;//偏移距离
                shadowLayer.shadowOpacity = opacity;//不透明度
                shadowLayer.shadowRadius = radius;//半径
                
                [self.layer insertSublayer:shadowLayer atIndex:0];
                
                [self addSubview:imageView];
            }
            break;
        case EMIShadowPathRoundRectangle:
            if(1==1){
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                
                if(image){
                    if ([image hasPrefix:@"http"]) {
                        [imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:placeholder]];
                    }else if(image.length>0){
                        imageView.image = [UIImage imageNamed:image];
                    }else if(placeholder.length>0){
                        imageView.image = [UIImage imageNamed:placeholder];
                    }
                }else if(placeholder.length>0){
                    imageView.image = [UIImage imageNamed:placeholder];
                }
                imageView.backgroundColor = [UIColor whiteColor];
                imageView.layer.masksToBounds = YES;
                imageView.layer.cornerRadius = 2;
    
                //                imageView.layer.masksToBounds = YES;
                //                imageView.layer.cornerRadius = imageView.frame.size.width/2;
    
                //描出圆角图片imageView阴影路径
    
                CALayer *shadowLayer = [CALayer layer];
    
                shadowLayer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0-4, 0-4, self.frame.size.width+8, self.frame.size.width+8) cornerRadius:2].CGPath;
                shadowLayer.shadowColor = color.CGColor;//阴影颜色
                shadowLayer.shadowOffset = offset;//偏移距离
                shadowLayer.shadowOpacity = opacity;//不透明度
                shadowLayer.shadowRadius = radius;//半径
                
                [self.layer insertSublayer:shadowLayer atIndex:0];
                
                [self addSubview:imageView];
            }
            break;
        default:
            break;
    }
}

@end
