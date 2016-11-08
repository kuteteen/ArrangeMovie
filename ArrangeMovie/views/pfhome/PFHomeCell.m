//
//  PFHomeCell.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/18.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "PFHomeCell.h"
#import "AppDelegate.h"

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
    
    
    //每次走这个方法之前，把所有控件的初始位置改为6的尺寸
    self.headImgView.frame = CGRectMake(17, 18, 28, 28);
    self.tailImgView.frame = CGRectMake(338, 22, 20, 20);
    self.scrollView.frame = CGRectMake(62, 22, 252, 20);
    
    self.titleLabel.font = [UIFont systemFontOfSize:14.f];
    
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:headImg] placeholderImage:[UIImage imageNamed:@"miller"]];
    [self.headImgView setShadowWithshadowColor:[UIColor colorWithHexString:@"#DDDDDE"] shadowOffset:CGSizeZero shadowOpacity:0.26 shadowRadius:5];
    if ([tailImg isEqualToString:@""]) {
        self.tailImgView.hidden = YES;
    }else{
        self.tailImgView.hidden = NO;
        self.tailImgView.image = [UIImage imageNamed:tailImg];
    }
    
    self.scrollView.userInteractionEnabled = NO;
    [self.contentView addGestureRecognizer:self.scrollView.panGestureRecognizer];
    
    self.titleLabel.text = title;
    CGSize titleSize = [self.titleLabel boundingRectWithSize:CGSizeMake(0, 0)];
    self.scrollView.contentSize = CGSizeMake(titleSize.width+20, 0);
    self.titleLabel.frame = CGRectMake(0, 0, titleSize.width+20, 20);

    //根据比例布局
    [AppDelegate storyBoradAutoLay:self];
    
    
    //布局完了，5S  宽度已经缩小了，把字体适当变小
    if (iPhone5S) {
        self.titleLabel.font = [UIFont systemFontOfSize:12.f];
        
    }
}
@end
