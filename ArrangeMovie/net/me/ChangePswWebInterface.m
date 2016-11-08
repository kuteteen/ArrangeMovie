//
//  ChangePswWebInterface.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/4.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ChangePswWebInterface.h"

@implementation ChangePswWebInterface

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
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
        [dict setObject:array[0] forKey:@"dn"];
        [dict setObject:array[1] forKey:@"oldpassword"];
        [dict setObject:array[2] forKey:@"password"];
        return dict;
    }
    return nil;
}

-(id)unboxObject:(NSDictionary *)result {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:2];
    NSInteger success = [[result objectForKey:@"success"] integerValue];
    if (success==1) {
        [array addObject:@1];
    }else {
        [array addObject:@2];
        [array addObject:[result valueForKey:@"msg"]];
    }
    return array;
}

@end
