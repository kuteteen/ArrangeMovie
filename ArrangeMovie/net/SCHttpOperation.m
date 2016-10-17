//
//  HttpOperation.m
//  OToO
//
//  Created by 王雪成 on 15-1-25.
//  Copyright (c) 2015年 suechang.wang. All rights reserved.
//

#import "SCHttpOperation.h"
#import "SCHttpOperationMgr.h"

@interface SCHttpOperation()

@end

@implementation SCHttpOperation : NSObject

+(void)requestWithMethod: (RequestMethodType)method
                 withURL: (NSString *)url
           withparameter: (NSDictionary *)dict
    WithReturnValeuBlock: (ReturnValueBlock)block
      WithErrorCodeBlock: (ErrorCodeBlock)errorBlock
        WithFailureBlock: (FailureBlock)failureBlock {
    AFHTTPRequestOperationManager *mgr = [SCHttpOperationMgr httpMgr:method];
    if(method==0){
        [mgr GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failureBlock();
        }];
    }else if(method==1){
        [mgr POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failureBlock();
            NSLog(@"%@",error);
        }];
    }else if(method==2){
        [mgr PUT:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failureBlock();
        }];
    }else if(method==3){
        [mgr DELETE:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failureBlock();
        }];
    }
}
@end
