//
//  CKLoopScrollView.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/11/11.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "CKLoopScrollView.h"

@implementation CKLoopScrollView

- (instancetype)initWithNewFrame:(CGRect)frame views:(NSMutableArray *)views{
    self = [super initWithFrame:frame];
    if (self) {
        self.views = views;
        UIView *view = views[0];
        self.singleTableHeight = view.frame.size.height;
        self.singleCellHeight = self.singleTableHeight/view.tag;
        self.contentSize = CGSizeMake(self.frame.size.width, self.singleTableHeight*views.count);
        self.delegate = self;
        self.bounces = NO;
        self.curentIdx = 0;
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = NO;
        self.decelerationRate = 0;
        self.showsVerticalScrollIndicator = NO;
        
    }
    
    return self;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView;{
    [self moveSubViews:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self.ckloopdelegate stopScroll:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self moveSubViews:scrollView];
    [self.ckloopdelegate stopScroll:self];
}

//处理滚动事件
- (void)moveSubViews:(UIScrollView *)sc{
    
}
//调整多个view之间的顺序
- (void)layoutViews:(int)idx{
    
}
//调整前一个view
- (void)layoutBefore:(int)idx{
    
}
//调整后一个view
- (void)layoutNext:(int)idx{
    
}
//调整当前view
- (void)layoutCurrent:(int)idx{
    
}
@end
