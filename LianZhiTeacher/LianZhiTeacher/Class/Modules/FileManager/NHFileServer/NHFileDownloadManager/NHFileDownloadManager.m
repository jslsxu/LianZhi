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

#import "YYCache.h"


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
        @weakify(self)
        SuccessBlock completionBlk = ^(NSURL *fileUrl){
            if(successHandler){
                successHandler(fileUrl);
            }
            @strongify(self)
            [self.downLoadTasks removeObjectForKey: string];
        };
        FailureBlock failBlk = ^(NSError *error){
            if(failureHandler){
                failureHandler(error);
            }
            @strongify(self)
            [self.downLoadTasks removeObjectForKey: string];
        };
        [session setProgressHandler:progressHandler];
        [session setCompletionHandler:completionBlk];
        [session setFailureHandler:failBlk];
        [session resume];
        return session;
    }
    else {
        NHFileDownloadSession *session = [[NHFileDownloadSession alloc] init];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
        
        //文件路径
        NSURL *url = [NSURL fileURLWithPath: cachePathString];
        
        [session downloadFileWithRequest:request distinationUrl:url progress:progressHandler completion:^(NSURL *fileUrl) {
            if(successHandler){
                successHandler(fileUrl);
            }
            [self.downLoadTasks removeObjectForKey: string];
            
        } failure:^(NSError *error){
            if(failureHandler){
                failureHandler(error);
            }
            [self.downLoadTasks removeObjectForKey: string];
        }];
        
        [self.downLoadTasks setObject: session forKey: string];
        
        return session;
    }
}

- (BOOL)isProcessingWithUrlString:(NSString *)string{
    NHFileDownloadSession *session = self.downLoadTasks[string];
    return (session != nil);
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
