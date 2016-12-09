//
//  UpdateProfileWebInterface.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/10/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "UpdateProfileWebInterface.h"
#import "User.h"

@implementation UpdateProfileWebInterface

-(instancetype)init {
    self = [super init];
    if(self){
        self.url = [NSString stringWithFormat:@"%@%@",self.server,@"modifyDetail.do"];
    }
    return self;
}

-(NSDictionary *)inboxObject:(id)param {
    NSArray *array = param;
    if(array.count>0){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        @try {
            [dict setObject:array[0] forKey:@"userid"];
            [dict setObject:array[1] forKey:@"nickname"];
            [dict setObject:array[2] forKey:@"name"];
            [dict setObject:array[3] forKey:@"sex"];
            [dict setObject:array[4] forKey:@"headimg"];
            [dict setObject:array[5] forKey:@"usertype"];
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
