//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"
#import "PayOrderModel.h"
#import "SCHttpOperation.h"

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}



#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    }else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
//        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
//        
//        switch (resp.errCode) {
//            case WXSuccess:
//                strMsg = @"支付结果：成功！";
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                break;
//                
//            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！"];//retcode = %d, retstr = %@", resp.errCode,resp.errStr
//                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                break;
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        
        PayOrderModel *pmodel = [PayOrderModel sharedInstance];
        [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:@"http://116.62.42.99/app/appnotify.do" withparameter:@{@"chargeid":@(pmodel.chargeid),@"orderno":pmodel.orderno} WithReturnValeuBlock:^(id returnValue) {

            if ([[returnValue objectForKey:@"success"] intValue] == 1){
                int paystate = [[returnValue objectForKey:@"paystate"] intValue];
                if (paystate == 1) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:[returnValue objectForKey:@"成功"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                if (paystate == 2) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:[returnValue objectForKey:@"失败"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:[returnValue objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        } WithErrorCodeBlock:^(id errorCode) {
            
        } WithFailureBlock:^{
            
        }];
    }

}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}

@end
