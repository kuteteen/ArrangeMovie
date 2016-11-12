//
//  PFHomeSectionView.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "PFHomeSectionView.h"
#import "AppDelegate.h"

@implementation PFHomeSectionView

- (instancetype)initWithType:(NSString *)type imageName:(NSString *)imageName titleStr:(NSString *)titleStr bigNumStr:(NSString *)bigNumStr smallNumStr:(NSString *)smallNumStr{
    self = [[[NSBundle mainBundle] loadNibNamed:@"PFHomeSectionView" owner:nil options:nil] objectAtIndex:0];
    if (self) {
        self.frame = CGRectMake(0, 0, 375, 101);
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf:)];
        
        [self addGestureRecognizer:self.tapGesture];
        
        //默认关闭
        self.isOpen = NO;
        
        [self.headImgView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor colorWithHexString:@"#DDDDDE"] shadowOffset:CGSizeZero shadowOpacity:0.5 shadowRadius:3 image:imageName placeholder:@"miller"];
        
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.textColor = [UIColor colorWithHexString:@"15151B"];
        self.titleLab.font = [UIFont systemFontOfSize:17.f];
        

        
        self.titleLab.text = titleStr;
//        self.titleLab.backgroundColor = [UIColor redColor];
        CGSize titleSize = [self.titleLab boundingRectWithSize:CGSizeMake(0, 0.f)];
        [self createScroll:CGSizeMake(titleSize.width, 0)];
        
        self.bigNumLab.text = bigNumStr;
        CGSize bigNumSize = [self.bigNumLab boundingRectWithSize:CGSizeMake(0.f, 0.f)];
        
        //计算出来的bigNumSize包含了间距，可用UIFont的ascender、capHeight得到(中文，数字)的实际大小
        self.bigNumLab.frame = CGRectMake(115, 101-15-self.bigNumLab.font.capHeight-2, bigNumSize.width, self.bigNumLab.font.capHeight+2);
        
        
        self.bigSymbLab.text = @"%";
        CGSize bigSymbSize = [self.bigSymbLab boundingRectWithSize:CGSizeMake(0.f, 0.f)];
        self.bigSymbLab.frame = CGRectMake(115+bigNumSize.width+1, 101-15-self.bigSymbLab.font.capHeight-2, bigSymbSize.width, self.bigSymbLab.font.capHeight+2);
        
        self.stateImgView.frame = CGRectMake(115+bigNumSize.width+1+bigSymbSize.width+2, 101-15-self.bigSymbLab.font.capHeight-2, 6, self.bigSymbLab.font.capHeight+2);
        
        
        self.smallNumLab.text = smallNumStr;
        CGSize smallNumSize = [self.smallNumLab boundingRectWithSize:CGSizeMake(0.f, 0.f)];
        self.smallNumLab.frame = CGRectMake(115+bigNumSize.width+1+bigSymbSize.width+2+6+2, 101-15-self.smallNumLab.font.capHeight-2, smallNumSize.width, self.smallNumLab.font.capHeight+2);
        
        
        self.smallSymbLab.text = @"%";
        CGSize smallSymbSize = [self.smallSymbLab boundingRectWithSize:CGSizeMake(0.f, 0.f)];
        self.smallSymbLab.frame = CGRectMake(115+bigNumSize.width+1+bigSymbSize.width+2+6+2+smallNumSize.width+1, 101-15-self.smallSymbLab.font.capHeight-2, smallSymbSize.width, self.smallSymbLab.font.capHeight+2);
        
        
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
    
    
        self.titleLab.font = [UIFont systemFontOfSize:17*autoSizeScaleY];
    
        self.bigNumLab.font = [UIFont systemFontOfSize:40*autoSizeScaleY];
    
        self.bigSymbLab.font = [UIFont systemFontOfSize:20*autoSizeScaleY];
    
        self.smallNumLab.font = [UIFont systemFontOfSize:13*autoSizeScaleY];
    
        self.smallSymbLab.font = [UIFont systemFontOfSize:9*autoSizeScaleY];
    
    
    
    return self;
}

//创建scrollview
-(void)createScroll:(CGSize) size{
    
    
    
    self.labScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(105, 25, 220, 17)];
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
            
            
            if (iPhone4S || iPhone5S) {
                CGFloat fontsize = ((UILabel *)(temp)).font.pointSize;
                ((UILabel *)(temp)).font = [UIFont systemFontOfSize:fontsize-2.f];
            }
            
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
    }else{
        [self.groupImgView setImage:[UIImage imageNamed:@"film_index_xiala"]];
        self.lineView.hidden = YES;
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
