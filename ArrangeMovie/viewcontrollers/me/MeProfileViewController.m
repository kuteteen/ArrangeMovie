//
//  MeProfileViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/11.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeProfileViewController.h"

@interface MeProfileViewController()

@property (weak, nonatomic) IBOutlet EMIShadowImageView *headImgView;


@end

@implementation MeProfileViewController

-(void)viewDidLoad {
    self.title = @"我的资料";
    [self.headImgView setShadowWithType:EMIShadowPathRound shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.5 shadowRadius:10 image:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580" placeholder:@"miller"];
    
}

@end
