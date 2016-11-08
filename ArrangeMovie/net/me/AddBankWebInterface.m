//
//  AddBankWebInterface.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/7.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "AddBankWebInterface.h"
#import "BankCard.h"

@implementation AddBankWebInterface

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
        NSString *userid = array[0];
        BankCard *bankcard = array[1];
        NSDictionary *bank = [bankcard mj_keyValues];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:bank];
        [dict setObject:userid forKey:@"userid"];
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
