//
//  ManagerMissionTableViewCell.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/10/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ManagerMissionTableViewCell.h"
#import "Task.h"
#import "ValidateMobile.h"
#import "AMAlertView.h"
#import "CKAlertViewController.h"
#import "MeDeleteTaskWebInterface.h"
#import "SCHttpOperation.h"
#import "MJRefreshGifHeader.h"
#import "ManagerDeleteTaskWebInterface.h"

@interface ManagerMissionTableViewCell ()
{
    CKAlertViewController *ckAlertVC;
}
@property (weak, nonatomic) IBOutlet EMIShadowImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *taskPublishPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *filmnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDateLabel;

@end

@implementation ManagerMissionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"ManagerMissionTableViewCell";
    ManagerMissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ManagerMissionTableViewCell" owner:nil options:nil] firstObject];
        
    cell.directorLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:12.f*autoSizeScaleY];
    cell.taskDateLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:12.f*autoSizeScaleY];
    }
    return cell;
}

-(void)setValue:(id)value {
    self.task = (Task *)value;
    
    [self.headImgView setShadowWithType:EMIShadowPathRound shadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.03 shadowRadius:1.f image:self.task.headimg placeholder:@""];
    [self.postImgView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor blackColor] shadowOffset:CGSizeZero shadowOpacity:0.3 shadowRadius:5.f image:self.task.filmimg placeholder:@""];
    
    self.taskPublishPhoneLabel.text = [ValidateMobile hidePhone:self.task.dn];
    self.filmnameLabel.text = self.task.filmname;
    self.directorLabel.text = [NSString stringWithFormat:@"导演：%@",self.task.filmdirector];
    self.taskPointsLabel.text = [NSString stringWithFormat:@"%@积分",self.task.taskpoints];
    self.taskDateLabel.text = [NSString stringWithFormat:@"任务时间：%@-%@",self.task.startdate,self.task.enddate];
}
- (IBAction)delTask:(UIButton *)sender {
    AMAlertView *amalertview = [[AMAlertView alloc] initWithconsFrame:CGRectMake(43.5*autoSizeScaleX, (667/2-95.5)*autoSizeScaleY, 288*autoSizeScaleX, 191*autoSizeScaleY)];
    [amalertview setTitle:@"删除任务"];
    UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 288*autoSizeScaleX, 145*autoSizeScaleY)];
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(24*autoSizeScaleX, 77*autoSizeScaleY, 240*autoSizeScaleX, 41*autoSizeScaleY);
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"alert_shanchu"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(delTaskSure:) forControlEvents:UIControlEventTouchUpInside];
    [childView addSubview:sureBtn];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(24*autoSizeScaleX, 0, 240*autoSizeScaleX, 77*autoSizeScaleY)];
    lab.font = [UIFont fontWithName:@"DroidSansFallback" size:17.f*autoSizeScaleY];
    lab.textColor = [UIColor colorWithHexString:@"15151b"];
    lab.text = @"确认是否删除这个任务?";
    lab.textAlignment = NSTextAlignmentCenter;
    [childView addSubview:lab];
    
    [amalertview setChildView:childView];
    ckAlertVC = [[CKAlertViewController alloc] initWithAlertView:amalertview];
    
    [self.viewController presentViewController:ckAlertVC animated:NO completion:nil];
}
-(void)delTaskSure:(id)sender {
    __unsafe_unretained typeof (self) weakself = self;
    ManagerDeleteTaskWebInterface *managerdeleteInterface = [[ManagerDeleteTaskWebInterface alloc] init];
    NSDictionary *param = [managerdeleteInterface inboxObject:@[@(self.viewController.user.userid),@(self.task.taskid),@(self.viewController.user.usertype)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:managerdeleteInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [managerdeleteInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            [weakself.viewController.view makeToast:@"删除成功" duration:2.0 position:CSToastPositionCenter];
            //刷新数据
            if (weakself.viewController.tableViewArray[weakself.pageIndex].mj_header != nil) {
                [weakself.viewController.tableViewArray[weakself.pageIndex].mj_header beginRefreshing];
            }
            
        }else{
            [weakself.viewController.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
        }
    } WithErrorCodeBlock:^(id errorCode) {
        [weakself.viewController.view makeToast:@"请求错误" duration:2.0 position:CSToastPositionCenter];
    } WithFailureBlock:^{
        [weakself.viewController.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
    }];
    [ckAlertVC dismissViewControllerAnimated:NO completion:nil];
}

@end
