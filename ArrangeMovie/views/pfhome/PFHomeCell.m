//
//  PFHomeCell.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/18.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "PFHomeCell.h"

@implementation PFHomeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *identifier = @"PFHomeCell";
    PFHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PFHomeCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    return cell;
}


- (void)setValues:(NSString *)headImg tailImg:(NSString *)tailImg title:(NSString *)title{
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:headImg] placeholderImage:[UIImage imageNamed:@"miller"]];
    [self.headImgView setShadowWithshadowColor:[UIColor colorWithHexString:@"#DDDDDE"] shadowOffset:CGSizeZero shadowOpacity:0.26 shadowRadius:10];
    if ([tailImg isEqualToString:@""]) {
        self.tailImgView.hidden = YES;
    }else{
        self.tailImgView.hidden = NO;
        self.tailImgView.image = [UIImage imageNamed:tailImg];
    }
    
    self.scrollView.userInteractionEnabled = NO;
    [self.contentView addGestureRecognizer:self.scrollView.panGestureRecognizer];
    
    self.titleLabel.text = title;
    CGSize titleSize = [self.titleLabel boundingRectWithSize:CGSizeMake(0, 28)];
    
    self.titleWidth.constant = titleSize.width;  //滚动
//    self.titleWidth.constant = self.scrollView.frame.size.width;
}
@end
