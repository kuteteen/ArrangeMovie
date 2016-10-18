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
        [self.headImgView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor colorWithHexString:@"#DDDDDE"] shadowOffset:CGSizeZero shadowOpacity:0.3 shadowRadius:10 image:imageName placeholder:@""];
        self.titleLab.text = titleStr;
        
        self.bigNumLab.text = bigNumStr;
        CGSize bigNumSize = [self.bigNumLab boundingRectWithSize:CGSizeMake(screenWidth, 33)];
        self.bigNumLab.sd_layout.leftSpaceToView(self.headImgView,25).widthIs(bigNumSize.width).heightIs(33).bottomSpaceToView(self,15);
        self.bigSymbLab.text = @"%";
        CGSize bigSymbSize = [self.bigSymbLab boundingRectWithSize:CGSizeMake(screenWidth, 21)];
        self.bigSymbLab.sd_layout.leftSpaceToView(self.bigNumLab,2).widthIs(bigSymbSize.width).heightIs(21).bottomSpaceToView(self,15);
        self.stateImgView.sd_layout.leftSpaceToView(self.bigSymbLab,2).widthIs(6).heightIs(21).bottomSpaceToView(self,15);
        CGSize smallNumSize = [self.smallNumLab boundingRectWithSize:CGSizeMake(screenWidth, 14)];
        self.smallNumLab.sd_layout.leftSpaceToView(self.stateImgView,2).widthIs(smallNumSize.width).heightIs(14).bottomSpaceToView(self,15);
        self.smallSymbLab.text = @"%";
        CGSize smallSymbSize = [self.smallSymbLab boundingRectWithSize:CGSizeMake(screenWidth, 9)];
        self.smallSymbLab.sd_layout.leftSpaceToView(self.smallNumLab,2).widthIs(smallSymbSize.width).heightIs(11).bottomSpaceToView(self,15);
        
        
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


- (void)operateSection:(BOOL) state{
    if (state) {
        [self.groupImgView setImage:[UIImage imageNamed:@"film_index_xiala_click"]];
    }else{
        [self.groupImgView setImage:[UIImage imageNamed:@"film_index_xiala"]];
    }
}
@end
