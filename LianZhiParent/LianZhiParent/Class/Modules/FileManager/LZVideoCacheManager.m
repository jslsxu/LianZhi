//
//  LZVideoCacheManager.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/11.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "LZVideoCacheManager.h"
#import "NSString+YYAdd.h"
#import "NHFileManager.h"
#import "NHFileDownloadManager.h"
@implementation LZVideoCacheManager
SYNTHESIZE_SINGLETON_FOR_CLASS(LZVideoCacheManager)
+ (BOOL)isRemoteUrl:(NSString *)url{
    if([url hasPrefix:@"http:"] || [url hasPrefix:@"https:"]){
        return YES;
    }
    return NO;
}
+ (BOOL)videoExistForKey:(NSString *)key{
    if(key.length == 0){
        return NO;
    }
    return [NHFileManager existsItemAtPath:[self videoPathForKey:key]];
}
+ (NSString *)videoPathForKey:(NSString *)key{
    NSString *localPath;
    if([self isRemoteUrl:key]){//网络地址
        NSString *extension = key.pathExtension;
        localPath = [[NHFileManager localVideoCachePath] stringByAppendingPathComponent:[key md5String]];
        localPath = [localPath stringByAppendingPathExtension:extension];
    }
    else{
        localPath = key;
    }
    return localPath;
}
+ (void)videoForUrl:(NSString *)url progress:(void (^)(CGFloat progress))progressBlk  complete:(void (^)(NSURL *url))completion fail:(void (^)(NSError *error))fail{
    if(![self isRemoteUrl:url]){
        if(completion){
            completion([NSURL fileURLWithPath:url]);
        }
    }
    else{
        NSString *localPath = [self videoPathForKey:url];
        if([self videoExistForKey:url]){
            if(completion){
                completion([NSURL fileURLWithPath:localPath]);
            }
        }
        else{
            [[NHFileDownloadManager sharedInstance] downloadWithUrlStirng:url cachePathString:localPath progress:^(float progress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(progressBlk){
                        progressBlk(progress);
                    }
                });
            } success:^(NSURL *fileUrl) {
                if(completion){
                    completion(fileUrl);
                }
            } failure:^(NSError *error) {
                if(fail){
                    fail(error);
                }
            }];
        }
    }
}


@end
