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
@property (weak, nonatomic) IBOutlet EMIShadowImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//空表格的替代视图
@property (strong,nonatomic) TableWithNoDataView *noDataView;
@end
