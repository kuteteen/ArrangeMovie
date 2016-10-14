//
//  EMICamera.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/14.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Toast.h"

typedef  void (^selectBlock)(UIImagePickerController* picker,NSDictionary<NSString *,id> *info);

@interface EMICamera : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
//UIImagePickerController
@property(nonatomic,strong)UIImagePickerController *camera;
//回调
@property(strong,nonatomic)selectBlock selectPhotoBlock;
//拍照
- (void)takePhoto:(UIViewController *)viewController;

- (void)setBlock:(selectBlock)block;
@end
