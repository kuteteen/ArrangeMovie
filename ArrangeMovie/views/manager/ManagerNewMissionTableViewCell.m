//
//  ManagerNewMissionTableViewCell.m
//  ArrangeMovie
//
//  Created by Emi-iMac on 16/10/25.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ManagerNewMissionTableViewCell.h"
#import "EMIShadowImageView.h"
#import "Task.h"

@interface ManagerNewMissionTableViewCell ()
@property (strong, nonatomic) IBOutlet EMIShadowImageView *postImgView;
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
    return cell;
}

-(void)setValue:(id)value {
    Task *task = value;

    // [self.postImgView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.3 shadowRadius:10 image:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580" placeholder:@""];
    self.filmNameLabel.text = task.filmname;
    self.directorLabel.text = [NSString stringWithFormat:@"导演:%@", task.filmdirector];
    self.taskTimeLabel.text = [NSString stringWithFormat:@"任务时间:%@-%@",task.startdate,task.enddate];
    self.taskPointsLabel.text = [NSString stringWithFormat:@"%@积分",task.taskpoints];
    [self.postImgView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeZero shadowOpacity:0.2 shadowRadius:3 image:@"http://cdnq.duitang.com/uploads/item/201506/05/20150605124315_xFQtw.thumb.700_0.jpeg" placeholder:@""];
}

@end
