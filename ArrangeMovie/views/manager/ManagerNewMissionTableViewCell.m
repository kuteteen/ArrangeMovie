//
//  ManagerNewMissionTableViewCell.m
//  ArrangeMovie
//
//  Created by Emi-iMac on 16/10/25.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ManagerNewMissionTableViewCell.h"
#import "Task.h"

@interface ManagerNewMissionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *filmNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskTimeLabel;

@end

@implementation ManagerNewMissionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"ManagerNewMissionTableViewCell";
    ManagerNewMissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ManagerNewMissionTableViewCell" owner:nil options:nil] firstObject];
    }
    
    cell.directorLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:12.f*autoSizeScaleY];
    cell.taskTimeLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:12.f*autoSizeScaleY];
    
    return cell;
}

-(void)setValue:(id)value {
    Task *task = value;

    self.filmNameLabel.text = task.filmname;
    self.directorLabel.text = [NSString stringWithFormat:@"导演：%@", task.filmdirector];
    self.taskTimeLabel.text = [NSString stringWithFormat:@"任务时间：%@-%@",task.startdate,task.enddate];
    self.taskPointsLabel.text = [NSString stringWithFormat:@"%@积分",task.taskpoints];
    [self.postImgView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeZero shadowOpacity:0.2 shadowRadius:3 image:task.filmimg placeholder:@""];
}

@end
