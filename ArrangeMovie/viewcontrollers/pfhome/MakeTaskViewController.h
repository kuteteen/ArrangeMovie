//
//  MakeTaskViewController.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/18.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "TaskCellNormal.h"
#import "TaskCellTime.h"

@interface MakeTaskViewController : EMIBaseViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn;

@end
