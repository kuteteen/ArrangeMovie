//
//  AlipayRequestHandler.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/12/5.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipayRequestHandler : NSObject
@property(nonatomic,strong) void(^ alireturnBlock)(NSString *returnStr);

- (void)jumpToBizPay:(NSNumber *)userid price:(NSNumber *)price usertype:(NSNumber *)usertype;
@end
