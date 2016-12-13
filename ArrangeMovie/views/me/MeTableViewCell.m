//
//  MeTableViewCell.m
//  ArrangeMovie
//
//  Created by Emi-iMac on 16/10/10.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeTableViewCell.h"

@implementation MeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MeTableViewCell";
    MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MeTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setValue:(id)value {
    self.meTitleLabel.text = value;
    NSString *title = value;
    
    NSString *imgname;
    if([title isEqualToString:@"我的资料"]){
        imgname = @"Icon---Username_clicked";
    }else if([title isEqualToString:@"任务历史"]){
        imgname = @"my_task";
    }else if([title isEqualToString:@"我的积分"]){
        imgname = @"my_integral";
    }else if([title isEqualToString:@"我的银行卡"]){
        imgname = @"icon_kahao_click";
    }else if([title isEqualToString:@"修改密码"]){
        imgname = @"Icon---Password_click";
    }else if([title isEqualToString:@"资料审核"]){
        imgname = @"my_review";
    }else if([title isEqualToString:@"设置"]){
        imgname = @"my_set_up";
    }else if([title isEqualToString:@"认证院线经理"]){
        imgname = @"my_review";
    }
    self.meImgView.image = [UIImage imageNamed:imgname];
}


@end
