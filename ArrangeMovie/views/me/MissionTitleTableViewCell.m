//
//  MissionTitleTableViewCell.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MissionTitleTableViewCell.h"
#import "EMIShadowImageView.h"
#import "Task.h"

@interface MissionTitleTableViewCell ()
@property (weak, nonatomic) IBOutlet EMIShadowImageView *postImgView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *missionDateLabel;

@end

@implementation MissionTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MissionTitleTableViewCell";
    MissionTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MissionTitleTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

-(void)setValue:(id)value {
    Task *task = (Task *)value;
    [self.postImgView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.3 shadowRadius:3 image:@"http://cdnq.duitang.com/uploads/item/201506/05/20150605124315_xFQtw.thumb.700_0.jpeg" placeholder:@""];
    
    self.movieTitleLabel.text = task.filmname;
    self.directorLabel.text = [NSString stringWithFormat:@"%@分",task.taskpoints];
    self.directorLabel.text = [NSString stringWithFormat:@"导演:%@",task.filmdirector];
    self.missionDateLabel.text = [NSString stringWithFormat:@"任务时间:%@-%@",task.startdate,task.enddate];
}

@end
