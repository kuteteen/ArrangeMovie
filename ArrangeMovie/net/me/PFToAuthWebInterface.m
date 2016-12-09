//
//  PFToAuthWebInterface.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/7.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "PFToAuthWebInterface.h"

@implementation PFToAuthWebInterface

-(instancetype)init {
    self = [super init];
    if(self){
        self.url = [NSString stringWithFormat:@"%@%@",self.server,@"uploadcertfile.do"];
    }
    return self;
}

-(NSDictionary *)inboxObject:(id)param {
    NSArray *array = param;
    if(array.count>0){
        int userid = [array[0] intValue];
        NSArray *imgs = array[1];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
        [dict setObject:@(userid) forKey:@"userid"];
        [dict setObject:imgs forKey:@"imgs"];
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
    }else {
        [array addObject:@2];
        [array addObject:[result valueForKey:@"msg"]];
    }
    return array;
}

@end
