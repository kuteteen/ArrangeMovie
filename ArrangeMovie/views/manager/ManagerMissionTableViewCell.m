//
//  ManagerMissionTableViewCell.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/10/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ManagerMissionTableViewCell.h"
#import "EMIShadowImageView.h"

@interface ManagerMissionTableViewCell ()
@property (weak, nonatomic) IBOutlet EMIShadowImageView *headImgView;
@property (weak, nonatomic) IBOutlet EMIShadowImageView *postImgView;

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
    [self.headImgView setShadowWithType:EMIShadowPathRound shadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.03 shadowRadius:1.f image:value placeholder:@""];
    [self.postImgView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.3 shadowRadius:5.f image:value placeholder:@""];
}

@end
