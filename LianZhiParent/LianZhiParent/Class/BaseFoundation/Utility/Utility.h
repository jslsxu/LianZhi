//
//  Utility.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/26.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject
+ (NSString *)formatStringForTime:(NSInteger)timeInterval;
+ (NSString *)sizeAtPath:(NSString *)filePath diskMode:(BOOL)diskMode;
+ (NSString *)weekdayNameForIndex:(NSInteger)day;
+ (NSString *)weekdayStrForSelectedArray:(NSArray *)selectedArray;
+ (NSString *)timeForOffsetTimeInterval:(NSInteger)timeInterval;
+ (NSString *)md5String:(NSString *)str;
+ (NSString *)formatStringWithTimeInterval:(NSInteger)timeInterval;
+ (BOOL)isPhotoLibraryActive;
@end
