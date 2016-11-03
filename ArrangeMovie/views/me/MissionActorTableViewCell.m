//
//  MissionActorTableViewCell.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/18.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MissionActorTableViewCell.h"
#import "Task.h"

@interface MissionActorTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *actorLabel;

@end

@implementation MissionActorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MissionActorTableViewCell";
    MissionActorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MissionActorTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

-(void)setValue:(id)value {
    Task *task = (Task *)value;
    self.actorLabel.text = task.filmstars;
}

@end
