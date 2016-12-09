//
//  UploadFile.h
//  yunya
//
//  Created by WongSuechang on 16/3/29.
//  Copyright © 2016年 emi365. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UploadFileDelegate <NSObject>

- (void)returnImagePath:(NSArray *)resultimg;//[0]imgpath[1]imgurl

@end

@interface UploadFile : NSObject

@property (nonatomic, strong) id<UploadFileDelegate> delegate;

- (instancetype)initWithViewController:(UIViewController *)viewController;

- (void)uploadFileWithURL:(NSURL *)url data:(NSData *)data;
@end
