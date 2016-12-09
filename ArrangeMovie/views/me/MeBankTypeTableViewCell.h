//
//  MeBankTypeTableViewCell.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/12/1.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTableViewCell.h"

@interface MeBankTypeTableViewCell : SCTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bankhead;
@property (weak, nonatomic) IBOutlet UILabel *banktypeLabel;


- (void)setViewValues:(id)value;
@end
