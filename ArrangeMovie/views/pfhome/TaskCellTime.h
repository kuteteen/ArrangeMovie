//
//  TaskCellTime.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/18.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCellTime : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *startLab;
@property (weak, nonatomic) IBOutlet UILabel *endLab;
@property (weak, nonatomic) IBOutlet UIView *startView;
@property (weak, nonatomic) IBOutlet UIView *endView;
@property (strong,nonatomic) UIViewController *parentVC;
+ (TaskCellTime *)cellForCollection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;


//title
- (void)setTitleTxt:(NSString *)str;

//开始时间
- (void)setStartTxt:(NSString *)str;

//结束时间
- (void)setEndTxt:(NSString *)str;
@end
