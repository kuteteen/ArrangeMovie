//
//  AlipayRequestHandler.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/12/5.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "AlipayRequestHandler.h"
#import "DataSigner.h"
#import "SCHttpOperation.h"


@implementation AlipayRequestHandler
#define privatekey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAInn7BOaAU4zZfpERyaGFiKgeM/shtcl81HKLl136O3A+7ctTzjrNzO2czGPuuiCG1ubYUyEboq1KmNHOadbGgdzAgceYv3TJ8Gb6qtmybMiUdQYDiZHBLSe2fll0kun0GnAJZ1TLg9nCKTrbkStA31Q7SJfTDkvdvFMkLf0qdN9AgMBAAECgYBqklX4F+2mV0YZj6ZEeR6mB8kVNb5Gicdtj4chKEdTZO2hc1xjqjJwvjBrPp28jL9DneIlVbpvau2k5ygA0wBbVWhbVHRmNWHA6KnQSuxLVwfLlNKdr7Hlq5ClbiBLZYk2IQ9xkYY8tCNBeTJPRfwjHkyNhEJ8Q4WJS3u3B6dsKQJBAORtD5aH5NW2hjxuuzAeE/lROz95VPC5VcNNKvqlXvIOmGsuTlvGxyElg54BxrCmVwDMF0WQx2ifzDMksqo2xpMCQQCajZAoeaPIazSMCuuw4Tr/8T93P0T/PAcXNDPfX8mSE/fgq3mK0cstc/q2blwohk87zP6unPZFMtpn77u3x7evAkBtJZukLuzuHVgI+lQhSs36fJEV5FDs8XIEbxQRTgGPIeA8npS8j7/Im9dHIcwhzmmWLO8Vw3c1C94Ttf5VDPVXAkBhiPsz/+fzoGxOAMpTGyDPyuDhkYUqiihzZVdjHaEo1f81wyF2EQXnDm1nWehBDtnMBIepjJcCfqBEvY864QgzAkEAueXEYZKm95E0lMUO8l98Q9GHiCZs74bn+wIQnvlFlURERJg+Dtm4zgWdSCJoWG+11whCCatsTvwWj+7PaYG/MQ=="


- (void)jumpToBizPay:(NSString *)userid price:(NSNumber *)price {
    
    
    __block NSString *returnStr = @"初始化";
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   = @"http://192.168.2.176:8080/movie/app/getPayParam.do";
    
    //请求参数
    //1.json
//    NSString *jsonStr = [NSString stringWithFormat:@"{\"userid\":%d,\"price\":%.2f,\"paycode\":\"wechatapp\"}",[userid intValue],[price doubleValue]];
    //    NSDictionary *json = @{@"userid":[NSNumber numberWithInteger:[userid integerValue]],@"price":price,@"paycode":@"wechatapp"};
    //2.RSA加密后的sign
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privatekey);
//    NSString *signedString = [signer signString:jsonStr];
//    NSDictionary *param = @{@"json":jsonStr,@"sign":signedString,@"deviceno":@"EMITEST"};
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:urlString withparameter:nil WithReturnValeuBlock:^(id returnValue) {
        if (returnValue) {
            NSMutableDictionary *dict = (NSMutableDictionary *)returnValue;
            if(dict != nil){
                NSMutableString *retcode = [dict objectForKey:@"success"];
                if (retcode.intValue == 1){
                    NSMutableString *data = [dict objectForKey:@"data"];
                    
                    
                    
                    //调起支付宝支付
                    //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
                    NSString *appScheme = @"2016072900119696";
                    
                    // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
//                    NSString *orderString = @"";//[NSString stringWithFormat:@"%@&sign=%@",
                                               //orderInfoEncoded, signedString]
                    
                    // NOTE: 调用支付结果开始支付
                    [[AlipaySDK defaultService] payOrder:data fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        NSLog(@"reslut = %@",resultDic);
                    }];
                    returnStr = @"";
                    self.alireturnBlock(returnStr);
                }else{
                    returnStr =  [dict objectForKey:@"msg"];
                    self.alireturnBlock(returnStr);
                }
            }else{
                returnStr =  @"服务器返回错误，未获取到json对象";
                self.alireturnBlock(returnStr);
            }
        }else{
            returnStr =  @"服务器返回错误";
            self.alireturnBlock(returnStr);
        }
    } WithErrorCodeBlock:^(id errorCode) {
        returnStr =  @"请求失败";
        self.alireturnBlock(returnStr);
    } WithFailureBlock:^{
        returnStr =  @"网络错误";
        self.alireturnBlock(returnStr);
    }];
    
    
}
@end
