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
+ (NSString *)sizeStrForSize:(NSInteger)size;
+ (AVAsset *)avAssetFromALAsset:(ALAsset *)alasset;
@end
