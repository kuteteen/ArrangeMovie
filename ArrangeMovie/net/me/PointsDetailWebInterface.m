//
//  PointsDetailWebInterface.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/7.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "PointsDetailWebInterface.h"
#import "OptDetail.h"

@implementation PointsDetailWebInterface

-(instancetype)init {
    self = [super init];
    if(self){
        self.url = [NSString stringWithFormat:@"%@%@",self.server,@"getIntegralDetail.do"];
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
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:2];
    NSInteger success = [[result objectForKey:@"success"] integerValue];
    if (success==1) {
        [array addObject:@1];
        NSArray *tasks = [result objectForKey:@"data"] ;
        [array addObject:[OptDetail mj_objectArrayWithKeyValuesArray:tasks]];
    }else {
        [array addObject:@2];
        [array addObject:[result valueForKey:@"msg"]];
    }
    return array;
}

@end
