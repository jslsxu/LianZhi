//
//  StudentAttendanceDetail.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/1/12.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "StudentAttendanceDetail.h"

@implementation StudentAttendanceDetailInfo


@end

@implementation StudentAttendanceDetail
+ (NSDictionary<NSString*, id> *)modelContainerPropertyGenericClass{
    return @{@"recode" : [AttendanceNoteItem class]};
}
@end