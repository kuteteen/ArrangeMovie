//
//  EMIShadowImageView.h
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/10.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMIShadowImageView : UIImageView
typedef enum {
    EMIShadowPathRectangle = 0,//矩形图片四周阴影
    EMIShadowPathCircle = 1,//带圆环的阴影
    EMIShadowPathRound = 2,//普通圆形图片的阴影
    EMIShadowPathRoundRectangle//圆角矩形,2016-10-17 所有带阴影的圆角矩形半径为2
}EMIShadowPathType;

///缓存图片
@property (nonatomic, strong, nullable) UIImage *img;


-(void) setShadowWithType:(EMIShadowPathType)pathType
              shadowColor:(UIColor *)color
             shadowOffset:(CGSize)offset
            shadowOpacity:(float)opacity
             shadowRadius:(CGFloat)radius
                    image:(NSString *)image
              placeholder:(NSString *)placeholder;


@end
