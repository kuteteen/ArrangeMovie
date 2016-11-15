//
//  ManagerMissionTableViewCell.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/10/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ManagerMissionTableViewCell.h"
#import "Task.h"
#import "ValidateMobile.h"

@interface ManagerMissionTableViewCell ()
@property (weak, nonatomic) IBOutlet EMIShadowImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *taskPublishPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *filmnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDateLabel;

@end

@implementation ManagerMissionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"ManagerMissionTableViewCell";
    ManagerMissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ManagerMissionTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

-(void)setValue:(id)value {
    self.task = (Task *)value;
    
    [self.headImgView setShadowWithType:EMIShadowPathRound shadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.03 shadowRadius:1.f image:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580" placeholder:@""];
    [self.postImgView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.3 shadowRadius:5.f image:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580" placeholder:@""];
    
    self.taskPublishPhoneLabel.text = [ValidateMobile hidePhone:self.task.dn];
    self.filmnameLabel.text = self.task.filmname;
    self.directorLabel.text = [NSString stringWithFormat:@"导演：%@",self.task.filmdirector];
    self.taskPointsLabel.text = [NSString stringWithFormat:@"%@积分",self.task.taskpoints];
    self.taskDateLabel.text = [NSString stringWithFormat:@"任务时间：%@-%@",self.task.startdate,self.task.enddate];
}

@end
