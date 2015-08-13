//
//  AFHTTPRequestOperation+Associative.m
//  TNFoundation
//
//  Created by jslsxu on 14-9-5.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "AFHTTPRequestOperation+Associative.h"
#import <objc/runtime.h> 


@implementation AFHTTPRequestOperation (Associative)
static char observerKey, categoryKey, requestMethodKey, requestTypeKey;

- (void)setObserver:(id)observer
{
    objc_setAssociatedObject(self, &observerKey, observer, OBJC_ASSOCIATION_ASSIGN);
}

- (id)observer
{
    return objc_getAssociatedObject(self, &observerKey);
}

- (void)setCategory:(NSString *)category
{
    objc_setAssociatedObject(self, &categoryKey, category, OBJC_ASSOCIATION_COPY);
}

- (NSString *)category
{
    return objc_getAssociatedObject(self, &categoryKey);
}

- (void)setRequestMethod:(REQUEST_METHOD)requestMethod
{
    objc_setAssociatedObject(self, &requestMethodKey, @(requestMethod), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (REQUEST_METHOD)requestMethod
{
    NSNumber *methodNumber = objc_getAssociatedObject(self, &requestMethodKey);
    return [methodNumber integerValue];
}

- (void)setRequestType:(REQUEST_TYPE)requestType
{
    objc_setAssociatedObject(self, &requestTypeKey, @(requestType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (REQUEST_TYPE)requestType
{
    NSNumber *methodNumber = objc_getAssociatedObject(self, &requestTypeKey);
    return [methodNumber integerValue];
}

@end
