//
//  SCNavigationController.h
//  EMINest
//
//  Created by WongSuechang on 16-2-22.
//  Copyright (c) 2016年 emi365. All rights reserved.
//

#import "EMINavigationController.h"
#import "UIColor+Hex.h"
//#import "RDVTabBarController.h"

@interface EMINavigationController ()<UINavigationControllerDelegate>
@property (nonatomic, assign) CGRect origionRect;
@property (nonatomic, assign) CGRect desRect;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, assign) BOOL isPush;

@end

@implementation EMINavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 *  当导航控制器的view创建完毕就调用
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
}

/**
 *  当第一次使用这个类的时候调用1次
 */
+ (void)initialize
{
    
    // 设置UINavigationBarTheme的主
    [self setupNavigationBarTheme];
    
    // 设置UIBarButtonItem的主题
    [self setupBarButtonItemTheme];
}

//图片缩放
//+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
//    UIGraphicsBeginImageContext(size);
//    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return scaledImage;
//}

/**
 *  设置UINavigationBarTheme的主题
 */
+ (void)setupNavigationBarTheme
{
    
    
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    // 设置导航栏背景
    
//    UIImage *image = [UIImage imageNamed:@"navigation"];
    
////    UIImage *image = [UIImage imageNamed:@"navigation"];
//    CGSize titleSize = appearance.bounds.size;
//    titleSize.height = titleSize.height+20;
//    NSLog(@"导航栏宽度%f",titleSize.height);
//    image = [self scaleToSize:image size:titleSize];
//    [appearance setBackgroundImage:image
//                    forBarPosition:UIBarPositionAny
//                        barMetrics:UIBarMetricsDefault];
//    [appearance setShadowImage:[UIImage new]];
    
    
//    UIColor *color = [UIColor colorWithPatternImage:image];
    appearance.barTintColor = [UIColor colorWithHexString:@"#162271"];
    
    appearance.barStyle = UIBarStyleBlackTranslucent;
    appearance.translucent = YES;
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20.5f];
    // UIOffsetZero是结构体, 只要包装成NSValue对象, 才能放进字典\数组中
//    textAttrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs];
}

/**
 *  设置UIBarButtonItem的主题
 */
+ (void)setupBarButtonItemTheme
{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    /**设置文字属性**/
    // 设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
//    textAttrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置高亮状态的文字属性
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    // 设置不可用状态(disable)的文字属性
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    /**设置背景**/
    // 技巧: 为了让某个按钮的背景消失, 可以设置一张完全透明的背景图片
    [appearance setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

/**
 *  能拦截所有push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        
        // 设置导航栏按钮
        
        viewController.navigationItem.hidesBackButton = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back" highImageName:@"back" target:self action:@selector(back)];
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_more" highImageName:@"navigationbar_more_highlighted" target:self action:@selector(more)];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    self.isPush = NO;
    
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    NSArray *array = self.viewControllers;
//    UIViewController *viewController = array[0];
//    [[viewController rdv_tabBarController] setTabBarHidden:NO animated:NO];
    return array;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    return [super popToViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}

-(void)pushViewController:(UIViewController *)viewController withImageView:(EMIShadowImageView *)imageView originRect:(CGRect)originRect desRect:(CGRect)desRect{
    self.delegate = self;
    self.origionRect = originRect;
    self.desRect = desRect;
    self.image = imageView.img;
    self.isPush = YES;
    [super pushViewController:viewController animated:YES];
}

#pragma mark UINavigationControllerDelegate
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    self.animation = [[OUNavAnimation alloc] init];
    self.animation.imageRect = self.origionRect;
    self.animation.image = self.image;
    self.animation.isPush = self.isPush;
    self.animation.desRect = self.desRect;
    if (!self.isPush) {
        self.delegate = nil;
    }
    return self.animation;
}

@end
