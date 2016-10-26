//
//  HomeworkItem.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkItem.h"

NSString* const kHomeworkItemChangedNotification = @"HomeworkItemChangedNotification";

@implementation HomeworkItemAnswer
+ (NSDictionary<NSString *, id>*)modelContainerPropertyGenericClass{
    return @{@"pics" : [PhotoItem class]};
}

@end

@implementation HomeworkItem

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"homeworkId" : @"id",@"words" : @"question.words",
             @"pics" : @"question.pics",
             @"voice" : @"question.voice",
             };
}

+ (NSDictionary<NSString * ,id> *)modelContainerPropertyGenericClass{
    return @{@"pics" : [PhotoItem class]};
}

- (BOOL)hasAudio{
    return self.voice.audioUrl.length > 0;
}

- (BOOL)hasPhoto{
    return [self.pics count] > 0;
}

@end
