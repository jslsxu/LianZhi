//
//  HomeworkTeacherMark.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkTeacherMark.h"

@implementation HomeworkPhotoMark


@end

@implementation HomeworkMarkItem

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"marks" : [HomeworkPhotoMark class]};
}
@end

@implementation HomeworkTeacherMark
+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"marks" : [HomeworkMarkItem class]};
}

+ (HomeworkTeacherMark *)markWithString:(NSString *)markDetail{
    HomeworkTeacherMark *teacherMark = [[HomeworkTeacherMark alloc] init];
    [teacherMark modelSetWithJSON:markDetail];
    return teacherMark;
}
@end
