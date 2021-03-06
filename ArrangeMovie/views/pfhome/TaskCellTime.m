//
//  TaskCellTime.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/18.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "TaskCellTime.h"
#import "UIView+shadow.h"
#import "AppDelegate.h"
#import "AMAlertView.h"
#import "CKAlertViewController.h"
@implementation TaskCellTime
+ (TaskCellTime *)cellForCollection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"TaskCellTime";
    TaskCellTime *cell = (TaskCellTime *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.layer.cornerRadius = 2;
    [cell setShadowWithshadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeZero shadowOpacity:0.26 shadowRadius:5];
    
    
    //调整字体,根据屏幕大小
    if (iPhone5S) {
        cell.titleLab.font = [UIFont systemFontOfSize:11.f];
        cell.startLab.font = [UIFont systemFontOfSize:12.f];
        cell.endLab.font = [UIFont systemFontOfSize:12.f];
    }
    
    UITapGestureRecognizer *startges = [[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(alertStart:)];
    UITapGestureRecognizer *endges = [[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(alertEnd:)];
    
    [cell.startView addGestureRecognizer:startges];
    [cell.endView addGestureRecognizer:endges];
    
    [AppDelegate storyBoradAutoLay:cell];
    
    if (iPhone4S) {
        cell.titleLab.font = [UIFont systemFontOfSize:10.f];
        cell.startLab.font = [UIFont systemFontOfSize:11.f];
        cell.endLab.font = [UIFont systemFontOfSize:11.f];
    }
    
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

//0为开始时间，1为结束时间
- (void)createDatePicker:(NSString *)type{
    AMAlertView *amalertview = [[AMAlertView alloc] initWithconsFrame:CGRectMake(43.5*autoSizeScaleX, (667/2-173)*autoSizeScaleY, 288*autoSizeScaleX, 346*autoSizeScaleY)];
    if ([type isEqualToString:@"0"]) {
        [amalertview setTitle:@"任务开始时间"];
    }else{
        [amalertview setTitle:@"任务结束时间"];
    }

    
    CKAlertViewController *ckAlertVC = [[CKAlertViewController alloc] initWithAlertView:amalertview];
    
    [self.parentVC presentViewController:ckAlertVC animated:NO completion:nil];
}
@end
