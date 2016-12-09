//
//  MeMissionTableViewCell.m
//  ArrangeMovie
//
//  Created by WongSuechang on 2016/10/17.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeMissionTableViewCell.h"
#import "AMAlertView.h"
#import "CKAlertViewController.h"
#import "MeDeleteTaskWebInterface.h"
#import "SCHttpOperation.h"
#import "MJRefreshGifHeader.h"

@interface MeMissionTableViewCell()
{
    CKAlertViewController *ckAlertVC;
}
@end

@implementation MeMissionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MeMissionTableViewCell";
    MeMissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MeMissionTableViewCell" owner:nil options:nil] firstObject];
    }
    
    cell.directorLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:12*autoSizeScaleX];
    cell.taskdateLabel.font = [UIFont fontWithName:@"Droid Sans Fallback" size:12*autoSizeScaleX];
    
    
    return cell;
}

-(void)setValue:(id)value {
    self.task = (Task *)value;
    [self.postImgView setShadowWithType:EMIShadowPathRoundRectangle shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeZero shadowOpacity:0.26 shadowRadius:5.f image:self.task.img placeholder:@""];
    self.filmnameLabel.text = self.task.filmname;
    self.directorLabel.text = [NSString stringWithFormat:@"导演：%@",self.task.filmdirector];
    self.taskdateLabel.text = [NSString stringWithFormat:@"任务时间：%@-%@",self.task.startdate,self.task.enddate];
    switch (self.task.taskstatus) {
        case 1:
            self.taskstatusLabel.text = @"待审核";
            self.deltaskBtn.hidden = NO;
            break;
        case 2:
            self.taskstatusLabel.text = @"已发布";
            self.deltaskBtn.hidden = YES;
            break;
        case 3:
            self.taskstatusLabel.text = @"已支付";
            self.deltaskBtn.hidden = YES;
            break;
        default:
            break;
    }
    self.taskpointLabel.text = [NSString stringWithFormat:@"%@积分",self.task.taskpoints];
}

//删除任务
- (IBAction)delTaskClicked:(UIButton *)sender {

    AMAlertView *amalertview = [[AMAlertView alloc] initWithconsFrame:CGRectMake(43.5*autoSizeScaleX, (667/2-95.5)*autoSizeScaleY, 288*autoSizeScaleX, 191*autoSizeScaleY)];
    [amalertview setTitle:@"删除任务"];
    UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 288*autoSizeScaleX, 145*autoSizeScaleY)];
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(24*autoSizeScaleX, 77*autoSizeScaleY, 240*autoSizeScaleX, 41*autoSizeScaleY);
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"alert_shanchu"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(delTask:) forControlEvents:UIControlEventTouchUpInside];
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
-(void)delTask:(id)sender {
    __unsafe_unretained typeof (self) weakself = self;
    MeDeleteTaskWebInterface *medeleteInterface = [[MeDeleteTaskWebInterface alloc] init];
    NSDictionary *param = [medeleteInterface inboxObject:@[@(self.viewController.user.userid),@(self.task.taskid),@(self.viewController.user.usertype)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:medeleteInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [medeleteInterface unboxObject:returnValue];
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
