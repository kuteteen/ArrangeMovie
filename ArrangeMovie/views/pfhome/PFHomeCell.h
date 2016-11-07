//
//  PFHomeCell.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/18.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+StringFrame.h"
#import "UIView+SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+Shadow.h"


@interface PFHomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UIImageView *tailImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


+ (instancetype)cellWithTableView:(UITableView *)tableView;


- (void)setValues:(NSString *)headImg tailImg:(NSString *)tailImg title:(NSString *)title;
@end
