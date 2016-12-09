//
//  Film.h
//  ArrangeMovie
//  电影
//  Created by 王雪成 on 2016/10/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Film : NSObject

///电影id
@property (nonatomic, assign) int filmid;
///电影名称
@property (nonatomic, strong) NSString *filmname;
///导演
@property (nonatomic, strong) NSString *filmdirector;
///主演
@property (nonatomic, strong) NSString *filmstars;
///关键字搜索
@property (nonatomic, strong) NSString *searchtext;
///页码
@property (nonatomic, strong) NSString *pageindex;
//电影图片地址
@property (nonatomic, strong) NSString *filmimgurl;
@end
