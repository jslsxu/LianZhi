//
//  NSString+UrlParams.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/3/25.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UrlParams)
+ (NSString *)appendUrl:(NSString *)url withParams:(NSDictionary *)params;
@end
