//
//  ManagerMissionBtnTableViewCell.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/10/26.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ManagerMissionBtnTableViewCell.h"
#import "ReceiveTaskWebInterface.h"
#import "SCHttpOperation.h"
#import "ManagerUploadCertViewController.h"
#import "ManegerLookCertViewController.h"

@implementation ManagerMissionBtnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"ManagerMissionBtnTableViewCell";
    ManagerMissionBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ManagerMissionBtnTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}
- (IBAction)btnClicked:(UIButton *)sender {
    __unsafe_unretained typeof (self) weakself = self;
    UIStoryboard *manager = [UIStoryboard storyboardWithName:@"manager" bundle:nil];
    switch (self.flag) {
        case 0:
        {
            //领取任务
            
            ReceiveTaskWebInterface *medeleteInterface = [[ReceiveTaskWebInterface alloc] init];
            NSDictionary *param = [medeleteInterface inboxObject:@[@(self.viewController.user.userid),@(self.task.taskid),@(self.viewController.user.usertype)]];
            [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:medeleteInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
                NSArray *result = [medeleteInterface unboxObject:returnValue];
                if ([result[0] intValue] == 1) {
                    [weakself.viewController.view makeToast:@"领取任务成功" duration:2.0 position:CSToastPositionCenter];
                    [weakself.viewController.navigationController popViewControllerAnimated:YES];
                }else{
                    [weakself.viewController.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
                }
            } WithErrorCodeBlock:^(id errorCode) {
                [weakself.viewController.view makeToast:@"请求错误" duration:2.0 position:CSToastPositionCenter];
            } WithFailureBlock:^{
                [weakself.viewController.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
            }];
            break;
        }
        case 1:
        {
            //上传排片凭证
            ManagerUploadCertViewController *VC = [manager instantiateViewControllerWithIdentifier:@"uploadCertVC"];
            VC.task = self.task;
            [self.viewController.navigationController pushViewController:VC animated:YES];
            break;
        }
            
        case 2:
        {
            //查看排片凭证
            ManegerLookCertViewController *VC = [manager instantiateViewControllerWithIdentifier:@"lookCertVC"];
            VC.task = self.task;
            [self.viewController.navigationController pushViewController:VC animated:YES];
            break;
        }
        case 3:
        {
            //查看排片凭证
            ManegerLookCertViewController *VC = [manager instantiateViewControllerWithIdentifier:@"lookCertVC"];
            VC.task = self.task;
            [self.viewController.navigationController pushViewController:VC animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
