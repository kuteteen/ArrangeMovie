//
//  TaskCell.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/18.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "TaskCellNormal.h"
#import "UIView+Shadow.h"

@implementation TaskCellNormal

+ (TaskCellNormal *)cellForCollection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"TaskCellNormal";
    
    
    TaskCellNormal *cell = (TaskCellNormal *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 2;
    [cell setShadowWithshadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.3 shadowRadius:5];
    
    
    //调整字体,根据屏幕大小
    if (iPhone6SPlus) {
        cell.titleLab.font = [UIFont systemFontOfSize:14.f];
        cell.contentLab.font = [UIFont systemFontOfSize:16.f];
    }
    if (iPhone6S) {
        cell.titleLab.font = [UIFont systemFontOfSize:13.f];
        cell.contentLab.font = [UIFont systemFontOfSize:15.f];
    }
    if (iPhone5S) {
        cell.titleLab.font = [UIFont systemFontOfSize:11.f];
        cell.contentLab.font = [UIFont systemFontOfSize:12.f];
    }
    if (iPhone4S) {
        cell.titleLab.font = [UIFont systemFontOfSize:11.f];
        cell.contentLab.font = [UIFont systemFontOfSize:12.f];
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
    
}
//cell宽度 （screenWidth-34-12.5）/2  高度 (screenHeight-30-15*3)/3
@end
