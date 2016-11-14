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
    self.headImgView.frame = CGRectMake(15, 3, 28, 28);
    self.tailImgView.frame = CGRectMake(340, 7, 20, 20);
    self.scrollView.frame = CGRectMake(62, 7, 259, 20);
    
    self.titleLabel.font = [UIFont systemFontOfSize:14.f];
    
    
    
    if ([tailImg isEqualToString:@""]) {
        self.tailImgView.hidden = YES;
        //开头以《 开头，y要小一些
         self.scrollView.frame = CGRectMake(62-5, 7, 259, 20);
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
    
    //由于按比例之后导致图片长宽不等，需要再做调整
    CGRect headRect = self.headImgView.frame;
    headRect.size.height = headRect.size.width;
    self.headImgView.frame = headRect;
    
    [self.headImgView setShadowWithType:EMIShadowPathRound shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeZero shadowOpacity:0.2 shadowRadius:2 image:headImg placeholder:@""];

    self.titleLabel.font = [UIFont systemFontOfSize:14.0*autoSizeScaleY];
        
    
}
@end
