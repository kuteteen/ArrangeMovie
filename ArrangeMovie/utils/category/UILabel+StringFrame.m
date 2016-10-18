//
//  UILabel+StringFrame.m
//  yunya
//
//  Created by WongSuechang on 16/3/22.
//  Copyright © 2016年 emi365. All rights reserved.
//

#import "UILabel+StringFrame.h"

@implementation UILabel (StringFrame)

- (CGSize)boundingRectWithSize:(CGSize)size {
    NSDictionary *attribute = @{NSFontAttributeName:self.font};
    CGSize retSize = [self.text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    return retSize;
}

@end
