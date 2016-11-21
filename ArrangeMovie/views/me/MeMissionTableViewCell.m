//
//  MeMissionTableViewCell.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeMissionTableViewCell.h"

@interface MeMissionTableViewCell()

@end

@implementation MeMissionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MeMissionTableViewCell";
    MeMissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MeMissionTableViewCell" owner:nil options:nil] firstObject];
    }
    if(screenWidth<375) {
        cell.directorLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:12];
        cell.taskdateLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:12];
    }else{
        cell.directorLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:13*autoSizeScaleX];
        cell.taskdateLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:13*autoSizeScaleX];
    }
    
    return cell;
}

-(void)setValue:(id)value {
    self.task = (Task *)value;
    [self.postImgView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeZero shadowOpacity:0.26 shadowRadius:5.f image:@"http://cdnq.duitang.com/uploads/item/201506/05/20150605124315_xFQtw.thumb.700_0.jpeg" placeholder:@"miller"];
}

@end
