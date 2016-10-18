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


- (void)operateSection:(BOOL) state{
    if (state) {
        [self.groupImgView setImage:[UIImage imageNamed:@"film_index_xiala_click"]];
    }else{
        [self.groupImgView setImage:[UIImage imageNamed:@"film_index_xiala"]];
    }
}
@end
