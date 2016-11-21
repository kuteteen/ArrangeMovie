//
//  PFHomeSectionView.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "PFHomeSectionView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"

@implementation PFHomeSectionView

- (instancetype)initWithType:(NSString *)type imageName:(NSString *)imageName titleStr:(NSString *)titleStr bigNumStr:(NSString *)bigNumStr smallNumStr:(NSString *)smallNumStr{
    self = [[[NSBundle mainBundle] loadNibNamed:@"PFHomeSectionView" owner:nil options:nil] objectAtIndex:0];
    if (self) {
        self.frame = CGRectMake(0, 0, 375, 103);
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf:)];
        
        [self addGestureRecognizer:self.tapGesture];
        
        //默认关闭
        self.isOpen = NO;
        
        
        
        
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.textColor = [UIColor colorWithHexString:@"15151B"];
        self.titleLab.font = [UIFont fontWithName:@"DroidSansFallback" size:17.f];
//        self.titleLab.backgroundColor = [UIColor redColor];

        
        self.titleLab.text = titleStr;
//        self.titleLab.backgroundColor = [UIColor redColor];
        CGSize titleSize = [self.titleLab boundingRectWithSize:CGSizeMake(0, 0.f)];
        [self createScroll:CGSizeMake(titleSize.width, 0)];
        
        self.bigNumLab.text = bigNumStr;
        CGSize bigNumSize = [self.bigNumLab boundingRectWithSize:CGSizeMake(0.f, 0.f)];
        
        //计算出来的bigNumSize包含了间距，可用UIFont的ascender、capHeight得到(中文，数字)的实际大小
        self.bigNumLab.frame = CGRectMake(102, 53.5, bigNumSize.width, self.bigNumLab.font.capHeight+4);
        
        
        self.bigSymbLab.text = @"%";
        CGSize bigSymbSize = [self.bigSymbLab boundingRectWithSize:CGSizeMake(0.f, 0.f)];
        self.bigSymbLab.frame = CGRectMake(102+bigNumSize.width+1, 67.3, bigSymbSize.width, self.bigSymbLab.font.capHeight+3);
        
        self.stateImgView.frame = CGRectMake(102+bigNumSize.width+1+bigSymbSize.width+4, 69, 6, self.bigSymbLab.font.capHeight+2);
        
        
        self.smallNumLab.text = smallNumStr;
        CGSize smallNumSize = [self.smallNumLab boundingRectWithSize:CGSizeMake(0.f, 0.f)];
        self.smallNumLab.frame = CGRectMake(102+bigNumSize.width+1+bigSymbSize.width+2+6+4, 73, smallNumSize.width, self.smallNumLab.font.capHeight+3);
        
        
        self.smallSymbLab.text = @"%";
        CGSize smallSymbSize = [self.smallSymbLab boundingRectWithSize:CGSizeMake(0.f, 0.f)];
        self.smallSymbLab.frame = CGRectMake(102+bigNumSize.width+1+bigSymbSize.width+2+6+2+smallNumSize.width+1, 76, smallSymbSize.width, self.smallSymbLab.font.capHeight+3);
        
        
        if ([type isEqualToString:@"0"]) {
            self.bigNumLab.textColor = [UIColor colorWithHexString:@"ff2f2f"];
            self.bigSymbLab.textColor = [UIColor colorWithHexString:@"ff2f2f"];
            [self.stateImgView setImage:[UIImage imageNamed:@"film_index_rise"]];
            self.smallNumLab.textColor = [UIColor colorWithHexString:@"ff5959"];
            self.smallSymbLab.textColor = [UIColor colorWithHexString:@"ff5959"];
        }
        if ([type isEqualToString:@"1"]) {
            self.bigNumLab.textColor = [UIColor colorWithHexString:@"85c143"];
            self.bigSymbLab.textColor = [UIColor colorWithHexString:@"85c143"];
            [self.stateImgView setImage:[UIImage imageNamed:@"film_index_decline"]];
            self.smallNumLab.textColor = [UIColor colorWithHexString:@"9dcd69"];
            self.smallSymbLab.textColor = [UIColor colorWithHexString:@"9dcd69"];
        }
        
    }
    
    
    //根据比例布局
    [AppDelegate storyBoradAutoLay:self];
    
    [self.headImgView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor colorWithHexString:@"#0a0e16"] shadowOffset:CGSizeMake(0, 1.5) shadowOpacity:0.26 shadowRadius:6 image:imageName placeholder:@""];
    self.titleLab.font = [UIFont fontWithName:@"DroidSansFallback" size:17*autoSizeScaleY];
    
    self.bigNumLab.font = [UIFont fontWithName:@"DroidSansFallback" size:40*autoSizeScaleY];
    
    self.bigSymbLab.font = [UIFont fontWithName:@"DroidSansFallback" size:20*autoSizeScaleY];
    
    self.smallNumLab.font = [UIFont fontWithName:@"DroidSansFallback" size:13*autoSizeScaleY];
    
    self.smallSymbLab.font = [UIFont fontWithName:@"DroidSansFallback" size:9*autoSizeScaleY];
    
    
    
    return self;
}

//创建scrollview
-(void)createScroll:(CGSize) size{
    
    
    //本来 在6s上 直接x应为101，但是中文符号《  占了一些位置，所以剪个7
    self.labScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(101-7, 25, 220, 17)];
    [self addSubview:self.labScrollView];
    //把滚动手势换给父视图
    self.labScrollView.userInteractionEnabled = NO;
    [self addGestureRecognizer:self.labScrollView.panGestureRecognizer];
    self.labScrollView.scrollEnabled = YES;
    self.labScrollView.showsHorizontalScrollIndicator = NO;
    self.labScrollView.showsVerticalScrollIndicator = NO;
    
    [self.labScrollView setContentSize:size];//滑动适配
    
//    [self.labScrollView setContentSize:CGSizeMake(0, 0)];
    self.titleLab.frame = CGRectMake(0, 0, size.width, 17);
    [self.labScrollView addSubview:self.titleLab];
    
    
//    [self changeLableFont:self];
    
    
}

- (void)changeLableFont:(UIView *)addSubView{
    for (UIView *temp in addSubView.subviews) {
        
        if ([temp isKindOfClass:[UILabel class]]) {
            
            
            
                CGFloat fontsize = ((UILabel *)(temp)).font.pointSize;
                ((UILabel *)(temp)).font = [UIFont systemFontOfSize:fontsize*autoSizeScaleY];
            
            
        }
        
        if (temp.subviews.count > 0) {
            [self changeLableFont:temp];
        }
        
        
    }
}


- (void)operateSection:(BOOL) state{
    if (state) {
        [self.groupImgView setImage:[UIImage imageNamed:@"film_index_xiala_click"]];
        self.lineView.hidden = NO;
        //按照6s的尺寸，展开状态，高度应该高个15单位
        self.frame = self.frame = CGRectMake(0, 0, 375*autoSizeScaleX, (103+15)*autoSizeScaleY);
    }else{
        [self.groupImgView setImage:[UIImage imageNamed:@"film_index_xiala"]];
        self.lineView.hidden = YES;
        self.frame = self.frame = CGRectMake(0, 0, 375*autoSizeScaleX, (103)*autoSizeScaleY);
    }
    
    
}


//点击刷新表格
- (void)tapSelf:(UITapGestureRecognizer *)sender{
    self.selectSectionBlock();
}

//设置回调
- (void)setBlock:(tabBlock)block{
    self.selectSectionBlock = block;
}
@end
