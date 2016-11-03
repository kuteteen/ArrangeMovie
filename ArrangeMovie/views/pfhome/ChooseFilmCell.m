//
//  ChooseFilmCell.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/19.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ChooseFilmCell.h"
#import "UIView+Shadow.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ChooseFilmCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *identifier = @"ChooseFilmCell";
    ChooseFilmCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChooseFilmCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.headImgView.layer.cornerRadius = 2;
    [cell.headImgView setShadowWithshadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeZero shadowOpacity:0.26 shadowRadius:5];
    return cell;
}


- (void)setValues:(NSString *)headImg titleStr:(NSString *)titleStr centerStr:(NSString *)centerStr bottomStr:(NSString *)bottomStr{
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:headImg] placeholderImage:[UIImage imageNamed:@"miller"]];
    
    self.titleLab.text = titleStr;
    self.centerLab.text = centerStr;
    self.bottomLab.text = bottomStr;
}

@end
