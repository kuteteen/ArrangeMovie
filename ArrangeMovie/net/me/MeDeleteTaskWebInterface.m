//
//  MeDeleteTaskWebInterface.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/30.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeDeleteTaskWebInterface.h"

@implementation MeDeleteTaskWebInterface
-(instancetype)init {
    self = [super init];
    if(self){
        self.url = [NSString stringWithFormat:@"%@%@",self.server,@"deleteTask.do"];
    }
    return self;
}

-(NSDictionary *)inboxObject:(id)param {
    NSArray *array = param;
    if(array.count>0){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        @try {
            [dict setObject:array[0] forKey:@"userid"];
            [dict setObject:array[1] forKey:@"taskid"];
            [dict setObject:array[2] forKey:@"usertype"];
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
    }else {
        [array addObject:@2];
        [array addObject:[result valueForKey:@"msg"]];
    }
    return array;
}
@end
