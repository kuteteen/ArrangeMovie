//
//  EMICamera.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/14.
//  Copyright © 2016年 EMI. All rights reserved.
//  该类用于调用系统相机

#import "EMICamera.h"


//定义EMICamera必须定义为全局变量，不然回调不执行
@implementation EMICamera
- (void)takePhoto:(UIViewController *)viewController{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [viewController.view makeToast:@"您的设备不支持照相功能！" duration:2.0 position:CSToastPositionCenter];
    }else{
        self.camera = [[UIImagePickerController alloc] init];
        self.camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.camera.delegate = self;
        self.camera.allowsEditing = YES;
        [viewController presentViewController:self.camera animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.selectPhotoBlock(picker,info);
}

- (void)setBlock:(selectBlock)block{
    self.selectPhotoBlock = block;
}
@end
