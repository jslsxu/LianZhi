//
//  HttpRequestEngine.m
//  TNFoundation
//
//  Created by jslsxu on 14-9-6.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "HttpRequestEngine.h"

@implementation HttpRequestTask

@end

@implementation HttpRequestEngine
SYNTHESIZE_SINGLETON_FOR_CLASS(HttpRequestEngine)

- (id)init
{
    self = [super init];
    if(self)
    {
        _manager = [[AFHTTPRequestOperationManager alloc] init];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        _sessionManager = [[AFHTTPSessionManager alloc] init];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    return self;
}

- (void)setBaseUrl:(NSString *)baseUrl
{
    _baseUrl = baseUrl;
    _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:_baseUrl]];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:_baseUrl]];
}

- (AFHTTPRequestOperation *)makeRequestFromUrl:(NSString *)urlStr
                                        method:(REQUEST_METHOD)method
                                          type:(REQUEST_TYPE)type
                                    withParams:(NSDictionary *)params
                                      observer:(id)observer
                                    completion:(void (^)(AFHTTPRequestOperation *operation, TNDataWrapper* responseObject))success
                                          fail:(void (^)(NSString *errMsg))fail
{
    AFHTTPRequestOperation *operation = nil;
    NSDictionary *valueParams = [self addPublicParams:params];
    if(method == REQUEST_GET)
    {
        operation = [_manager GET:urlStr parameters:valueParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            TNDataWrapper *responseWrapper = [TNDataWrapper dataWrapperWithObject:responseObject];
            BOOL handleNormal = YES;
            if(self.commonHandleBlk)
                handleNormal = self.commonHandleBlk(responseWrapper);
            if(handleNormal)
            {
                if([responseWrapper getIntegerForKey:@"err_code"] == 0)
                {
                    TNDataWrapper *data = [responseWrapper getDataWrapperForKey:@"data"];
                    if(success)
                        success(operation, data);
                }
                else
                {
                    if(fail && ![urlStr isEqualToString:@"sms/get"])
                    {
                        NSString *errmsg = [responseWrapper getStringForKey:@"err_msg"];
                        if([errmsg isEqualToString:@"系统故障，请联系管理员或稍后重试"])
                            errmsg = nil;
                        fail(errmsg);
                    }
                }
            }
            else
            {
                if(fail && ![urlStr isEqualToString:@"sms/get"])
                {
                    NSString *errmsg = [responseWrapper getStringForKey:@"err_msg"];
                    if([errmsg isEqualToString:@"系统故障，请联系管理员或稍后重试"])
                        errmsg = nil;
                    fail(errmsg);
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail)
                fail(@"网络请求失败");
        }];
    }
    else
    {
        operation = [_manager POST:urlStr parameters:valueParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            TNDataWrapper *responseWrapper = [TNDataWrapper dataWrapperWithObject:responseObject];
            BOOL handleNormal = YES;
            if(self.commonHandleBlk)
                handleNormal = self.commonHandleBlk(responseWrapper);
            if(handleNormal)
            {
                if([responseWrapper getIntegerForKey:@"err_code"] == 0)
                {
                    TNDataWrapper *data = [responseWrapper getDataWrapperForKey:@"data"];
                    if(success)
                        success(operation,data);
                }
                else
                {
                    if(fail)
                    {
                        NSString *errmsg = [responseWrapper getStringForKey:@"err_msg"];
                        if([errmsg isEqualToString:@"系统故障，请联系管理员或稍后重试"])
                            errmsg = nil;
                        fail(errmsg);
                    }
                }
            }
            else
            {
                if(fail)
                {
                    NSString *errmsg = [responseWrapper getStringForKey:@"err_msg"];
                    if([errmsg isEqualToString:@"系统故障，请联系管理员或稍后重试"])
                        errmsg = nil;
                    fail(errmsg);
                }
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail)
                fail(@"网络请求失败");
        }];
    }
    
    [operation setObserver:observer];
    [operation setRequestMethod:method];
    [operation setRequestType:type];
    return operation;
}

- (AFHTTPRequestOperation *)makeRequestFromUrl:(NSString *)urlStr
                                    withParams:(NSDictionary *)params
                     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                    completion:(void (^)(AFHTTPRequestOperation *, TNDataWrapper *))success
                                          fail:(void (^)(NSString *))fail
{
     NSDictionary *valueParams = [self addPublicParams:params];
    AFHTTPRequestOperation *operation = [_manager POST:urlStr parameters:valueParams constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TNDataWrapper *responseWrapper = [TNDataWrapper dataWrapperWithObject:responseObject];
        BOOL handleNormal = YES;
        if(self.commonHandleBlk)
            handleNormal = self.commonHandleBlk(responseWrapper);
        if(handleNormal)
        {
            if([responseWrapper getIntegerForKey:@"err_code"] == 0)
            {
                TNDataWrapper *data = [responseWrapper getDataWrapperForKey:@"data"];
                if(success)
                    success(operation,data);
            }
            else
            {
                if(fail)
                {
                    NSString *errmsg = [responseWrapper getStringForKey:@"err_msg"];
                    if([errmsg isEqualToString:@"系统故障，请联系管理员或稍后重试"])
                        errmsg = nil;
                    fail(errmsg);
                }
            }
        }
        else
        {
            if(fail)
            {
                NSString *errmsg = [responseWrapper getStringForKey:@"err_msg"];
                if([errmsg isEqualToString:@"系统故障，请联系管理员或稍后重试"])
                    errmsg = nil;
                fail(errmsg);
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(fail)
            fail(@"网络请求失败");
    }];
    return operation;
}

- (NSURLSessionDataTask *)makeSessionRequestFromUrl:(NSString *)urlStr
                                  withParams:(NSDictionary *)params
                    constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                  completion:(void (^)(NSURLSessionDataTask *task, TNDataWrapper *responseObject))success
                                        fail:(void (^)(NSString *errMsg))fail
{
     NSDictionary *valueParams = [self addPublicParams:params];
    NSURLSessionDataTask *task = [_sessionManager POST:urlStr parameters:valueParams constructingBodyWithBlock:block success:^(NSURLSessionDataTask *task, id responseObject) {
        TNDataWrapper *responseWrapper = [TNDataWrapper dataWrapperWithObject:responseObject];
        BOOL handleNormal = YES;
        if(self.commonHandleBlk)
            handleNormal = self.commonHandleBlk(responseWrapper);
        if(handleNormal)
        {
            if([responseWrapper getIntegerForKey:@"err_code"] == 0)
            {
                TNDataWrapper *data = [responseWrapper getDataWrapperForKey:@"data"];
                if(success)
                    success(task,data);
            }
            else
            {
                if(fail)
                {
                    NSString *errmsg = [responseWrapper getStringForKey:@"err_msg"];
                    if([errmsg isEqualToString:@"系统故障，请联系管理员或稍后重试"])
                        errmsg = nil;
                    fail(errmsg);
                }
            }
        }
        else
        {
            if(fail)
            {
                NSString *errmsg = [responseWrapper getStringForKey:@"err_msg"];
                if([errmsg isEqualToString:@"系统故障，请联系管理员或稍后重试"])
                    errmsg = nil;
                fail(errmsg);
            }
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(fail)
            fail(@"网络请求失败");
    }];
    return task;
}

- (void)cancelTaskByObserver:(id)observer
{
    @synchronized(_manager)
    {
        for (AFHTTPRequestOperation *operation in _manager.operationQueue.operations) {
            if([operation.observer isEqual:observer] && REQUEST_POST != operation.requestMethod)
            {
                NSLog(@"Task canceled");
                [operation cancel];
            }
        }
    }
}
- (void)cancelTaskByCategory:(NSString *)category
{
    @synchronized(_manager)
    {
        for (AFHTTPRequestOperation *operation in _manager.operationQueue.operations) {
            if([operation.category isEqualToString:category] && REQUEST_POST != operation.requestMethod)
                [operation cancel];
        }
    }
}

- (NSDictionary *)addPublicParams:(NSDictionary *)params
{
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithDictionary:params];
    //添加公共参数，或者对参数进行规范
    [resultDic setValue:[OpenUDID value] forKey:@"udid"];
//    [resultDic setValue:[UserCenter sharedInstance].accessToken forKey:@"token"];
    if(self.commonParamsBlk)
        self.commonParamsBlk(resultDic);
    return resultDic;
}

- (void)cancelAllTask{
    for (AFHTTPRequestOperation *operation in _manager.operationQueue.operations) {
        [operation cancel];
    }
}
@end
