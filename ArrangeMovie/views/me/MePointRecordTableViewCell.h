//
//  MePointRecordTableViewCell.h
//  ArrangeMovie
//
//  Created by Emi-iMac on 16/10/10.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "SCTableViewCell.h"
#import "OptDetail.h"

@interface MePointRecordTableViewCell : SCTableViewCell

@property (strong,nonatomic) OptDetail *optdetail;

@property (weak, nonatomic) IBOutlet UILabel *pointTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointCountLabel;


- (void)setViewValues:(OptDetail *)optdetail;
@end
