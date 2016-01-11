//
//  Utility.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/26.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "Utility.h"
#include <sys/stat.h>
#import <CommonCrypto/CommonDigest.h>  //md5 用到
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
        memSize = [NSString stringWithFormat:@"%.1fKB",(totalSize / 1024.f)];
    else if (totalSize < 1024 * 1024 * 1024)
        memSize = [NSString stringWithFormat:@"%.1fM",totalSize / (1024 * 1024.f)];
    else
        memSize = [NSString stringWithFormat:@"%.1fG",totalSize / (1024 * 1024 * 1024.f)];
    
    return memSize;
}

+ (NSString *)weekdayNameForIndex:(NSInteger)day
{
    static NSString *weekdays[7] = {@"日", @"一",@"二",@"三",@"四",@"五",@"六"};
    return weekdays[day];
}

+ (NSString *)weekdayStrForSelectedArray:(NSArray *)selectedArray
{
    if(selectedArray.count == 0)
        return nil;
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:0];
    for (NSNumber *number in selectedArray)
    {
        NSInteger index = number.integerValue;
        if(index >=0 && index < 7)
            [str appendFormat:@" %@",[Utility weekdayNameForIndex:number.integerValue]];
    }
    return str;
}
+ (NSString *)timeForOffsetTimeInterval:(NSInteger)timeInterval
{
    return [NSString stringWithFormat:@"%02ld:%02ld",(long)(timeInterval / 3600), (long)((timeInterval % 3600) / 60)];
}

//得到字符串的md5值
+ (NSString *)md5String:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    memset(result, 0, CC_MD5_DIGEST_LENGTH);
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)formatStringWithTimeInterval:(NSInteger)timeInterval
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayStr = [formatter stringFromDate:[NSDate date]];
    NSDate *today = [formatter dateFromString:todayStr];
    NSInteger todayInterval = [today timeIntervalSince1970];//今天0点的时间戳
    NSInteger yesterdayInterval = todayInterval - 60 * 60 * 24;//昨天的时间戳
    NSString *formatStr = nil;
    NSInteger nowTimeInterval = [[NSDate date] timeIntervalSince1970];
    if(timeInterval > todayInterval)//今天的
    {
        NSInteger deltaInterval = nowTimeInterval - timeInterval;
        if (deltaInterval < 60)//一分钟内
            formatStr = @"刚刚";
        else if(deltaInterval < 60 * 60)//
            formatStr = [NSString stringWithFormat:@"%ld分钟前",(long)deltaInterval / 60];
        else
            formatStr = [NSString stringWithFormat:@"%ld小时前",(long)deltaInterval / (60 * 60)];
    }
    else if(timeInterval > yesterdayInterval)//昨天的
    {
        formatStr = @"昨天";
    }
    else//之前的
    {
        [formatter setDateFormat:@"yy/MM/dd"];
        NSDate *originalDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        formatStr = [formatter stringFromDate:originalDate];
    }
    return formatStr;
}


+ (BOOL)isPhotoLibraryActive
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if(author == ALAuthorizationStatusNotDetermined || author == ALAuthorizationStatusAuthorized)
        return YES;
    return NO;
}

@end
