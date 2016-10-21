//
//  MissionNoAuthTableViewCell.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/19.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MissionNoAuthTableViewCell.h"

@implementation MissionNoAuthTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MissionNoAuthTableViewCell";
    MissionNoAuthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MissionNoAuthTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

@end
