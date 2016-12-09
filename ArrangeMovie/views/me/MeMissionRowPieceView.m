//
//  MeMissionRowPieceView.m
//  ArrangeMovie
//
//  Created by 王雪成 on 2016/11/9.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MeMissionRowPieceView.h"
#import "SCDateTools.h"
#import "AMDetailUnDoViewController.h"
#import "AMDetailFailedViewController.h"
#import "AMDetailDoneViewController.h"

@implementation MeMissionRowPieceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initNibWithFrame:(CGRect)frame {
    self = [[[NSBundle mainBundle] loadNibNamed:@"MeMissionRowPieceView" owner:nil options:nil] objectAtIndex:0];
    if(self){
        self.frame = frame;
        self.redWidth.constant = 0;
        self.lightBlueWidth.constant = 0;
        self.blueWidth.constant = 0;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toDetail:)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}


- (void)setTakeTaskValues:(TakeTask *)taketask{
    self.taketask = taketask;
    
    [self.headimg setShadowWithType:EMIShadowPathRound shadowColor:[UIColor colorWithHexString:@"0a0e16"] shadowOffset:CGSizeMake(0, 1.5) shadowOpacity:0.1 shadowRadius:1.5 image:self.taketask.headimg placeholder:@"default_head"];
    
    NSDate *date = [SCDateTools stringToDateTime:self.taketask.taskdetaildate];
    NSString *timestr = [SCDateTools dateTopointedString:date format:@"hh:mm"];
    NSString *datestr = [SCDateTools dateTopointedString:date format:@"MM-dd"];
    self.timeLabel.text = timestr;
    self.dateLabel.text = datestr;
    NSString *hideDnstr = [NSString stringWithFormat:@"%@*****%@",[self.taketask.dn substringToIndex:3],[self.taketask.dn substringWithRange:NSMakeRange(self.taketask.dn.length-3, 3)]];
    self.telLabel.text = hideDnstr;
    //todo，不确定rate具体数值
    double ratedb = [self.taketask.rate doubleValue];
    
    if (self.taketask.taskdetailstatus == 1) {
        self.rateLabel.text  =@"等待片方审核";
        self.redLineView.hidden = YES;
        self.lightBlueLineView.hidden = YES;
        self.blueLineView.hidden = NO;
        self.blueWidth.constant = 154;
    }else if (self.taketask.taskdetailstatus == 2||self.taketask.taskdetailstatus == 3||self.taketask.taskdetailstatus == 5) {
        self.rateLabel.text  =@"任务未完成";
        self.redLineView.hidden = NO;
        self.lightBlueLineView.hidden = YES;
        self.blueLineView.hidden = YES;
        self.redWidth.constant = 154;
    }else if (self.taketask.taskdetailstatus == 0){
        self.redLineView.hidden = YES;
        self.lightBlueLineView.hidden = NO;
        self.blueLineView.hidden = NO;
        self.lightBlueWidth.constant = 154;
        self.blueWidth.constant = 154*ratedb/100;
        self.rateLabel.text = [NSString stringWithFormat:@"已完成%@%@",self.taketask.rate,@"%"];
    }else if (self.taketask.taskdetailstatus == 4){
        self.rateLabel.text  =@"等待平台审核";
        self.redLineView.hidden = YES;
        self.lightBlueLineView.hidden = YES;
        self.blueLineView.hidden = NO;
        self.blueWidth.constant = 154;
    }else if (self.taketask.taskdetailstatus == 6){
        self.rateLabel.text  =@"平台审核通过";
        self.redLineView.hidden = YES;
        self.lightBlueLineView.hidden = YES;
        self.blueLineView.hidden = NO;
        self.blueWidth.constant = 154;
    }
    
    
    
    
    
}

//跳转至排片详情
- (void)toDetail:(UITapGestureRecognizer *)sender{
    NSLog(@"%@",@"MeMissionRpwPiece Tapped");
    UIStoryboard *pfhome = [UIStoryboard storyboardWithName:@"pfhome" bundle:nil];
    AMDetailUnDoViewController *undoVC = [pfhome instantiateViewControllerWithIdentifier:@"undoVC"];
    AMDetailFailedViewController *failedVC = [pfhome instantiateViewControllerWithIdentifier:@"failedVC"];
    AMDetailDoneViewController *doneVC = [pfhome instantiateViewControllerWithIdentifier:@"doneVC"];
    switch (self.taketask.taskdetailstatus) {
        case 0:
            undoVC.selectedTakeTask = self.taketask;
            undoVC.selectedTaskId = self.taskid;
            [self.viewController.navigationController pushViewController:undoVC animated:YES];
            break;
        case 1:
            doneVC.selectedTakeTask = self.taketask;
            doneVC.selectedTaskId = self.taskid;
            [self.viewController.navigationController pushViewController:doneVC animated:YES];
            break;
        case 2:
            failedVC.selectedTakeTask = self.taketask;
            failedVC.selectedTaskId = self.taskid;
            [self.viewController.navigationController pushViewController:failedVC animated:YES];
            break;
        case 3:
            failedVC.selectedTakeTask = self.taketask;
            failedVC.selectedTaskId = self.taskid;
            [self.viewController.navigationController pushViewController:failedVC animated:YES];
            break;
        case 4:
            doneVC.selectedTakeTask = self.taketask;
            doneVC.selectedTaskId = self.taskid;
            doneVC.showOKBtn = 1;
            [self.viewController.navigationController pushViewController:doneVC animated:YES];
            break;
        case 5:
            failedVC.selectedTakeTask = self.taketask;
            failedVC.selectedTaskId = self.taskid;
            doneVC.showOKBtn = 1;
            [self.viewController.navigationController pushViewController:failedVC animated:YES];
            break;
        case 6:
            doneVC.selectedTakeTask = self.taketask;
            doneVC.selectedTaskId = self.taskid;
            [self.viewController.navigationController pushViewController:doneVC animated:YES];
            break;
        default:
            break;
    }
}
@end
