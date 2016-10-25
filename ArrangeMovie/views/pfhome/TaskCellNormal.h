//
//  TaskCell.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/18.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCellNormal : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

+ (TaskCellNormal *)cellForCollection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

//title
- (void)setTitleTxt:(NSString *)str;

//内容
- (void)setContentTxt:(NSString *)str;
@end
