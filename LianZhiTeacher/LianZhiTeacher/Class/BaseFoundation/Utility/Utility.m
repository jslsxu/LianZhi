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

+ (NSString *)sizeStrForSize:(long long)size{
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

+ (AVAsset *)avAssetFromALAsset:(ALAsset *)alasset{
    ALAssetRepresentation *representation = [alasset defaultRepresentation];
    NSString *filePath = [[representation url] absoluteString];
    AVAsset *avAsset = [AVAsset assetWithURL:[NSURL URLWithString:filePath]];
    return avAsset;
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
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied)
        {
            [[[UIAlertView alloc] initWithTitle:@"视频保存失败😱" message:@"请检查隐私中的图片访问权限。" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
        }
        else{
            [ProgressHUD showHintText:@"已保存到本地相册"];
        }
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

+ (BOOL)checkVideo:(ALAsset *)asset{
    NSInteger duration = [[asset valueForProperty:ALAssetPropertyDuration] integerValue];
    if(duration > 10){
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:@"目前视频文件暂时不能超过10秒" style:LGAlertViewStyleAlert buttonTitles:@[@"确定"] cancelButtonTitle:nil destructiveButtonTitle:nil];
        [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView showAnimated:YES completionHandler:nil];
        return NO;
    }
    return YES;
}

+ (NSString *)durationText:(NSInteger)duration{
    NSString *text = nil;
    NSInteger hour = duration / 3600;
    NSInteger minute = (duration - hour * 3600) / 60;
    NSInteger second = duration - hour * 3600 - minute * 60;
    if(duration < 60){
        text = [NSString stringWithFormat:@"0:%02zd",second];
    }
    else if(duration < 60 * 60){
        text = [NSString stringWithFormat:@"%zd:%02zd",minute, second];
    }
    else{
        text = [NSString stringWithFormat:@"%zd:%zd:%02zd",hour, minute, second];
    }
    return text;
}

@end
