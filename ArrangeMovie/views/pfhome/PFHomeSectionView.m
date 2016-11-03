//
//  PFHomeSectionView.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "PFHomeSectionView.h"

@implementation PFHomeSectionView

- (instancetype)initWithType:(NSString *)type imageName:(NSString *)imageName titleStr:(NSString *)titleStr bigNumStr:(NSString *)bigNumStr smallNumStr:(NSString *)smallNumStr{
    self = [[[NSBundle mainBundle] loadNibNamed:@"PFHomeSectionView" owner:nil options:nil] objectAtIndex:0];
    if (self) {
        self.frame = CGRectMake(0, 0, screenWidth, 101);
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf:)];
        
        [self addGestureRecognizer:self.tapGesture];
        
        //默认关闭
        self.isOpen = NO;
        
        [self.headImgView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor colorWithHexString:@"#DDDDDE"] shadowOffset:CGSizeZero shadowOpacity:0.26 shadowRadius:10 image:imageName placeholder:@"miller"];
        
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.textColor = [UIColor colorWithHexString:@"15151B"];
        self.titleLab.font = [UIFont systemFontOfSize:17.f];
        self.titleLab.text = titleStr;
        CGSize titleSize = [self.titleLab boundingRectWithSize:CGSizeMake(0, 25)];
        [self createScroll:CGSizeMake(titleSize.width, 0)];
        
        self.bigNumLab.text = bigNumStr;
        CGSize bigNumSize = [self.bigNumLab boundingRectWithSize:CGSizeMake(screenWidth, 33)];
//        self.bigNumH.constant = bigNumSize.height;
        self.bigNumW.constant = bigNumSize.width+1;
        
        
        self.bigSymbLab.text = @"%";
        CGSize bigSymbSize = [self.bigSymbLab boundingRectWithSize:CGSizeMake(screenWidth, 16)];
//        self.bigSymbH.constant = bigSymbSize.height;
        self.bigSymbW.constant = bigSymbSize.width;
        
        
        self.smallNumLab.text = smallNumStr;
        CGSize smallNumSize = [self.smallNumLab boundingRectWithSize:CGSizeMake(screenWidth, 9)];
//        self.smallNumH.constant = smallNumSize.height;
        self.smallNumW.constant = smallNumSize.width+1;
        
        
        self.smallSymbLab.text = @"%";
        CGSize smallSymbSize = [self.smallSymbLab boundingRectWithSize:CGSizeMake(screenWidth, 7)];
//        self.smallSymbH.constant = smallSymbSize.height;
        self.smallSymbW.constant = smallSymbSize.width;
        
        
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
    return self;
}

//创建scrollview
-(void)createScroll:(CGSize) size{
    
    
    
    self.labScrollView = [[UIScrollView alloc] init];
    [self addSubview:self.labScrollView];
    //把滚动手势换给父视图
    self.labScrollView.userInteractionEnabled = NO;
    [self addGestureRecognizer:self.labScrollView.panGestureRecognizer];
    self.labScrollView.scrollEnabled = YES;
    self.labScrollView.showsHorizontalScrollIndicator = NO;
    self.labScrollView.showsVerticalScrollIndicator = NO;
    self.labScrollView.sd_layout.topSpaceToView(self,25).leftSpaceToView(self.headImgView,20).rightSpaceToView(self,50).heightIs(25);
    
//    [self.labScrollView setContentSize:size];//滑动适配
    
    [self.labScrollView setContentSize:CGSizeMake(0, 0)];
    
    [self.labScrollView addSubview:self.titleLab];
    self.titleLab.sd_layout.leftSpaceToView(self.labScrollView,0).topSpaceToView(self.labScrollView,0).bottomSpaceToView(self.labScrollView,0);
    
//    self.titleLab.sd_layout.widthIs(size.width);//滑动适配
    
    self.titleLab.sd_layout.rightSpaceToView(self.labScrollView,0);
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
