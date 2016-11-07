//
//  UploadFile.h
//  yunya
//
//  Created by WongSuechang on 16/3/29.
//  Copyright © 2016年 emi365. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UploadFileDelegate <NSObject>

- (void)returnImagePath:(NSString *)imagepath;

@end

@interface UploadFile : NSObject

@property (nonatomic, strong) id<UploadFileDelegate> delegate;

- (void)uploadFileWithURL:(NSURL *)url data:(NSData *)data;
@end
