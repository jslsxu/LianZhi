//
//  HomeworkItem.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/17.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkItem.h"

@implementation HomeworkItem

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"hid" : @"id",
             @"voice" : @"question.voice",
             @"pics" : @"question.pics",
             @"words" : @"question.words"};
}

- (BOOL)hasImage{
    return self.pics.count > 0;
}

- (BOOL)hasAudio{
    return self.voice != nil;
}
@end
