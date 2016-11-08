//
//  PFTaskListWebInterface.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/4.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "PFTaskListWebInterface.h"
#import "Task.h"

@implementation PFTaskListWebInterface

-(instancetype)init {
    self = [super init];
    if(self){
        self.url = [NSString stringWithFormat:@"%@%@",self.server,@""];
    }
    return self;
}

-(NSDictionary *)inboxObject:(id)param {
    NSArray *array = param;
    if(array.count>0){
        NSString *userid = array[0];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
        [dict setObject:userid forKey:@"userid"];
        return dict;
    }
    return nil;
}

-(id)unboxObject:(NSDictionary *)result {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:2];
    NSInteger success = [[result objectForKey:@"success"] integerValue];
    if (success==1) {
        [array addObject:@1];
        NSArray *tasks = [result objectForKey:@"task"];
        [array addObject:[Task mj_objectArrayWithKeyValuesArray:tasks]];
    }else {
        [array addObject:[result valueForKey:@"msg"]];
    }
    return array;
}


@end
