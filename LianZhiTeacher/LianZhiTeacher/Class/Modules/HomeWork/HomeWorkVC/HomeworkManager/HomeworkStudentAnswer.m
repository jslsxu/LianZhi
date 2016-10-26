//
//  HomeworkStudentAnswer.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkStudentAnswer.h"

@implementation HomeworkStudentAnswer

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"pics" : [PhotoItem class]};
}

- (BOOL)marked{
    return self.teacherMark != 0;
}
@end
