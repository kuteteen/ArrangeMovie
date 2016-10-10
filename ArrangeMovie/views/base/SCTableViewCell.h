//
//  SCTableViewCell.h
//  yunya
//
//  Created by WongSuechang on 16/3/21.
//  Copyright © 2016年 emi365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setValue:(id)value;

@end
