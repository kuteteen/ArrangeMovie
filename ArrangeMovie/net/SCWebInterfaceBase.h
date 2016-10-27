//
//  SCWebInterfaceBase.h
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/10/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface SCWebInterfaceBase : NSObject
///服务器地址
@property (nonatomic,copy) NSString *server;
///访问地址
@property (nonatomic,copy) NSString *url;

/**
 *  将传入参数转成所需要上传的参数格式
 *
 *  @param param 传入参数,一般是NSArray
 *
 *  @return 符合接口文档的参数格式
 */
-(NSDictionary *)inboxObject:(id)param;

/**
 *  解析服务器返回的结果
 *
 *  @param result 服务器返回
 *
 *  @return
 */
-(id)unboxObject:(NSDictionary *)result;

@end
