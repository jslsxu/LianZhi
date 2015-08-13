//
//  TaskUploadManager.m
//  LianZhiParent
//
//  Created by jslsxu on 15/3/25.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TaskUploadManager.h"

@implementation TaskUploadManager
SYNTHESIZE_SINGLETON_FOR_CLASS(TaskUploadManager)
- (id)init
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChanged) name:kReachabilityChangedNotification object:nil];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths lastObject];
        NSString *cachePath = [docDir stringByAppendingPathComponent:kTaskCacheDirectory];
        if(![[NSFileManager defaultManager] fileExistsAtPath:cachePath])
            [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        else
        {
            NSArray *subpaths = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
            if(subpaths.count > 0)
            {
                if(_taskArray == nil)
                    _taskArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSInteger i = 0; i < subpaths.count; i++) {
                    NSString *subpath = subpaths[i];
                    NSString *filePath = [cachePath stringByAppendingPathComponent:subpath];
                    NSData *data = [NSData dataWithContentsOfFile:filePath];
                    if(data)
                    {
                        TaskItem *taskItem = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        taskItem.filePath = filePath;
                        [_taskArray addObject:taskItem];
                    }
                }
            }
        }
    }
    return self;
}

- (void)start
{
    [self onNetworkStatusChanged];
}

- (void)cleanTask
{
    //清除所有任务
    for (TaskItem *taskItem in _taskArray) {
        [taskItem.uploadTask cancel];
    }
    [_taskArray removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths lastObject];
        NSString *cachePath = [docDir stringByAppendingPathComponent:kTaskCacheDirectory];
        if([[NSFileManager defaultManager] fileExistsAtPath:cachePath])
        {
            NSArray *subpaths = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
            for (NSString *subpath in subpaths) {
                NSString *itemPath = [cachePath stringByAppendingPathComponent:subpath];
                [[NSFileManager defaultManager] removeItemAtPath:itemPath error:nil];
            }
        }
    });
}

- (void)addTask:(TaskItem *)taskItem
{
    if([taskItem.filePath length] == 0)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths lastObject];
        NSString *cachePath = [docDir stringByAppendingPathComponent:kTaskCacheDirectory];
        taskItem.filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)[NSDate timeIntervalSinceReferenceDate]]];
    }
    @synchronized(self)
    {
        [_taskArray addObject:taskItem];
        Reachability* curReach = ApplicationDelegate.hostReach;
        NetworkStatus status = [curReach currentReachabilityStatus];
        if(status == ReachableViaWiFi || (status == ReachableViaWWAN && ![UserCenter sharedInstance].personalSetting.wifiSend))
        {
            [taskItem startUpload];
        }
    }
}

- (void)removeTask:(TaskItem *)taskItem
{
    [[NSFileManager defaultManager] removeItemAtPath:taskItem.filePath error:nil];
    [taskItem.uploadTask cancel];
    [_taskArray removeObject:taskItem];
}

- (void)loadData
{
    
}

- (void)onNetworkStatusChanged
{
    Reachability* curReach = ApplicationDelegate.hostReach;
    NetworkStatus status = [curReach currentReachabilityStatus];
    if(status == ReachableViaWiFi || (status == ReachableViaWWAN && ![UserCenter sharedInstance].personalSetting.wifiSend))
    {
        for (TaskItem *taskItem in _taskArray) {
            if(taskItem.uploadTask == nil)
            {
                [taskItem startUpload];
            }
        }
    }
}

- (NSString *)saveTask:(TaskItem *)taskItem
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths lastObject];
    NSString *cachePath = [docDir stringByAppendingPathComponent:kTaskCacheDirectory];
    if(![[NSFileManager defaultManager] fileExistsAtPath:cachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.dat",(long)[NSDate timeIntervalSinceReferenceDate]]];
    taskItem.filePath = filePath;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:taskItem];
    if(data)
        [data writeToFile:filePath atomically:YES];
    return filePath;
}
@end
