//
//  ManagerMissionRequireTableViewCell.m
//  ArrangeMovie
//
//  Created by Emi-iMac on 16/10/25.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ManagerMissionRequireTableViewCell.h"
#import "Task.h"
#import "SCDateTools.h"

@interface ManagerMissionRequireTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *taskTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *surplusNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;

@end

@implementation ManagerMissionRequireTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"ManagerMissionRequireTableViewCell";
    ManagerMissionRequireTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ManagerMissionRequireTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

-(void)setValue:(id)value {
    Task *task = (Task *)value;
    self.taskNumLabel.text = [NSString stringWithFormat:@"%@份",task.tasknum];
    self.surplusNumLabel.text = [NSString stringWithFormat:@"剩余%@份",task.surplusnum];
    self.gradeLabel.text = [NSString stringWithFormat:@"%@影院以上",task.gradename];
    self.requireLabel.text = [NSString stringWithFormat:@"%@开始为期%ld天的任务",task.startdate,(long)[SCDateTools daysBetween:[SCDateTools stringToDate:task.startdate] and:[SCDateTools stringToDate:task.enddate]]];
}

@end
