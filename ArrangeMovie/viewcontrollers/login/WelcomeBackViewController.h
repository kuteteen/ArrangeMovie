//
//  WelcomeBackViewController.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/10.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "EMIBaseViewController.h"

@interface WelcomeBackViewController : EMIBaseViewController
@property (strong,nonatomic)NSArray *param;//网络请求参数

@property (strong,nonatomic)NSString *tempuserType;//临时变量，用以判断跳转的首页
@end
