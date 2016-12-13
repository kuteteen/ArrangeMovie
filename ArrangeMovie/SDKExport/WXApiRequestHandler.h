//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#import <Foundation/Foundation.h>
#import "WXApiObject.h"

@interface WXApiRequestHandler : NSObject

@property(nonatomic,strong) void(^ wxreturnBlock)(NSString *returnStr);

- (void)jumpToBizPay:(NSNumber *)userid price:(NSNumber *)price usertype:(NSNumber *)usertype;

@end
