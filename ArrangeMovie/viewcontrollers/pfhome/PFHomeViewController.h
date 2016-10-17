//
//  PFHomeViewController.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "UIBarButtonItem+Extension.h"

@interface PFHomeViewController : EMIBaseViewController
@property (weak, nonatomic) IBOutlet EMIShadowImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
