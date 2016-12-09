//
//  TaskDetailWebInterface.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/7.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "TaskDetailWebInterface.h"
#import "Task.h"
#import "TakeTask.h"

@implementation TaskDetailWebInterface

-(instancetype)init {
    self = [super init];
    if(self){
        self.url = [NSString stringWithFormat:@"%@%@",self.server,@"taskDetail.do"];
    }
    return self;
}

-(NSDictionary *)inboxObject:(id)param {
    NSArray *array = param;
    if(array.count>0){
        int userid = [array[0] intValue];
        int usertype = [array[1] intValue];
        int taskid = [array[2] intValue];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
        [dict setObject:@(userid) forKey:@"userid"];
        [dict setObject:@(usertype) forKey:@"usertype"];
        [dict setObject:@(taskid) forKey:@"taskid"];
        return dict;
    }
    return nil;
}

-(id)unboxObject:(NSDictionary *)result {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:2];
    NSInteger success = [[result objectForKey:@"success"] integerValue];
    if (success==1) {
        [array addObject:@1];
        Task *task = [Task mj_objectWithKeyValues:result];
        task.data = [TakeTask mj_objectArrayWithKeyValuesArray:task.data];
        [array addObject:task];
    }else {
        [array addObject:@2];
        [array addObject:[result valueForKey:@"msg"]];
    }
    return array;
}


@end
