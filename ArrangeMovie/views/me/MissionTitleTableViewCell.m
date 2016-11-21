//
//  MissionTitleTableViewCell.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MissionTitleTableViewCell.h"
#import "EMIShadowImageView.h"

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
    [self.postImgView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeMake(0, 1.5) shadowOpacity:0.26 shadowRadius:6 image:@"http://cdnq.duitang.com/uploads/item/201506/05/20150605124315_xFQtw.thumb.700_0.jpeg" placeholder:@""];
    if(screenWidth<375){
        self.directorLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:12.f];
        self.missionDateLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:12.f];
    }
}

@end
