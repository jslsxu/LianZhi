//
//  AFHTTPRequestOperation+Associative.h
//  TNFoundation
//
//  Created by jslsxu on 14-9-5.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "AFHTTPRequestOperation.h"

typedef NS_ENUM(NSInteger, REQUEST_METHOD) {
    REQUEST_GET = 0,
    REQUEST_POST
};

typedef NS_ENUM(NSInteger, REQUEST_TYPE) {
    REQUEST_NONE = -1,
    REQUEST_REFRESH,
    REQUEST_GETMORE
};


@interface AFHTTPRequestOperation (Associative)
@property (nonatomic, weak)id observer;
@property (nonatomic, copy)NSString *category;
@property (nonatomic, assign)REQUEST_METHOD requestMethod;
@property (nonatomic, assign)REQUEST_TYPE requestType;
@end
