//
//  ReleaseTaskWebInterface.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/7.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ReleaseTaskWebInterface.h"

@implementation ReleaseTaskWebInterface
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
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        @try {
            [dict setObject:array[0] forKey:@"userid"];
            [dict setObject:array[1] forKey:@"filmid"];
            [dict setObject:array[2] forKey:@"tasknum"];
            [dict setObject:array[3] forKey:@"taskpoints"];
            [dict setObject:array[4] forKey:@"startdate"];
            [dict setObject:array[5] forKey:@"enddate"];
            [dict setObject:array[6] forKey:@"gradeid"];
            [dict setObject:array[7] forKey:@"tasktype"];
            [dict setObject:array[8] forKey:@"imgs"];//是个数组，存着图片地址
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
