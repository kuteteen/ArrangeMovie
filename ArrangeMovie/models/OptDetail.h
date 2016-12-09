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
@property (nonatomic,assign) int opttype;
///支付人员手机号
@property (nonatomic,copy) NSString *payuserdn;
//积分金额
@property (nonatomic,assign) double integral;
//积分提现状态
@property (nonatomic,assign) int state;//提现状态，0提交  1处理中 2已打款 3未打款
@end
