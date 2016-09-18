//
//  Utility.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/26.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface Utility : NSObject
+ (NSString *)formatStringForTime:(NSInteger)timeInterval;
+ (NSUInteger)sizeAtPath:(NSString *)filePath diskMode:(BOOL)diskMode;
+ (NSString *)sizeStrForSize:(long long)size;
+ (AVAsset *)avAssetFromALAsset:(ALAsset *)alasset;
+ (NSString *)weekdayStr:(NSDate *)date;
+ (void)saveImageToAlbum:(UIImage *)image;
+ (void)saveVideoToAlbum:(NSString *)videoPath;
+ (BOOL)checkVideoSize:(long long)size;
+ (BOOL)checkVideo:(ALAsset *)asset;
+ (NSString *)durationText:(NSInteger)duration;
@end
