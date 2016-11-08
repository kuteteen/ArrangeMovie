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

@property (strong,nonatomic) User *user;


@property (strong,nonatomic) AppDelegate *myDelegate;
@end
