//
//  NSFileServer.h
//  NHFileDownloadManager-demo
//
//  Created by Wilson Yuan on 15/11/19.
//  Copyright © 2015年 Wilson-Yuan. All rights reserved.
//

/**
 *  用来统一管理文件下载
 */
#import <Foundation/Foundation.h>
#import "NHFileDownloadHeader.h"
#import "NHFileManager.h"

typedef void (^ServerSuccessBlock) (NSDictionary *fileInfo);

@interface NHFileServer : NSObject
/**
 *  获取文件信息方法
 *  优先检查是否有缓存, 无缓存后, 就会走下载方法
 *  @param urlString       连接地址
 *  @param progressHandler 进度回调
 *  @param successHandler  成功回调
 *  @param failureHandler  失败回调
 */
+ (void)server_fileInfoWithUrlString:(NSString *)urlString
                            progress:(ProgressBlock)progressHandler
                             success:(ServerSuccessBlock)successHandler
                             failure:(FailureBlock)failureHandler;

/**
 *  查询是否存在文件
 *
 *  @param urlString 连接地址
 *  @param doneBlock 文件存在 exist则返回YES 和 fileInfo
 */
+ (void)server_queryFileExistWithUrlString:(NSString *)urlString done:(void(^)(BOOL exist, NSDictionary *fileInfo))doneBlock;

/**
 *  下载文件->如果文件存在,则会覆盖掉之前文件
 *
 *  @param urlString       连接地址
 *  @param progressHandler 进度回调
 *  @param successHandler  成功回调
 *  @param failureHandler  失败回调
 */
+ (void)server_downloadFileWithUrlString:(NSString *)urlString
                                progress:(ProgressBlock)progressHandler
                                 success:(ServerSuccessBlock)successHandler
                                 failure:(FailureBlock)failureHandler;

+ (void)server_cancelDownloadingWithUrlString:(NSString *)urlString;

+ (void)server_suspendDownloadingWithUrlString:(NSString *)urlString;

@end
