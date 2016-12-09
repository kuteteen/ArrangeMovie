//
//  UploadProofWebInterface.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/7.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "UploadProofWebInterface.h"
#import "SCDateTools.h"

@implementation UploadProofWebInterface

-(instancetype)init {
    self = [super init];
    if(self){
        self.url = [NSString stringWithFormat:@"%@%@",self.server,@"moviemanageruploadcert.do"];
    }
    return self;
}

-(NSDictionary *)inboxObject:(id)param {
    NSArray *array = param;
    if(array.count>0){
        int userid = [array[0] intValue];
        NSArray *imgs = array[1];
        int imgtype = [array[2] intValue];//0认证信息
        int usertype = [array[3] intValue];
        
        
        
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
        [dict setObject:@(userid) forKey:@"userid"];
        [dict setObject:imgs forKey:@"imgs"];
        [dict setObject:@(imgtype) forKey:@"imgtype"];
        [dict setObject:@(usertype) forKey:@"usertype"];
        
        [dict setObject:@(0) forKey:@"taskid"];
        [dict setObject:@(0) forKey:@"taskdetailid"];
        [dict setObject:[SCDateTools dateToString:[NSDate date]] forKey:@"tdate"];
        
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
        if ([result objectForKey:@"msg"] != nil) {
           [array addObject:[result valueForKey:@"msg"]];
        }else{
            [array addObject:@"出现异常"];
        }
        
    }
    return array;
}

@end
