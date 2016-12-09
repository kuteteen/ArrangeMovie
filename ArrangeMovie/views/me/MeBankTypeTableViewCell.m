//
//  MeBankTypeTableViewCell.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/12/1.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeBankTypeTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation MeBankTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MeBankTypeTableViewCell";
    MeBankTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MeBankTypeTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setViewValues:(id)value{
    [self.bankhead sd_setImageWithURL:[NSURL URLWithString:[value objectForKey:@"img"]] placeholderImage:defaultheadimage];
    self.banktypeLabel.text = [value objectForKey:@"name"];
}
@end
