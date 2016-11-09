//
//  MeMissionActorView.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/9.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeMissionActorView.h"

@implementation MeMissionActorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initNibWithFrame:(CGRect)frame {
    self = [[[NSBundle mainBundle] loadNibNamed:@"MeMissionActorView" owner:nil options:nil] objectAtIndex:0];
    if(self){
        self.frame = frame;
    }
    return self;
}

@end
