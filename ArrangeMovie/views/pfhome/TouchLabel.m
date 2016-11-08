//
//  TouchLabel.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/4.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "TouchLabel.h"

@implementation TouchLabel

- (instancetype)initWithBlock:(void(^)(NSString *str))block frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.clickBlock = block;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf:)];
        [self addGestureRecognizer:ges];
    }
    return self;
}

- (void)tapSelf:(UITapGestureRecognizer *)sender{
    self.clickBlock(self.text);
}
@end
