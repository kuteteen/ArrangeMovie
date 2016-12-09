//
//  TaskHistoryWebInterface.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/4.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "TaskHistoryWebInterface.h"
#import "Task.h"

@implementation TaskHistoryWebInterface

-(instancetype)init {
    self = [super init];
    if(self){
        self.url = [NSString stringWithFormat:@"%@%@",self.server,@"taskHistory.do"];
    }
    return self;
}

-(NSDictionary *)inboxObject:(id)param {
    NSArray *array = param;
    if(array.count>0){
        int userid = [array[0] intValue];
        int taskstatus = [array[1] intValue];
        NSString *pageindex = array[2];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
        [dict setObject:@(userid) forKey:@"userid"];
        [dict setObject:@(taskstatus) forKey:@"taskstatus"];
        [dict setObject:pageindex forKey:@"pageindex"];
        [dict setObject:array[3] forKey:@"usertype"];
        return dict;
    }
    return nil;
}

-(id)unboxObject:(NSDictionary *)result {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:2];
    NSInteger success = [[result objectForKey:@"success"] integerValue];
    if (success==1) {
        [array addObject:@1];
        NSArray *tasks = [result objectForKey:@"data"];
        [array addObject:[Task mj_objectArrayWithKeyValuesArray:tasks]];
    }else {
        [array addObject:@2];
        [array addObject:[result valueForKey:@"msg"]];
    }
    return array;
}

@end
