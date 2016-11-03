//
//  ValidateMobile.h
//  EMINest
//
//  Created by WongSuechang on 15/3/17.
//  Copyright (c) 2015年 emi365. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ValidateMobile;

@interface ValidateMobile : NSObject

+(BOOL)ValidateMobile:(NSString *)phoneNumber;
+(NSString *)hidePhone:(NSString *)phone;
@end
