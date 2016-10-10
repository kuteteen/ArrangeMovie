//
//  MeViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/9.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeViewController.h"
#import "UIImageView+EMIShadow.h"

@interface MeViewController ()
@property (strong, nonatomic) UIImageView *headImgView;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 120, 120, 120)];
    
    self.headImgView.image = [UIImage imageNamed:@"miller"];
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 60;
    self.headImgView = [self.headImgView setShadowWithType:EMIShadowPathRound shadowColor:[UIColor blackColor] shadowOffset:CGSizeMake(0, 0) shadowOpacity:0.5 shadowRadius:10];
    NSLog(@"图片位置\nx:%f,\ny:%f,\nwidht:%f,\nheight:%f",self.headImgView.frame.origin.x,self.headImgView.frame.origin.y,self.headImgView.frame.size.width,self.headImgView.frame.size.height);
    [self.view addSubview:self.headImgView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
