//
//  NSString+JSONObject.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/19.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSONObject)
+ (NSString *)stringWithJSONObject:(id)object;
+ (NSData *)dataWithJSONObject:(id)object;
@end
