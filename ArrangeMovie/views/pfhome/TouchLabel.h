//
//  TouchLabel.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/4.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchLabel : UILabel

@property(nonatomic,strong) void(^ clickBlock)(NSString *str);

- (instancetype)initWithBlock:(void(^)(NSString *str))block frame:(CGRect)frame;
@end
