//
//  MeFeedbackViewController.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/14.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeFeedbackViewController.h"
#import "FeedbackWebInterface.h"
#import "SCHttpOperation.h"

@interface MeFeedbackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *contentTV;

@end

@implementation MeFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.contents = [UIColor whiteColor];
    
    //右侧navBtn
    UIBarButtonItem *rightNavBtn = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(rightNavBtnClicked:)];
    [rightNavBtn setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"DroidSans-Bold" size:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [rightNavBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightNavBtn;
}

- (void)rightNavBtnClicked:(UIBarButtonItem *)sender{

    if ([self.contentTV.text isEqualToString:@"说点什么吧！！！！！！"] || [self.contentTV.text isEqualToString:@""]) {
        [self.view makeToast:@"内容不能为空！" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    __unsafe_unretained typeof (self) weakself = self;
    FeedbackWebInterface *feedbackInterface = [[FeedbackWebInterface alloc] init];
    NSDictionary *param = [feedbackInterface inboxObject:@[@(self.user.userid),self.contentTV.text,@(self.user.usertype)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:feedbackInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [feedbackInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            [weakself.view makeToast:@"提交成功" duration:2.0 position:CSToastPositionCenter];
            //返回上一页
            [weakself.navigationController popViewControllerAnimated:YES];
        }else{
            [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
        }
    } WithErrorCodeBlock:^(id errorCode) {
        [weakself.view makeToast:@"请求错误" duration:2.0 position:CSToastPositionCenter];
    } WithFailureBlock:^{
        [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
    }];
    
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
