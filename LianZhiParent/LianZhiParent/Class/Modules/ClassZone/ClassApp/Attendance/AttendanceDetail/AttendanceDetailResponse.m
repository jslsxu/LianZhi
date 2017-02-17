//
//  AttendanceDetailResponse.m
//  LianZhiParent
//
//  Created by jslsxu on 17/1/10.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "AttendanceDetailResponse.h"

@implementation AttendanceNoteItem


@end

@implementation AttendanceInfo

@end

@implementation AttendanceDetailResponse
+ (NSDictionary<NSString*, id> *)modelContainerPropertyGenericClass{
    return @{@"recode" : [AttendanceNoteItem class], @"month_leave" : [NSString class], @"teacher_submit" : [NSString class]};
}
@end
