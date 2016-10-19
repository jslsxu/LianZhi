//
//  HomeworkManager.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/14.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"
#import "HomeWorkEntity.h"
extern NSString *kHomeworkManagerChangedNotification;
extern NSString *kHomeworkSendSuccessNotification;
extern NSString *kNewHomeworkToSend;
#define kSendingHomeworkKey         @"SendingHomework"
#define kSendedHomeworkKey          @"SendedHomework"
@interface HomeworkManager : TNBaseObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(HomeworkManager)
@property (nonatomic, readonly)NSArray*    sendingHomeworkArray;
- (void)addHomework:(HomeWorkEntity *)homeworkSendEntity;
- (void)removeHomework:(HomeWorkEntity *)homeworkSendEntity;
- (void)clearSendingList;
@end
