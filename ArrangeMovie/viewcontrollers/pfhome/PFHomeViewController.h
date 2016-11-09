//
//  PFHomeViewController.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "TableWithNoDataView.h"
#import "PFHomeSectionView.h"
#import "PFHomeCell.h"
#import "MeViewController.h"

@interface PFHomeViewController : EMIBaseViewController
@property (strong,nonatomic)   UIView *head;
@property (strong, nonatomic)  UIImageView *topView;
@property (strong, nonatomic)  EMIShadowImageView *headImgView;
@property (strong, nonatomic)  UILabel *nameLab;
@property (strong, nonatomic)  UITableView *tableView;

//空表格的替代视图
@property (strong,nonatomic) TableWithNoDataView *noDataView;
@end
