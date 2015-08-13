//
//  Utility.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/26.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "Utility.h"
#include <sys/stat.h>

@implementation Utility

+ (NSString *)formatStringForTime:(NSInteger)timeInterval
{
    if(timeInterval < 60)
        return [NSString stringWithFormat:@"%ld\"",(long)timeInterval];
    else
    {
        NSInteger minute = timeInterval / 60;
        NSInteger second = timeInterval % 60;
        return [NSString stringWithFormat:@"%ld'%ld\"",(long)minute, (long)second];
    }
}

+ (NSString *)sizeAtPath:(NSString *)filePath diskMode:(BOOL)diskMode
{
    uint64_t totalSize = 0;
    NSMutableArray *searchPaths = [NSMutableArray arrayWithObject:filePath];
    while ([searchPaths count] > 0)
    {
        @autoreleasepool
        {
            NSString *fullPath = [searchPaths objectAtIndex:0];
            [searchPaths removeObjectAtIndex:0];
            
            struct stat fileStat;
            if (lstat([fullPath fileSystemRepresentation], &fileStat) == 0)
            {
                if (fileStat.st_mode & S_IFDIR)
                {
                    NSArray *childSubPaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fullPath error:nil];
                    for (NSString *childItem in childSubPaths)
                    {
                        NSString *childPath = [fullPath stringByAppendingPathComponent:childItem];
                        [searchPaths insertObject:childPath atIndex:0];
                    }
                }else
                {
                    if (diskMode)
                        totalSize += fileStat.st_blocks*512;
                    else
                        totalSize += fileStat.st_size;
                }
            }
        }
    }
    NSString *memSize = nil;
    if(totalSize < 1024 * 1024)
        memSize = [NSString stringWithFormat:@"0M"];
    else if (totalSize < 1024 * 1024 * 1024)
        memSize = [NSString stringWithFormat:@"%ldM",(long)totalSize / (1024 * 1024)];
    else
        memSize = [NSString stringWithFormat:@"%ldG",(long)totalSize / (1024 * 1024 * 1024)];
    
    return memSize;
}

@end
