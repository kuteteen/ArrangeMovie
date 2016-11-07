//
//  DateTools.m
//  EMINest
//
//  Created by WongSuechang on 15-4-27.
//  Copyright (c) 2015年 emi365. All rights reserved.
//

#import "SCDateTools.h"

@implementation SCDateTools
/**
 * date转String“yyyy-MM-dd”
 */
+(NSString *)dateToString:(NSDate *) date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

/**
 * date转String“yyyy-MM-dd hh:mm:ss”
 */
+(NSString *)dateTimeToString:(NSDate *) date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [formatter stringFromDate:date];
}

/**
 * 
 */
+(NSDate *)stringToDate:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:dateString];
}

/**
 *
 */
+(NSDate *)stringToDateTime:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [formatter dateFromString:dateString];
}

/**
 * 根据日期String计算星期
 */
+(NSString *)caculateWeek:(NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [formatter dateFromString:dateString];
    if(date){
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];//设置成中国阳历
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit;
        comps = [calendar components:unitFlags fromDate:date];
        long weekNumber = [comps weekday]; //获取星期对应的长整形字符串
    //    long day=[comps day];//获取日期对应的长整形字符串
    //    long year=[comps year];//获取年对应的长整形字符串
    //    long month=[comps month];//获取月对应的长整形字符串
        NSString *weekDay;
        switch (weekNumber) {
            case 1:
                weekDay=@"星期日";
                break;
            case 2:
                weekDay=@"星期一";
                break;
            case 3:
                weekDay=@"星期二";
                break;
            case 4:
                weekDay=@"星期三";
                break;
            case 5:
                weekDay=@"星期四";
                break;
            case 6:
                weekDay=@"星期五";
                break;
            case 7:
                weekDay=@"星期六";
                break;
                
            default:
                break;
        }
        return weekDay;
    }else{
        return @"";
    }
}

//返回前后十年的年份数组
+(NSMutableArray *)tenyearsFromNow{
    NSMutableArray *year = [[NSMutableArray alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *nowyearstr = [formatter stringFromDate:[NSDate date]];
    NSInteger nowyear = nowyearstr.integerValue;
    for (NSInteger i = nowyear-10; i<nowyear; i++) {
        [year addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    for (NSInteger i = nowyear; i<nowyear+10; i++) {
        [year addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    return year;
}
//返回月份数组
+(NSMutableArray *)monthMax{
    NSMutableArray *month = [[NSMutableArray alloc] init];
    for (int i = 1; i<=12; i++) {
        if (i<10) {
            [month addObject:[NSString stringWithFormat:@"%d%d",0,i]];
        }
        else{
            [month addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
    }
    return month;
}

//返回最大天数数组
+(NSMutableArray *)dayMax{
    NSMutableArray *day = [[NSMutableArray alloc] init];
    for (int i = 1; i<=31; i++) {
        if (i<10) {
            [day addObject:[NSString stringWithFormat:@"%d%d",0,i]];
        }
        else{
            [day addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return day;
}
//返回月份中的天数数组
+(NSMutableArray *)dayInMonth:(NSString *)month year:(NSString *)year{
    NSMutableArray *day = [[NSMutableArray alloc] init];
    
    int alldays = 0;//月份中的总天数
    
    int yearint = year.intValue;
    int imonth = month.intValue;
    
    if((imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12))
        alldays = 31;
    if((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11))
        alldays = 30;
    if (imonth == 2) {
        alldays = 29;
        if((yearint%4 == 1)||(yearint%4 == 2)||(yearint%4 == 3))
        {
            alldays = 28;
        }
        if(yearint%400 == 0)
            alldays = 29;
        if(yearint%100 == 0)
            alldays =  28;
    }
    for (int i = 1; i<=alldays; i++) {
        if (i<10) {
            [day addObject:[NSString stringWithFormat:@"%d%d",0,i]];
        }
        else{
            [day addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return day;
}

//返回指定格式的时间
+(NSString *)dateTopointedString:(NSDate *) date format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}


+(NSInteger)daysBetween:(NSDate *)start and:(NSDate *)end {
    
    //把开始时间转成当天日期+00:00:00
    //结束时间转成当天时间+23:59:59
    
    NSTimeInterval startDate = [start timeIntervalSince1970];
    NSTimeInterval endDate = [end timeIntervalSince1970];
    double difference;
    if(startDate>endDate){
        difference = startDate - endDate;
    }else{
        difference = endDate - startDate;
    }
    
    NSInteger days = (NSInteger)difference/(24*3600);
    return 0;
}

@end
