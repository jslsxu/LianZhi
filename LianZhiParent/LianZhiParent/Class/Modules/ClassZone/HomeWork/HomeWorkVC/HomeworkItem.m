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

- (BOOL)canDelete{
    if(!self.etype){
        return YES;
    }
    if(self.status == HomeworkStatusMarked){
        return YES;
    }
    if(self.reply_close && [self.reply_close_ctime length] > 0){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *expireDate = [dateFormatter dateFromString:self.reply_close_ctime];
        NSInteger expireTimeinterval = [expireDate timeIntervalSince1970];
        NSInteger curTimeInterval = [[NSDate date] timeIntervalSince1970];
        if(curTimeInterval > expireTimeinterval){
            return YES;
        }
    }
    return NO;
}

- (BOOL)expired{
    if(self.reply_close && [self.reply_close_ctime length] > 0){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *endDate = [dateFormatter dateFromString:self.reply_close_ctime];
        if([[NSDate date] timeIntervalSinceDate:endDate] > 0){
            return YES;
        }
    }
    return NO;
}

@end
