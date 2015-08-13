//
//  TaskUploadManager.h
//  LianZhiParent
//
//  Created by jslsxu on 15/3/25.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskItem.h"
@interface TaskUploadManager : NSObject
{
    NSMutableArray *_taskArray;
}
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(TaskUploadManager)
- (void)start;
- (void)cleanTask;
- (void)addTask:(TaskItem *)taskItem;
- (void)removeTask:(TaskItem *)taskItem;
- (NSString *)saveTask:(TaskItem *)taskItem;
@end
