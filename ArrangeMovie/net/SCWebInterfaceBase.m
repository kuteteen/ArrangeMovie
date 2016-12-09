//
//  SCWebInterfaceBase.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/10/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "SCWebInterfaceBase.h"

@implementation SCWebInterfaceBase

-(instancetype) init {
    self = [super init];
    if(self){
        self.server = @"http://116.62.42.99/app/";
//        self.server = @"http://192.168.2.199:8080/movie/app/";
    }
    return self;
}

@end
