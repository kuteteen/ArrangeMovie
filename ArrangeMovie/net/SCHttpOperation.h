//
//  HttpOperation.h
//  OToO
//
//  Created by 王雪成 on 15-1-25.
//  Copyright (c) 2015年 suechang.wang. All rights reserved.
//
#import <Foundation/Foundation.h>

//定义返回请求数据的block类型
typedef void (^ReturnValueBlock) (id returnValue);
typedef void (^ErrorCodeBlock) (id errorCode);
typedef void (^FailureBlock)();


typedef NS_ENUM(NSInteger,RequestMethodType) {
    RequestMethodTypeGet = 0,
    RequestMethodTypePost = 1,
    RequestMethodTypePut = 2,
    RequestMethodTypeDelete = 3
};

@interface SCHttpOperation : NSObject

/**
 *  http请求
 *
 *  @param method 请求方式
 *  RequestMethodTypeGet = 0,
    RequestMethodTypePost = 1,
    RequestMethodTypePut = 2,
    RequestMethodTypeDelete = 3
 *
 *  @param array 传入参数
 *
 *  @return 对应的字典
 */
+(void)requestWithMethod: (RequestMethodType)method
                 withURL: (NSString *)url
           withparameter: (NSDictionary *)dict
    WithReturnValeuBlock: (ReturnValueBlock)block
      WithErrorCodeBlock: (ErrorCodeBlock)errorBlock
        WithFailureBlock: (FailureBlock)failureBlock;
@end


