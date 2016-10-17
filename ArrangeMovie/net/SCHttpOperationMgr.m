//
//  SCHttpOperationMgr.m
//  Portal
//
//  Created by 王雪成 on 15/3/24.
//  Copyright (c) 2015年 suechang.wang. All rights reserved.
//

#import "SCHttpOperationMgr.h"

@implementation SCHttpOperationMgr

+(AFHTTPRequestOperationManager *)httpMgr:(RequestMethodType)method
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    if(method==1){
        //申明请求的数据是json类型
        mgr.requestSerializer = [AFJSONRequestSerializer serializer];
        [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [mgr.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    }
    //申明返回的结果是json类型
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    
//    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
//    [mgr.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObject:@"text/plain"]];
//    NSLog(@"%@",mgr.responseSerializer.acceptableContentTypes);
    
    
    return mgr;
}

@end
