//
//  RegisterWebInterface.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/7.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "RegisterWebInterface.h"

@implementation RegisterWebInterface
-(instancetype)init {
    self = [super init];
    if(self){
        self.url = [NSString stringWithFormat:@"%@%@",self.server,@"register.do"];
    }
    return self;
}

-(NSDictionary *)inboxObject:(id)param {
    NSArray *array = param;
    if(array.count>0){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        //usertype:0片方 1院线经理
        
        //headimg头像地址，来源：点完立即注册，1.有头像先上传头像，得到地址后（注：无头像就不传）2.请求注册接口
        
        if (array.count == 4) {
            //无头像
            @try {
                [dict setObject:array[0] forKey:@"dn"];
                [dict setObject:array[1] forKey:@"usertype"];
                [dict setObject:array[2] forKey:@"code"];
                [dict setObject:array[3] forKey:@"password"];
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            } @finally {
                
            }
        }else{
            //有头像
            @try {
                [dict setObject:array[0] forKey:@"dn"];
                [dict setObject:array[1] forKey:@"usertype"];
                [dict setObject:array[2] forKey:@"code"];
                [dict setObject:array[3] forKey:@"password"];
                [dict setObject:array[4] forKey:@"headimg"];
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            } @finally {
                
            }
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
