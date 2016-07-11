//
//  NSString+UUID.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/6/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NSString+UUID.h"

@implementation NSString (UUID)
+ (NSString*)uuidStr {
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    NSString *guid = [(__bridge_transfer NSString *)newUniqueIDString copy];
    
    CFRelease(newUniqueID);
    
    return([guid lowercaseString]);
}
@end
