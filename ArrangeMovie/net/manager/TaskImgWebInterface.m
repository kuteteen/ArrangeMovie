//
//  TaskImgWebInterface.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/7.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "TaskImgWebInterface.h"

@implementation TaskImgWebInterface

-(instancetype)init {
    self = [super init];
    if(self){
        self.url = [NSString stringWithFormat:@"%@%@",self.server,@"taskImgList.do"];
    }
    return self;
}

-(NSDictionary *)inboxObject:(id)param {
    NSArray *array = param;
    if(array.count>0){
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
        [dict setObject:array[0] forKey:@"userid"];
        [dict setObject:array[1] forKey:@"taskid"];
        [dict setObject:array[2] forKey:@"taskdetailid"];
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
        [array addObject:[result objectForKey:@"data"]];//data:imgdate imgs:[]
    }else {
        [array addObject:@2];
        [array addObject:[result valueForKey:@"msg"]];
    }
    return array;
}

@end
