//
//  SCSlideView.m
//  SCFadeSlideView
//
//  Created by WongSuechang on 2016/9/30.
//  Copyright © 2016年 suechang. All rights reserved.
//

#import "SCSlidePageView.h"

@implementation SCSlidePageView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
//        [self addSubview:self.mainImageView];
        [self addSubview:self.coverView];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        _coverView.backgroundColor = [UIColor blackColor];
    }
    return _coverView;
}
@end
