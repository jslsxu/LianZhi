//
//  NSFileServer.m
//  NHFileDownloadManager-demo
//
//  Created by Wilson Yuan on 15/11/19.
//  Copyright © 2015年 Wilson-Yuan. All rights reserved.
//

#import "NHFileServer.h"

#import "NHFileDownloadManager.h"

#import "NHFileCache.h"

@implementation NHFileServer

+ (void)server_fileInfoWithUrlString:(NSString *)urlString
                            progress:(ProgressBlock)progressHandler
                             success:(ServerSuccessBlock)successHandler
                             failure:(FailureBlock)failureHandler {
    
    [kNHFileCache queryCacheForKey:urlString done:^(NSDictionary *fileInfo) {
        if (fileInfo) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progressHandler(1.0);
                successHandler(fileInfo);
            });
        }
        else {
            [kNHFileDownloadManager downloadWithUrlStirng:urlString progress:progressHandler success:^(NSURL *fileUrl) {
                    [kNHFileCache fileInfoAtPath:fileUrl.path cacheForKey:urlString done:^(NSDictionary *info) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            successHandler(info);
                        });
                    }];

            } failure:failureHandler];
        }
    }];
}
+ (void)server_queryFileExistWithUrlString:(NSString *)urlString
                                      done:(void (^)(BOOL, NSDictionary *))doneBlock{
    
    [kNHFileCache queryCacheForKey:urlString done:^(NSDictionary *fileInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (fileInfo) {
                doneBlock(YES, fileInfo);
            }
            else {
                doneBlock(NO, nil);
            }
        });
    }];
}

+ (void)server_downloadFileWithUrlString:(NSString *)urlString
                                progress:(ProgressBlock)progressHandler
                                 success:(ServerSuccessBlock)successHandler
                                 failure:(FailureBlock)failureHandler {
    [kNHFileDownloadManager downloadWithUrlStirng:urlString progress:progressHandler success:^(NSURL *fileUrl) {
        [kNHFileCache fileInfoAtPath:fileUrl.path cacheForKey:urlString done:^(NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                successHandler(info);
            });
        }];
        
    } failure:failureHandler];
}

+ (void)server_cancelDownloadingWithUrlString:(NSString *)urlString {
    [kNHFileDownloadManager cancelDownloadingWithUrlString: urlString];
}

+ (void)server_suspendDownloadingWithUrlString:(NSString *)urlString {
    [kNHFileDownloadManager suspendDownloadingWithUrlString: urlString];
}

@end
