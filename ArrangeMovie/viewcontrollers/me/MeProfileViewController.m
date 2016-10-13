//
//  MeProfileViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/11.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeProfileViewController.h"
#import "BEMCheckBox.h"

@interface MeProfileViewController()

@property (weak, nonatomic) IBOutlet UIView *headBackView;
@property (weak, nonatomic) IBOutlet EMIShadowImageView *headImgView;
@property (weak, nonatomic) IBOutlet EMIShadowImageView *editHeadImageView;
@property (weak, nonatomic) IBOutlet UITextField *NickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet BEMCheckBox *maleCheck;
@property (weak, nonatomic) IBOutlet BEMCheckBox *femaleCheck;
@property (weak, nonatomic) IBOutlet UIView *maleView;
@property (weak, nonatomic) IBOutlet UIView *femaleView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveProfileBtn;


@end

@implementation MeProfileViewController

-(void)viewDidLoad {
    self.title = @"我的资料";
    self.headBackView.layer.contents = (__bridge id _Nullable)(([UIImage imageNamed:@"head_bg"].CGImage));
    [self.headImgView setShadowWithType:EMIShadowPathCircle shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.5 shadowRadius:10 image:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1476085888&di=001f4971799df4dd4200a308117f65b9&src=http://img.hb.aicdn.com/761f1bce319b745e663fed957606b4b5d167b9bff70a-nfBc9N_fw580" placeholder:@"miller"];
    [self.editHeadImageView setShadowWithType:EMIShadowPathRound shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.5 shadowRadius:10 image:@"" placeholder:@"miller"];
    
    
    UITapGestureRecognizer *maleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setMale)];
    [_maleView addGestureRecognizer:maleTap];
    UITapGestureRecognizer *femaleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setFemale)];
    [_femaleView addGestureRecognizer:femaleTap];
    
}


-(void)setMale {
    [_maleCheck setOn:YES];
    [_femaleCheck setOn:NO];
    self.user.sex = 1;
}

-(void)setFemale {
    [_maleCheck setOn:NO];
    [_femaleCheck setOn:YES];
    self.user.sex = 0;
}

@end
