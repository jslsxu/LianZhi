//
//  LZVideoCacheManager.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/11.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"

@interface LZVideoCacheManager : TNBaseObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(LZVideoCacheManager)
/**
 key为网络url
 */
+ (BOOL)isRemoteUrl:(NSString *)url;
+ (BOOL)videoExistForKey:(NSString *)key;
+ (NSString *)videoPathForKey:(NSString *)key;
+ (void)videoForUrl:(NSString *)url progress:(void (^)(CGFloat progress))progressBlk  complete:(void (^)(NSURL *url))completion fail:(void (^)(NSError *error))fail;
@end
