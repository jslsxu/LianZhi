//
//  NSString+JSONObject.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/19.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "NSString+JSONObject.h"

@implementation NSString (JSONObject)
+ (NSString *)stringWithJSONObject:(id)object
{
    return [[NSString alloc] initWithData:[self dataWithJSONObject:object] encoding:NSUTF8StringEncoding];
}

+ (NSData *)dataWithJSONObject:(id)object
{
    return [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
}
@end
