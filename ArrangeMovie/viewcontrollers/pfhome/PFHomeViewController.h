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
@property (strong, nonatomic)  UIImageView *headImgView;//头像
@property (strong, nonatomic)  UILabel *nameLab;//姓名

@property (strong,nonatomic) UILabel *pointFirstLab;//积分首数字
@property (strong,nonatomic) UILabel *pointOtherLab;//积分其他数字


@property (strong,nonatomic) UILabel *releaseCountLab;//已领取个数首字母
@property (strong,nonatomic) UILabel *releaseAllCountLab;//已领取个数其他字母+/+已领取总个数

@property (strong,nonatomic) UILabel *shCountLab;//待审核个数首字母
@property (strong,nonatomic) UILabel *shAllCountLab;//待审核个数其他字母+/+待审核总个数

@property (strong,nonatomic) UILabel *payCountLab;//已支付个数首字母
@property (strong,nonatomic) UILabel *payAllCountLab;//已支付个数其他字母+/已支付总个数

@property (strong, nonatomic)  UITableView *tableView;

//空表格的替代视图
@property (strong,nonatomic) TableWithNoDataView *noDataView;
@end
