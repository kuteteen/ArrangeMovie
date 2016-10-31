//
//  PFUploadImgViewController.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/28.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "LCActionSheet.h"
#import "TZImagePickerController.h"
#import "EMICamera.h"
#import "UIView+Shadow.h"
#import "EMINavigationController.h"

@interface PFUploadImgViewController : EMIBaseViewController
//拍照
@property (strong,nonatomic) EMICamera *camera;
@end
