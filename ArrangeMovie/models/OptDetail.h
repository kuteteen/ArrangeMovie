//
//  OptDetail.h
//  ArrangeMovie
//  积分操作明细
//  Created by 王雪成 on 2016/10/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptDetail : NSObject

///业务操作时间
@property (nonatomic,copy) NSString *optdate;
///操作类型（1充值、2提现、3消费、4 收益）
@property (nonatomic,copy) NSString *opttype;
///支付人员手机号
@property (nonatomic,copy) NSString *payuserdn;

@end
