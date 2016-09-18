//
//  NHFileDownloadSession.h
//  NHFileDownloadManager-demo
//
//  Created by Wilson Yuan on 15/11/17.
//  Copyright © 2015年 Wilson-Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NHFileDownloadHeader.h"

@interface NHFileDownloadSession : NSObject

@property (strong, readonly, nonatomic) NSURLResponse *response;

@property (strong, readonly, nonatomic) NSURLRequest *urlRequest;

@property (strong, readonly, nonatomic) AFURLSessionManager *manager;

@property (copy, nonatomic) SuccessBlock completionHandler;

@property (copy, nonatomic) FailureBlock failureHandler;

@property (copy, nonatomic) ProgressBlock progressHandler;

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration;


/**
 *  下载文件调用方法
 *
 *  @param requset           请求对象
 *  @param path              这里是文件存放的文件夹路径
 *  @param progressHandler   下载进度回调
 *  @param completionHanlder 下载成功后回调
 *  @param failureHandler    下载失败后回调
 *
 *  @return NSURLSessionDownloadTask instance type
 */
- (NSURLSessionDownloadTask *)downloadFileWithRequest:(NSURLRequest *)requset
                                       distinationUrl:(NSURL *)path
                                             progress:(ProgressBlock)progressHandler
                                           completion:(SuccessBlock)completionHanlder
                                              failure:(FailureBlock)failureHandler;

- (void)cancel;

- (void)suspend;

- (void)resume;

@end
