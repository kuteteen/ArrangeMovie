//
//  MePointRecordTableViewCell.m
//  ArrangeMovie
//
//  Created by Emi-iMac on 16/10/10.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MePointRecordTableViewCell.h"

@implementation MePointRecordTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MePointRecordTableViewCell";
    MePointRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MePointRecordTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}


- (void)setViewValues:(OptDetail *)optdetail{
    self.optdetail = optdetail;
    switch ((NSInteger)self.optdetail.opttype) {
        case 1:
            self.pointTitle.text = @"积分充值";
            self.pointCountLabel.text = [NSString stringWithFormat:@"+%.0f",self.optdetail.integral];
            break;
        case 2:{
            
           NSString *str =  self.optdetail.state == 1 ? @"处理中":self.optdetail.state == 2 ? @"已成功":self.optdetail.state == 3 ?@"未付款":@"已提交";
            
            
            
            self.pointTitle.text = [NSString stringWithFormat:@"积分提现(%@)",str];
            self.pointCountLabel.text = [NSString stringWithFormat:@"-%.0f",self.optdetail.integral];
            break;
        }
        case 3:
            self.pointTitle.text = [NSString stringWithFormat:@"积分消费-支付给%@*****%@", [self.optdetail.payuserdn substringToIndex:3],[self.optdetail.payuserdn substringWithRange:NSMakeRange(self.optdetail.payuserdn.length-3, 3)]];
            self.pointCountLabel.text = [NSString stringWithFormat:@"-%.0f",self.optdetail.integral];
            break;
        case 4:
            self.pointTitle.text = [NSString stringWithFormat:@"积分收益-%@*****%@支付", [self.optdetail.payuserdn substringToIndex:3],[self.optdetail.payuserdn substringWithRange:NSMakeRange(self.optdetail.payuserdn.length-3, 3)]];
            self.pointCountLabel.text = [NSString stringWithFormat:@"+%.0f",self.optdetail.integral];
            break;
        default:
            break;
    }
    self.timeLabel.text = self.optdetail.optdate;
}
@end
