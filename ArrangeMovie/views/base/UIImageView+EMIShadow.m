//
//  UIImageView+EMIShadow.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/10.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "UIImageView+EMIShadow.h"
#import "UIColor+Hex.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImageView (EMIShadow)

-(UIImageView *)setShadowWithType:(EMIShadowPathType)pathType shadowColor:(UIColor *)color shadowOffset:(CGSize)offset shadowOpacity:(float)opacity shadowRadius:(CGFloat)radius {
    switch (pathType) {
        case EMIShadowPathRectangle:
            self.layer.shadowColor = color.CGColor;//阴影颜色
            self.layer.shadowOffset = offset;//偏移距离
            self.layer.shadowOpacity = opacity;//不透明度
            self.layer.shadowRadius = radius;//半径
            return self;
            break;
        case EMIShadowPathRound:
//            CGRect selfFrame = self.frame;
            if(self.frame.size.height==self.frame.size.width){
                //添加圆形边框
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x-4,self.frame.origin.y-4,self.frame.size.width+8, self.frame.size.height+8)];
                
                CAGradientLayer *borderLayer = [CAGradientLayer layer];
                borderLayer.frame = CGRectMake(0-4, 0-4, self.frame.size.width+8, self.frame.size.height+8);
                borderLayer.cornerRadius = (float)self.layer.frame.size.width/2;
                borderLayer.startPoint = CGPointMake(0, 1);
                borderLayer.endPoint = CGPointMake(1, 0);
                UIColor *firstColor = [UIColor colorWithHexString:@"bfd3fd" alpha:1];
                UIColor *secondColor = [UIColor colorWithHexString:@"bfd3fd" alpha:0.3];
                
                borderLayer.colors = [NSArray arrayWithObjects:(id)firstColor.CGColor,(id)secondColor.CGColor,(id)[UIColor greenColor].CGColor, nil];
//                [self.layer insertSublayer:borderLayer atIndex:0];
//                [self.layer insertSublayer:borderLayer above:self.layer];
                [imageView.layer addSublayer:borderLayer];
                self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                [imageView addSubview:self];
                
                //描出圆形图片imageView阴影路径
                
                
                
                
                return imageView;
            }
            break;
        default:
            break;
    }
    return nil;
}

@end
