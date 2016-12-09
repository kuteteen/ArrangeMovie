//
//  MissionRequireTableViewCell.h
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/18.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "SCTableViewCell.h"

@interface MissionRequireTableViewCell : SCTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *requireLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskCountsLabel;
@property (weak, nonatomic) IBOutlet UILabel *cinemaLevelLabel;

@end
