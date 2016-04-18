//
//  NSString+UrlParams.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/3/25.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NSString+UrlParams.h"

@implementation NSString (UrlParams)
+ (NSString *)appendUrl:(NSString *)url withParams:(NSDictionary *)params
{
    NSArray *components = [url componentsSeparatedByString:@"?"];
    NSString *rootUrl = components[0];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    if(components.count == 2)
    {
        NSString *paramsString = components[1];
        NSArray *originalParams = [paramsString componentsSeparatedByString:@"&"];
        for (NSString *paramItemString in originalParams) {
            NSArray *paramPair = [paramItemString componentsSeparatedByString:@"="];
            if(paramPair.count >= 2)
            {
                [paramsDic setValue:paramPair[1] forKey:paramPair[0]];
            }
        }
        for (NSString *key in params.allKeys) {
            [paramsDic setValue:params[key] forKey:key];
        }
    }
    NSMutableString *resultString = [[NSMutableString alloc] initWithString:rootUrl];
    if(paramsDic.allKeys.count > 0)
    {
        [resultString appendString:@"?"];
        for (NSString *key in paramsDic.allKeys) {
            [resultString appendFormat:@"%@=%@&",key,paramsDic[key]];
        }
    }
    return resultString;
}
@end
