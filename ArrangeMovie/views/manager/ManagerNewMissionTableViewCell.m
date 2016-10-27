//
//  ManagerNewMissionTableViewCell.m
//  ArrangeMovie
//
//  Created by Emi-iMac on 16/10/25.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ManagerNewMissionTableViewCell.h"
#import "EMIShadowImageView.h"

@interface ManagerNewMissionTableViewCell ()
@property (strong, nonatomic) IBOutlet EMIShadowImageView *postImgView;

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
    [self.postImgView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.3 shadowRadius:10 image:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580" placeholder:@""];
}

@end
