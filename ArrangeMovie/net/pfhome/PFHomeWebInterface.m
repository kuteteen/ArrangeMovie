//
//  PFHomeWebInterface.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/7.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "PFHomeWebInterface.h"
#import "Task.h"

@implementation PFHomeWebInterface
-(instancetype)init {
    self = [super init];
    if(self){
        self.url = [NSString stringWithFormat:@"%@%@",self.server,@"getTaskList.do"];
    }
    return self;
}

-(NSDictionary *)inboxObject:(id)param {
    NSArray *array = param;
    if(array.count>0){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        @try {
            [dict setObject:array[0] forKey:@"userid"];
            [dict setObject:array[1] forKey:@"usertype"];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        } @finally {
            
        }
        return dict;
    }
    return nil;
}

-(id)unboxObject:(NSDictionary *)result {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    NSInteger success = [[result objectForKey:@"success"] integerValue];
    if (success==1) {
        [array addObject:@1];
        [array addObject:[result objectForKey:@"canreceive"]];//可领取
        [array addObject:[result objectForKey:@"received"]];//已领取
        [array addObject:[result objectForKey:@"needpay"]];//需要支付
        [array addObject:[result objectForKey:@"payed"]];//已支付 平台审核完成
        [array addObject:[result objectForKey:@"needaudit"]];//待审核
        [array addObject:[result objectForKey:@"audited"]];//已审核
        [array addObject:[result objectForKey:@"task"]];//所有任务，是个数组
    }else {
        [array addObject:@2];
        [array addObject:[result valueForKey:@"msg"]];
    }
    return array;
}
@end
