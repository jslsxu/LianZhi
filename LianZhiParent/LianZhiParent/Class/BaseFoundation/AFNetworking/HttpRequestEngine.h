//
//  HttpRequestEngine.h
//  TNFoundation
//
//  Created by jslsxu on 14-9-6.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFHTTPRequestOperation+Associative.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "HttpRequestEngine.h"
#import "SynthesizeSingleton.h"
#import "TNDataWrapper.h"

@interface HttpRequestTask : NSObject
@property (nonatomic, copy)NSString *requestUrl;
@property (nonatomic, strong)NSDictionary *params;
@property (nonatomic, weak)id observer;
@property (nonatomic, assign)REQUEST_TYPE requestType;
@property (nonatomic, assign)REQUEST_METHOD requestMethod;

@end


typedef BOOL(^CommonHandleBlk)(TNDataWrapper *responseData);
typedef void(^CommonParamsBlk)(NSMutableDictionary *commonParams);
@interface HttpRequestEngine : NSObject
{
    AFHTTPRequestOperationManager *_manager;
    AFHTTPSessionManager*           _sessionManager;
}
@property (nonatomic, copy)NSString *commonCacheRoot;
@property (nonatomic, copy)NSString *baseUrl;
@property (nonatomic, copy)CommonHandleBlk commonHandleBlk;
@property (nonatomic, copy)CommonParamsBlk commonParamsBlk;
@property (nonatomic, readonly)AFHTTPRequestOperationManager *manager;
@property (nonatomic, readonly)AFHTTPSessionManager *sessionManager;
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(HttpRequestEngine)

- (void)cancelTaskByObserver:(id)observer;
- (void)cancelTaskByCategory:(NSString *)category;
- (AFHTTPRequestOperation *)makeRequestFromUrl:(NSString *)urlStr
                                        method:(REQUEST_METHOD)method
                                          type:(REQUEST_TYPE)type
                                    withParams:(NSDictionary *)params
                                      observer:(id)observer
                                    completion:(void (^)(AFHTTPRequestOperation *operation,TNDataWrapper *responseObject))success
                                          fail:(void (^)(NSString *errMsg))fail;
- (AFHTTPRequestOperation *)makeRequestFromUrl:(NSString *)urlStr
                                    withParams:(NSDictionary *)params
                     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                    completion:(void (^)(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject))success
                                          fail:(void (^)(NSString *errMsg))fail;
- (NSURLSessionDataTask *)makeSessionRequestFromUrl:(NSString *)urlStr
                                  withParams:(NSDictionary *)params
                    constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                  completion:(void (^)(NSURLSessionDataTask *task, TNDataWrapper *responseObject))success
                                        fail:(void (^)(NSString *errMsg))fail;
- (void)cancelAllTask;
@end
