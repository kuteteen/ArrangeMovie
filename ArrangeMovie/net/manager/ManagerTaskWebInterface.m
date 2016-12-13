//
//  ManagerTaskWebInterface.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/7.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ManagerTaskWebInterface.h"
#import "Task.h"

@implementation ManagerTaskWebInterface

-(instancetype)init {
    self = [super init];
    if(self){
        self.url = [NSString stringWithFormat:@"%@%@",self.server,@"movieTaskList.do"];
    }
    return self;
}

-(NSDictionary *)inboxObject:(id)param {
    NSArray *array = param;
    if(array.count>0){
        int userid = [array[0] intValue];
        int taskstatus = [array[1] intValue];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
        [dict setObject:@(userid) forKey:@"userid"];
        [dict setObject:@(taskstatus) forKey:@"taskstatus"];//0新任务，1已领取2审核中3已完成
        [dict setObject:array[2] forKey:@"usertype"];
        return dict;
    }
    return nil;
}

-(id)unboxObject:(NSDictionary *)result {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:2];
    NSInteger success = [[result objectForKey:@"success"] integerValue];
    if (success==1) {
        [array addObject:@1];
        [array addObject:@([[result objectForKey:@"canreceive"] longValue])];//可领取
        [array addObject:@([[result objectForKey:@"received"] longValue])];//已领取
        [array addObject:@([[result objectForKey:@"needpay"] longValue])];//需要支付
        [array addObject:@([[result objectForKey:@"payed"] longValue])];//已支付
        [array addObject:@([[result objectForKey:@"needaudit"] longValue])];//待审核
        [array addObject:@([[result objectForKey:@"audited"] longValue])];//已审核
        NSArray *tasks = [result objectForKey:@"data"];
        [array addObject:[Task mj_objectArrayWithKeyValuesArray:tasks]];
    }else {
        [array addObject:@2];
        [array addObject:[result valueForKey:@"msg"]];
    }
    return array;
}

@end
