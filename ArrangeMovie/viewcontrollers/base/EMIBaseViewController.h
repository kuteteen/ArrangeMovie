//
//  EMIBaseViewController.h
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/9.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UIColor+Hex.h"
#import "EMIShadowImageView.h"
#import "AppDelegate.h"

@interface EMIBaseViewController : UIViewController

//全局用户信息
@property (strong,nonatomic) User *user;
//全局用户头像
@property (strong,nonatomic) NSString *headimg;
//全局用户手机号
@property (strong,nonatomic) NSString *dn;
//是否是第一次使用的标志
@property (strong,nonatomic) NSString *isFirstUse;
@end
