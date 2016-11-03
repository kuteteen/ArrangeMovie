//
//  TaskDetail.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/31.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskDetail : NSObject
//排片日期
@property (nonatomic,copy) NSString *piecedate;
//图片列表
@property (nonatomic,strong) NSArray<NSString *> *imgs;
@end
