//
//  TaskCell.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/18.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "TaskCellNormal.h"
#import "UIView+Shadow.h"
#import "AppDelegate.h"

@implementation TaskCellNormal

+ (TaskCellNormal *)cellForCollection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"TaskCellNormal";
    
    
    TaskCellNormal *cell = (TaskCellNormal *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 2;
    [cell setShadowWithshadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeZero shadowOpacity:0.26 shadowRadius:5];
    
    
    //调整字体,根据屏幕大小
    if (iPhone5S) {
        cell.titleLab.font = [UIFont systemFontOfSize:11.f];
        cell.contentLab.font = [UIFont systemFontOfSize:12.f];
    }
    [AppDelegate storyBoradAutoLay:cell];
    
    if (iPhone4S) {
        cell.titleLab.font = [UIFont systemFontOfSize:10.f];
        cell.contentLab.font = [UIFont systemFontOfSize:11.f];
    }
    return cell;
}



//title
- (void)setTitleTxt:(NSString *)str{
    self.titleLab.text = str;
    
}

//内容
- (void)setContentTxt:(NSString *)str{
    self.contentLab.text = str;
     AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10*myDelegate.autoSizeScaleY];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    self.contentLab.attributedText = attributedString;
    
}
//cell宽度 （screenWidth-34-12.5）/2  高度 (screenHeight-30-15*3)/3
@end
