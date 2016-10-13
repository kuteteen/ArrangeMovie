//
//  MeBankAddTableViewCell.m
//  ArrangeMovie
//
//  Created by Emi-iMac on 16/10/13.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeBankAddTableViewCell.h"

@implementation MeBankAddTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MeBankAddTableViewCell";
    MeBankAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MeBankAddTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}
@end
