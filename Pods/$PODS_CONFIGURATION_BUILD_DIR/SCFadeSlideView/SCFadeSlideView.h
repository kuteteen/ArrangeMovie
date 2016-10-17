//
//  SCFadeSlideView.h
//  SCFadeSlideView
//
//  Created by WongSuechang on 2016/9/30.
//  Copyright © 2016年 suechang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCFadeSlideViewDelegate;
@protocol SCFadeSlideViewDataSource;


typedef enum{
    SCFadeSlideViewOrientationHorizontal = 0,
    SCFadeSlideViewOrientationVertical
}SCFadeSlideViewOrientation;

@interface SCFadeSlideView : UIView<UIScrollViewDelegate>

@property (nonatomic,assign) SCFadeSlideViewOrientation orientation;//默认为横向
@property (nonatomic, strong) UIScrollView *scrollView;//承载内容的scrollview

@property (nonatomic,assign) BOOL needsReload;
@property (nonatomic,assign) CGSize pageSize; //一页的尺寸
@property (nonatomic,assign) NSInteger pageCount;  //总页数

@property (nonatomic,strong) NSMutableArray *cells;
@property (nonatomic,assign) NSRange visibleRange;
@property (nonatomic,strong) NSMutableArray *reusableCells;//如果以后需要支持reuseIdentifier，这边就得使用字典类型了

@property (nonatomic,assign)   id <SCFadeSlideViewDelegate> delegate;
@property (nonatomic,assign)   id <SCFadeSlideViewDataSource> datasource;

/**
 *  非当前页的透明比例
 */
@property (nonatomic, assign) CGFloat minimumPageAlpha;

/**
 *  非当前页的缩放比例
 */
@property (nonatomic, assign) CGFloat minimumPageScale;

/**
 *  当前是第几页
 */
@property (nonatomic, assign, readonly) NSInteger currentPageIndex;

/**
 *  原始页数
 */
@property (nonatomic, assign) NSInteger orginPageCount;

/**
 *  刷新视图
 */
- (void)reloadData;

/**
 *  获取可重复使用的Cell
 *
 *  @return <#return value description#>
 */
- (UIView *)dequeueReusableCell;


/**
 *  滚动到指定的页面
 *
 *  @param pageNumber <#pageNumber description#>
 */
- (void)scrollToPage:(NSUInteger)pageNumber;

@end


@protocol SCFadeSlideViewDelegate <NSObject>

/**
 *  单个子控件的Size
 *
 *  @param slideView <#flowView description#>
 *
 *  @return <#return value description#>
 */
- (CGSize)sizeForPageInSlideView:(SCFadeSlideView *)slideView;

@optional
/**
 *  滚动到了某一列
 *
 *  @param pageNumber <#pageNumber description#>
 *  @param slideView   <#flowView description#>
 */
- (void)didScrollToPage:(NSInteger)pageNumber inSlideView:(SCFadeSlideView *)slideView;

/**
 *  点击了第几个cell
 *
 *  @param subView 点击的控件
 *  @param subIndex    点击控件的index
 */
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex;

@end


@protocol SCFadeSlideViewDataSource <NSObject>

/**
 *  返回显示View的个数
 *
 *  @param slideView <#flowView description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfPagesInSlideView:(SCFadeSlideView *)slideView;

/**
 *  给某一列设置属性
 *
 *  @param slideView <#flowView description#>
 *  @param index    <#index description#>
 *
 *  @return <#return value description#>
 */
- (UIView *)slideView:(SCFadeSlideView *)slideView cellForPageAtIndex:(NSInteger)index;

@end

