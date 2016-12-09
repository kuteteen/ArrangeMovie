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
        self.url = [NSString stringWithFormat:@"%@%@",self.server,@"addBankCard.do"];
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
            [dict setObject:array[2] forKey:@"bankname"];
            [dict setObject:array[3] forKey:@"banktype"];
            [dict setObject:array[4] forKey:@"openaccount"];
            [dict setObject:array[5] forKey:@"name"];
            [dict setObject:array[6] forKey:@"account"];
            [dict setObject:array[7] forKey:@"isdefault"];
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
