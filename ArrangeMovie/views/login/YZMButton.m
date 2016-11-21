//
//  YZMButton.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/13.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "YZMButton.h"

@implementation YZMButton

- (instancetype)initWithTime:(int)time{
    self = [super init];
    if (self) {
        self.time = time;
        [self initView];
    }
    return self;
}

- (void)initView{
    
    //刚开始不可点击
    self.enabled = NO;
    
    //边框
    
    self.layer.borderWidth = 2.f;
    self.layer.borderColor = ([UIColor colorWithHexString:@"#c9c9c9"]).CGColor;
    
    //normal状态
    [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithHexString:@"a0a0a0"] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithName:@"DroidSans-Bold" size:13.f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setBackgroundColor:[UIColor clearColor]];//colorWithHexString:@"#475A90"]
    
    
    //点击之后
    [self addTarget:self action:@selector(selfClicked:) forControlEvents:UIControlEventTouchUpInside];
}



//点击事件
- (void)selfClicked:(YZMButton *)sender{
    if ([self.titleLabel.text isEqualToString:@"获取验证码"]) {
        
        //回调中进行网络请求
        self.clickBlock();
        
        //点击状态
        self.enabled = NO;
//        [self setBackgroundColor:[UIColor colorWithHexString:@"#354d81"]];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeMachine:) userInfo:nil repeats:YES];
    }
}


//倒计时
- (void)timeMachine:(NSTimer *)timer{
    self.time--;
    [self setTitle:[NSString stringWithFormat:@"%ds",self.time] forState:UIControlStateNormal];
    
    if (self.time == 59) {
        //布局变化
        self.sd_layout.xIs(self.frame.origin.x+self.frame.size.width*0.5);
        self.sd_layout.widthIs(self.frame.size.width*0.5);
    }
    
    if (self.time == 0) {
        [self.timer invalidate];
        //释放资源
        self.timer = nil;
        
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        [self setBackgroundColor:[UIColor clearColor]];//colorWithHexString:@"#475A90"
        
        
        //计时结束，恢复布局
        self.sd_layout.xIs(self.frame.origin.x-self.frame.size.width);
        self.sd_layout.widthIs(self.frame.size.width*2);
        self.time = 60;
        self.enabled = YES;
    }
}
@end
