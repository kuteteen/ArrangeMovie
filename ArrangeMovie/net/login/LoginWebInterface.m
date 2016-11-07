//
//  LoginWebInterface.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/7.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "LoginWebInterface.h"
#import "User.h"

@implementation LoginWebInterface
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
            [dict setObject:array[0] forKey:@"dn"];
            [dict setObject:array[1] forKey:@"password"];
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
        
//        User *user1 = [User mj_objectWithKeyValues:result];
        
        User *user = [[User alloc] init];
        user.userid = [result objectForKey:@"userid"];
        user.dn = [result objectForKey:@"dn"];
        user.usertype = [[result objectForKey:@"usertype"] intValue];
        user.nickname = [result objectForKey:@"nickname"];
        user.name = [result objectForKey:@"name"];
        user.sex = [[result objectForKey:@"sex"] intValue];
        user.headimg = [result objectForKey:@"headimg"];
        user.userpoints = [result objectForKey:@"userpoints"];
        user.gradeid = [result objectForKey:@"gradeid"];
        user.gradename = [result objectForKey:@"gradename"];
        user.gradeicon = [result objectForKey:@"gradeicon"];
        
        [array addObject:user];
    }else {
        [array addObject:@2];
        [array addObject:[result valueForKey:@"msg"]];
    }
    return array;
}
@end
