//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#import "WXApi.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "NSDictionary+ToJsonStr.h"
#import "SCHttpOperation.h"
#import "DataSigner.h"
#import "CKRSAUtil.h"

@implementation WXApiRequestHandler

#pragma mark - Public Methods

#define privatekey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAInn7BOaAU4zZfpERyaGFiKgeM/shtcl81HKLl136O3A+7ctTzjrNzO2czGPuuiCG1ubYUyEboq1KmNHOadbGgdzAgceYv3TJ8Gb6qtmybMiUdQYDiZHBLSe2fll0kun0GnAJZ1TLg9nCKTrbkStA31Q7SJfTDkvdvFMkLf0qdN9AgMBAAECgYBqklX4F+2mV0YZj6ZEeR6mB8kVNb5Gicdtj4chKEdTZO2hc1xjqjJwvjBrPp28jL9DneIlVbpvau2k5ygA0wBbVWhbVHRmNWHA6KnQSuxLVwfLlNKdr7Hlq5ClbiBLZYk2IQ9xkYY8tCNBeTJPRfwjHkyNhEJ8Q4WJS3u3B6dsKQJBAORtD5aH5NW2hjxuuzAeE/lROz95VPC5VcNNKvqlXvIOmGsuTlvGxyElg54BxrCmVwDMF0WQx2ifzDMksqo2xpMCQQCajZAoeaPIazSMCuuw4Tr/8T93P0T/PAcXNDPfX8mSE/fgq3mK0cstc/q2blwohk87zP6unPZFMtpn77u3x7evAkBtJZukLuzuHVgI+lQhSs36fJEV5FDs8XIEbxQRTgGPIeA8npS8j7/Im9dHIcwhzmmWLO8Vw3c1C94Ttf5VDPVXAkBhiPsz/+fzoGxOAMpTGyDPyuDhkYUqiihzZVdjHaEo1f81wyF2EQXnDm1nWehBDtnMBIepjJcCfqBEvY864QgzAkEAueXEYZKm95E0lMUO8l98Q9GHiCZs74bn+wIQnvlFlURERJg+Dtm4zgWdSCJoWG+11whCCatsTvwWj+7PaYG/MQ=="


- (void)jumpToBizPay:(NSString *)userid price:(NSNumber *)price {

    
    __block NSString *returnStr = @"初始化";
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   = @"http://www.emi365.cn/emipay/pos/addOrder.do";
    
    //请求参数
    //1.json
    NSString *jsonStr = [NSString stringWithFormat:@"{\"userid\":%d,\"price\":%.2f,\"paycode\":\"wechatapp\"}",[userid intValue],[price doubleValue]];
//    NSDictionary *json = @{@"userid":[NSNumber numberWithInteger:[userid integerValue]],@"price":price,@"paycode":@"wechatapp"};
    //2.RSA加密后的sign
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privatekey);
    NSString *signedString = [signer signString:jsonStr];
    NSDictionary *param = @{@"json":jsonStr,@"sign":signedString,@"deviceno":@"EMITEST"};
        [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:urlString withparameter:param WithReturnValeuBlock:^(id returnValue) {
            if (returnValue) {
                NSMutableDictionary *dict = (NSMutableDictionary *)returnValue;
                if(dict != nil){
                    NSMutableString *retcode = [dict objectForKey:@"success"];
                    if (retcode.intValue == 1){
                        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                        
                        //调起微信支付
                        PayReq* req             = [[PayReq alloc] init];
                        req.partnerId           = [dict objectForKey:@"partnerid"];
                        req.prepayId            = [dict objectForKey:@"prepayid"];
                        req.nonceStr            = [dict objectForKey:@"noncestr"];
                        req.timeStamp           = stamp.intValue;
                        req.package             = @"Sign=WXPay";
                        req.sign                = [dict objectForKey:@"sign"];
                        [WXApi sendReq:req];
                        //日志输出
                        NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                        returnStr =  @"";
                        self.wxreturnBlock(returnStr);
                    }else{
                        returnStr =  [dict objectForKey:@"msg"];
                        self.wxreturnBlock(returnStr);
                    }
                }else{
                    returnStr =  @"服务器返回错误，未获取到json对象";
                    self.wxreturnBlock(returnStr);
                }
            }else{
                returnStr =  @"服务器返回错误";
                self.wxreturnBlock(returnStr);
            }
        } WithErrorCodeBlock:^(id errorCode) {
            returnStr =  @"请求失败";
            self.wxreturnBlock(returnStr);
        } WithFailureBlock:^{
            returnStr =  @"网络错误";
            self.wxreturnBlock(returnStr);
        }];
    
    
}
@end
