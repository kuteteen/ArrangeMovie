//
//  ChooseFilmCell.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/19.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseFilmCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *centerLab;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;


+ (instancetype)cellWithTableView:(UITableView *)tableView;


- (void)setValues:(NSString *)headImg titleStr:(NSString *)titleStr centerStr:(NSString *)centerStr bottomStr:(NSString *)bottomStr;
@end
