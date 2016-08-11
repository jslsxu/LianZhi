//
//  NHFileCache.h
//  NHFileDownloadManager-demo
//
//  Created by Wilson Yuan on 15/11/19.
//  Copyright © 2015年 Wilson-Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NHFileDownloadHeader.h"

#define kNHFileCache [NHFileCache sharedInstance]
@interface NHFileCache : NSObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(NHFileCache)

/**
 *  获得缓存信息 如果木有缓存, 则返回nil
 *
 *  @param key       缓存时用的key
 *  @param doneBlock 完成回调
 */
- (void)queryCacheForKey:(NSString *)key done:(void(^)(NSDictionary *fileInfo))doneBlock;

/**
 *  缓存数据
 *
 *  @param object 缓存对象
 *  @param key    key
 */
- (void)cacheObject:(id<NSCoding>)object forKey:(id)key;

/**
 *  返回缓存的对象
 *
 *  @param key key
 *
 *  @return 缓存中的对象, 如果木有则返回 nil
 */
- (id)objectForKey:(id)key;


/**
 *  返回下载文件的信息
 *  如果文件是amr的则会转码,然后返回wav的地址信息
 *  @param filePath path
 *  @param key      用于做缓存的key
 *  @param done     获取文件信息成功后回调
 */
- (void)fileInfoAtPath:(NSString *)filePath cacheForKey:(NSString *)key done:(void(^)(NSDictionary *info))doneBlock;
@end
