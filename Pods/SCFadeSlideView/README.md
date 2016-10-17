# SCFadeSlideView

SCFadeSlideView,包含了在垂直方向和水平方向滑动,同时显示左右两侧的部分内容,并在滑动时出现侧方向的缩放动画效果.

<!-- 调节代码框的尺寸-->

### 简单调用

#### 添加view到viewController上
```
CGFloat width = [UIScreen mainScreen].bounds.size.width;
SCFadeSlideView *slideView = [[SCFadeSlideView alloc] initWithFrame:CGRectMake(0, 0, width, 400)];
slideView.delegate = self;
slideView.datasource = self;
slideView.minimumPageAlpha = 0.4;//非当前页的透明比例
slideView.minimumPageScale = 0.85;非当前页的缩放比例

slideView.orginPageCount = 4;//定义初始页数
slideView.orientation = SCFadeSlideViewOrientationHorizontal;
```    

如果使用导航控制器(UINavigationController),而且控制器中不存在UIScrollView或者继承自UIScrollView的UI控件,请使用UIScrollView作为SCFadeSlideView的父容器View.
```
UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
[bottomScrollView addSubview:slideView];
[self.view addSubview:bottomScrollView];
```

#### 协议--SCFadeSlideViewDelegate

```
/**
 *  单个子控件的Size
 *
 *  @param slideView
 *
 *  @return
 */
- (CGSize)sizeForPageInSlideView:(SCFadeSlideView *)slideView;

@optional
/**
 *  滚动到了某一列
 *
 *  @param pageNumber
 *  @param slideView  
 */
- (void)didScrollToPage:(NSInteger)pageNumber inSlideView:(SCFadeSlideView *)slideView;

/**
 *  点击了第几个cell
 *
 *  @param subView 点击的控件
 *  @param subIndex    点击控件的index
 */
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex;

```

#### 数据源--SCFadeSlideViewDataSource
```

/**
 *  返回显示View的个数
 *
 *  @param slideView
 *
 *  @return
 */
- (NSInteger)numberOfPagesInSlideView:(SCFadeSlideView *)slideView;

/**
 *  给某一列设置属性
 *
 *  @param slideView
 *  @param index  
 *
 *  @return
 */
- (UIView *)slideView:(SCFadeSlideView *)slideView cellForPageAtIndex:(NSInteger)index;



```
