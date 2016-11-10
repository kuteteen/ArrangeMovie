//
//  ManagerNewMissionTableViewCell.h
//  ArrangeMovie
//
//  Created by Emi-iMac on 16/10/25.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "SCTableViewCell.h"
#import "EMIShadowImageView.h"

@interface ManagerNewMissionTableViewCell : SCTableViewCell

@property (strong, nonatomic) IBOutlet EMIShadowImageView *postImgView;
@property (nonatomic, assign) CGRect imgRect;

@end
