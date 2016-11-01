//
//  TaskCellTime.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/18.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "TaskCellTime.h"
#import "UIView+shadow.h"

@implementation TaskCellTime
+ (TaskCellTime *)cellForCollection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"TaskCellTime";
    TaskCellTime *cell = (TaskCellTime *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.layer.cornerRadius = 2;
    [cell setShadowWithshadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeZero shadowOpacity:0.26 shadowRadius:5];
    
    
    //调整字体,根据屏幕大小
    if (iPhone6SPlus) {
        cell.titleLab.font = [UIFont systemFontOfSize:14.f];
        cell.startLab.font = [UIFont systemFontOfSize:16.f];
        cell.endLab.font = [UIFont systemFontOfSize:16.f];
    }
    if (iPhone6S) {
        cell.titleLab.font = [UIFont systemFontOfSize:13.f];
        cell.startLab.font = [UIFont systemFontOfSize:15.f];
        cell.endLab.font = [UIFont systemFontOfSize:15.f];
    }
    if (iPhone5S) {
        cell.titleLab.font = [UIFont systemFontOfSize:11.f];
        cell.startLab.font = [UIFont systemFontOfSize:12.f];
        cell.endLab.font = [UIFont systemFontOfSize:12.f];
    }
    if (iPhone4S) {
        cell.titleLab.font = [UIFont systemFontOfSize:11.f];
        cell.startLab.font = [UIFont systemFontOfSize:12.f];
        cell.endLab.font = [UIFont systemFontOfSize:12.f];
    }
    
    UITapGestureRecognizer *startges = [[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(alertStart:)];
    UITapGestureRecognizer *endges = [[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(alertEnd:)];
    
    [cell.startView addGestureRecognizer:startges];
    [cell.endView addGestureRecognizer:endges];
    return cell;
}

//title
- (void)setTitleTxt:(NSString *)str{
    self.titleLab.text = str;
}

//开始时间
- (void)setStartTxt:(NSString *)str{
    self.startLab.text = str;
}

//结束时间
- (void)setEndTxt:(NSString *)str{
    self.endLab.text = str;
}

- (void)alertStart:(UITapGestureRecognizer *)sender{
    NSLog(@"%@",@"start");
}
- (void)alertEnd:(UITapGestureRecognizer *)sender{
    NSLog(@"%@",@"end");
}
@end
