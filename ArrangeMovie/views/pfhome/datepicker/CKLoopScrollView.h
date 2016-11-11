//
//  CKLoopScrollView.h
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/11.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CKLoopScrollViewDelegate;

@interface CKLoopScrollView : UIScrollView<UIScrollViewDelegate>
@property (strong, nonatomic) NSMutableArray *views;
@property (assign, nonatomic) int curentIdx;
@property (assign, nonatomic) id<CKLoopScrollViewDelegate> ckloopdelegate;
@property (assign,nonatomic) CGFloat singleTableHeight;
@property (assign,nonatomic) CGFloat singleCellHeight;

- (instancetype)initWithNewFrame:(CGRect)frame views:(NSMutableArray *)views;
@end


@protocol CKLoopScrollViewDelegate <NSObject>

//通知本类的父视图停止滚动
@required- (void)stopScroll:(CKLoopScrollView *)sc;

@end