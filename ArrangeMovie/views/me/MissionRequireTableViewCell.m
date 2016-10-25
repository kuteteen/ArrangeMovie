//
//  MissionRequireTableViewCell.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/18.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MissionRequireTableViewCell.h"

@implementation MissionRequireTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MissionRequireTableViewCell";
    MissionRequireTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MissionRequireTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

@end
