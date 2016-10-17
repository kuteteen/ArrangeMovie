//
//  SCHttpOperationMgr.h
//  Portal
//
//  Created by 王雪成 on 15/3/24.
//  Copyright (c) 2015年 suechang.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "SCHttpOperation.h"

@interface SCHttpOperationMgr : NSObject

+(AFHTTPRequestOperationManager *)httpMgr:(RequestMethodType)method;

@end
