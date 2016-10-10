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
    EMIShadowPathRound
}EMIShadowPathType;

-(void) setShadowWithType:(EMIShadowPathType)pathType
              shadowColor:(UIColor *)color
             shadowOffset:(CGSize)offset
            shadowOpacity:(float)opacity
             shadowRadius:(CGFloat)radius
                    image:(NSString *)image;


@end
