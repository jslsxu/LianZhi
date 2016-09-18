//
//  NHFileDownloadManager.h
//  NHFileDownloadManager-demo
//
//  Created by Wilson Yuan on 15/11/17.
//  Copyright © 2015年 Wilson-Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NHFileDownloadHeader.h"



#define kNHFileDownloadManager [NHFileDownloadManager sharedInstance]

@class NHFileDownloadSession;
@interface NHFileDownloadManager : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(NHFileDownloadManager)

/**
 *  下载文件方法
 *
 *  @param string          urlString
 *  @param progressHandler 下载文件进度回调
 *  @param successHandler  下载成功回调
 *  @param failureHandler  下载失败回调
 *
 *  @return NHFileDownloadSession instance
 */
- (NHFileDownloadSession *)downloadWithUrlStirng:(NSString *)string
                                        progress:(ProgressBlock)progressHandler
                                         success:(SuccessBlock)successHandler
                                         failure:(FailureBlock)failureHandler;

/**
 *  下载文件方法
 *
 *  @param string          urlString
 *  @param cachePathString 下载文件cache路径
 *  @param progressHandler 下载文件进度回调
 *  @param successHandler  下载成功回调
 *  @param failureHandler  下载失败回调
 *
 *  @return NHFileDownloadSession instance
 */
- (NHFileDownloadSession *)downloadWithUrlStirng:(NSString *)string
                                        cachePathString:(NSString *)cachePathString
                                        progress:(ProgressBlock)progressHandler
                                         success:(SuccessBlock)successHandler
                                         failure:(FailureBlock)failureHandler;


- (BOOL)isProcessingWithUrlString:(NSString *)string;

- (void)cancelDownloadingWithUrlString:(NSString *)urlString;

- (void)suspendDownloadingWithUrlString:(NSString *)urlString;

@end
