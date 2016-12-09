//
//  ManagerUploadCertWebInterface.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/12/3.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ManagerUploadCertWebInterface.h"

@implementation ManagerUploadCertWebInterface
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
        int imgtype = [array[1] intValue];//1排片认证
        int taskid = [array[2] intValue];
        int taskdetailid = [array[3] intValue];
        NSString *tdate = array[4];
        NSArray *imgs = array[5];
        int usertype = [array[6] intValue];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
        [dict setObject:@(userid) forKey:@"userid"];
        [dict setObject:@(imgtype) forKey:@"imgtype"];
        [dict setObject:@(taskid) forKey:@"taskid"];
        [dict setObject:@(taskdetailid) forKey:@"taskdetailid"];
        [dict setObject:tdate forKey:@"tdate"];
        [dict setObject:imgs forKey:@"imgs"];
        [dict setObject:@(usertype) forKey:@"usertype"];
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
