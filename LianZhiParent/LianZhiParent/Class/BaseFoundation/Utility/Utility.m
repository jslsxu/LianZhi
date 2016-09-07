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

+ (NSUInteger)sizeAtPath:(NSString *)filePath diskMode:(BOOL)diskMode
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
    return totalSize;
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

+ (NSString *)sizeStrForSize:(NSInteger)size{
    NSString *sizeStr;
    if(size < 1024){
        sizeStr = [NSString stringWithFormat:@"%zdB",size];
    }
    else if(size < 1024 * 1024)
        sizeStr = [NSString stringWithFormat:@"%zdk",size / 1024];
    else{
        sizeStr = [NSString stringWithFormat:@"%.1fM",size / (1024 * 1024.f)];
    }
    return sizeStr;
}

+ (NSString *)weekdayStr:(NSDate *)date{
    NSInteger weekday = [date weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    NSString *week = @"";
    switch (weekday) {
        case 1:
            week = @"星期日";
            break;
        case 2:
            week = @"星期一";
            break;
        case 3:
            week = @"星期二";
            break;
        case 4:
            week = @"星期三";
            break;
        case 5:
            week = @"星期四";
            break;
        case 6:
            week = @"星期五";
            break;
        case 7:
            week = @"星期六";
            break;
            
        default:
            break;
    }
    
    return week;
    
}

+ (void)saveImageToAlbum:(UIImage *)image{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(image, [self class], @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied)
        {
            [[[UIAlertView alloc] initWithTitle:@"图片保存失败😱" message:@"请检查隐私中的图片访问权限。" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
        }
        else
        {
            [ProgressHUD showHintText:@"图片保存失败"];
        }
        
    } else {
        [ProgressHUD showHintText:@"已保存到本地相册"];
    }
}

+ (void)saveVideoToAlbum:(NSString *)videoPath{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UISaveVideoAtPathToSavedPhotosAlbum(videoPath, [self class], @selector(video: didFinishSavingWithError:contextInfo:), nil);
    });
}

+ (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(!error){
        [ProgressHUD showHintText:@"已保存到本地相册"];
    }
    else{
        [ProgressHUD showHintText:@"视频保存失败"];
    }
}

+ (BOOL)checkVideoSize:(long long)size{
    if(size > kMaxVideoSize){
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:@"视频文件过大" style:LGAlertViewStyleAlert buttonTitles:@[@"确定"] cancelButtonTitle:nil destructiveButtonTitle:nil];
        [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView showAnimated:YES completionHandler:nil];
        return NO;
    }
    else{
        return YES;
    }
}
@end
