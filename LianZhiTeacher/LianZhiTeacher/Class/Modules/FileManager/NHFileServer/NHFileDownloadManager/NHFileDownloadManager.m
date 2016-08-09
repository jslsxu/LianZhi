//
//  NHFileDownloadManager.m
//  NHFileDownloadManager-demo
//
//  Created by Wilson Yuan on 15/11/17.
//  Copyright © 2015年 Wilson-Yuan. All rights reserved.
//

#import "NHFileDownloadManager.h"
#import "NHFileDownloadSession.h"
#import "NHFileManager.h"

#import <YYCache.h>


@interface NHFileDownloadManager ()

//@property (strong, nonatomic) NSMutableArray *downLoadTasks;
@property (strong, nonatomic) NSMutableDictionary *downLoadTasks;


@end

@implementation NHFileDownloadManager

SYNTHESIZE_SINGLETON_FOR_CLASS(NHFileDownloadManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.downLoadTasks = [NSMutableDictionary dictionary];
    }
    return self;
}
//如果未存在, 则要下载
- (NHFileDownloadSession *)downloadWithUrlStirng:(NSString *)string
                                          progress:(ProgressBlock)progressHandler
                                           success:(SuccessBlock)successHandler
                                           failure:(FailureBlock)failureHandler {
    return [self downloadWithUrlStirng: string cachePathString: [NHFileManager localCachePath] progress: progressHandler success: successHandler failure: failureHandler];
}

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
                                         failure:(FailureBlock)failureHandler {
    if (!string) {
        return nil;
    }
    
    NHFileDownloadSession *session = self.downLoadTasks[string];
    if (session) {
        [session resume];
        return session;
    }
    else {
        NHFileDownloadSession *session = [[NHFileDownloadSession alloc] init];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
        
        //文件路径
        NSURL *url = [NSURL fileURLWithPath: cachePathString];
        
        [session downloadFileWithRequest:request distinationUrl:url progress:progressHandler completion:^(NSURL *fileUrl) {
            successHandler(fileUrl);
            [self.downLoadTasks removeObjectForKey: string];
            
        } failure:failureHandler];
        
        [self.downLoadTasks setObject: session forKey: string];
        
        return session;
    }
}

- (void)cancelDownloadingWithUrlString:(NSString *)urlString {
    if (urlString && [urlString isKindOfClass: [NSString class]] && [urlString length] > 0) {
        NHFileDownloadSession *session = self.downLoadTasks[urlString];
        [session cancel];
    }
}

- (void)suspendDownloadingWithUrlString:(NSString *)urlString {
    if (urlString && [urlString isKindOfClass: [NSString class]] && [urlString length] > 0) {
        NHFileDownloadSession *session = self.downLoadTasks[urlString];
        [session suspend];
    }
}

@end
