//
//  NHFileManager.h
//  NHFileDownloadManager-demo
//
//  Created by Wilson Yuan on 15/11/18.
//  Copyright © 2015年 Wilson-Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const NHFIleManagerAmrExtensionKey = @"amr";
static NSString *const NHFIleManagerWavExtensionKey = @"wav";
static NSString *const LZCache = @"LZCache";

@interface NHFileManager : NSObject

+ (NSString *)documentPath;

+ (NSString *)localCachePath;       //本地缓存文件，以后可删除的

+ (NSString *)applicationStoragePath;
/**
 这部分是多媒体缓存，公共缓存
 */
+ (NSString *)localMediaDataCachePath;  //本地图片，视频，音频等数据缓存

+ (NSString *)localImageCachePath;  //本地图片缓存文件

+ (NSString *)localAudioCachePath;          //本地音频缓存

+ (NSString *)localVideoCachePath;          //本地视频缓存


//和用户相关的缓存
+ (NSString *)localUserPath;

+ (NSString *)localCurrentUserCachePath;        //当前用户缓存目录

+ (NSString *)localCurrentUserStoragePath;      //当前用户storage文件

+ (NSString *)localCurrentUserConversationCachePath;    //当前用户聊天记录缓存地址

+ (NSString *)localCurrentUserRequestCachePath;         //当前用户网络请求缓存地址

+ (NSString *)getTmpRecordPath;                             //录音的临时路径
+ (NSString *)getTmpVideoPath;                              //视频临时路径
+ (NSString *)getTmpImagePath;                              //图片临时路径

+ (NSDictionary *)attribuateOfItemAtPath:(NSString *)path;

+ (NSString *)tmpVideoPathForPath:(NSString *)path;

+ (NSUInteger)fileSizeAtPath:(NSString *)filePath;

+ (void)totalCacheSizeWithCompletion:(void (^)(NSInteger totalSize))completion;

+ (void)cleanCacheWithCompletion:(void (^)())completion;

+ (BOOL)existsItemAtPath:(NSString *)path;


/**
 *  获取文的相对路径
 *  if : absolute path =
 *  @param absolutePath 绝对路径
 *
 *  @return 相对路径
 */
+ (NSString *)fileRelativePathForAbsolutePath:(NSString *)absolutePath;

/**
 *  获取文件的当前绝对路径
 *
 *  @param relativePath 文件相对路径
 *
 *  @return 当前绝对路径 ->#warning: 绝对路径会因启动而变化, 不要缓存绝对路径
 */
+ (NSString *)fileAbsolutePathForRelativePath:(NSString *)relativePath;

+ (NSArray *)listDirectoriesInDirectoryAtPath:(NSString *)path;
+ (NSArray *)listDirectoriesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep;

+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path;
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep;

+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension;
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension deep:(BOOL)deep;

+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix;
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix deep:(BOOL)deep;

+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix;
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix deep:(BOOL)deep;

+ (BOOL)createFileAtPath:(NSString *)path;
+ (BOOL)createFileAtPath:(NSString *)path error:(NSError **)error;

+ (BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content;
+ (BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content error:(NSError **)error;

+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath;
+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError **)error;

+ (BOOL)removeItemAtPath:(NSString *)path;
+ (BOOL)removeItemAtPath:(NSString *)path error:(NSError **)error;

+ (BOOL)createDirectoriesForPath:(NSString *)path;


/**
 *	删除指定路径文件夹中的__MACOSX 文件夹
 *
 *	@param path	文件夹路径
 */
+ (void)removeMACOSXDirectoryForDirectoryPath:(NSString *)path;
@end

#pragma mark - Category NHUser

@interface NHFileManager (NHUser)


+ (NSString *)currentUserDirectoryPath;


@end

#pragma mark - Category NHAudioTool
@interface NHFileManager (NHAudioTool)

/**
 *  获得录音文件的相对路径
 *
 *  @param absolutePath 绝对路径
 *
 *  @return 当前相对路径
 */
+ (NSString *)audioFileRelativePathForAbsolutePath:(NSString *)absolutePath;
/**
 *  获取录音文件的绝对路径
 *
 *  @param relativePath 相对路径
 *
 *  @return 绝对路径 ->#warning: 绝对路径会因启动而变化, 不要缓存绝对路径
 */
+ (NSString *)audioFileAbsolutePathForRelativePath:(NSString *)relativePath;

@end

#pragma mark - Category NHFileServer
@interface NHFileManager (NHFileServer)

/**
 *  获取文件下载成功后的相对路径
 *
 *  @param absolutePath 当前绝对路径
 *
 *  @return 相对路径
 */
+ (NSString *)serverFileRelativePathForAbsolutePath:(NSString *)absolutePath;

/**
 *  获取 FileServer 相关文件的当前绝对路径
 *
 *  @param relativePath 相对路径
 *
 *  @return 绝对路径 ->#warning: 绝对路径会因启动而变化, 不要缓存绝对路径
 */
+ (NSString *)serverFileAbsolutePathForRelativePath:(NSString *)relativePath;

@end

#pragma mark - Category NHFileCache

@interface NHFileManager (NHFileCache)

/**
 *  获取cache相关文件的相对路径
 *
 *  @param absolutePath 当前绝对路径
 *
 *  @return 相对路径
 */
+ (NSString *)cacheFileRelativePathForAbsolutePath:(NSString *)absolutePath;

/**
 *  获取 cache 相关文件的当前绝对路径
 *
 *  @param relativePath 相对路径
 *
 *  @return 绝对路径 ->#warning: 绝对路径会因启动而变化, 不要缓存绝对路径
 */
+ (NSString *)cacheFileAbsolutePathForRelativePath:(NSString *)relativePath;

@end


static NSString *kNHMiddleEmojiWidthKey = @"width";
static NSString *kNHMiddleEmojiHeightKey = @"height";
static NSString *kNHMiddleEmojiBundleNameKey = @"bundle_name";
static NSString *kNHMiddleEmojiBundleIDKey = @"bundle_id";
static NSString *kNHMiddleEmojiItemIDKey = @"item_id";
static NSString *kNHMiddleEmojiItemNameKey = @"item_name";
static NSString *kNHMiddleEmojiItemTypeKey = @"item_type";
#pragma mark - Category NHEmojiManager
@interface NHFileManager (NHEmojiManager)

/**
 *  获得Bundle 中的表情数组
 *
 *  @param bundleName 表情bundle 名称
 *  @param type       表情类型
 *
 *  @return 所有表情的路径数组
 */
+ (NSArray *)emojiArrayForBundleName:(NSString *)bundleName resourcesOftype:(NSString *)type;

/**
 *  根据信息来获取表情的bundle 绝对路径
 *
 *  @param contentInfo 表情信息
 "w": 400,
 "h": 300,
 "bundle_type": "0"
 "bundle_name": "ali",
 "bundle_id": "0"
 "item_id": "23"
 "item_name": "23.gif"
 "item_url": ""
 "item_type" : @"gif"
 *
 *  @return 当前表情的绝对路径
 */
+ (NSString *)middleEmojiAbsolutePathForEmojiContent:(NSDictionary *)contentInfo;

/**
 *  获得表情数据
 *
 *  @param contentInfo 表情配置信息
 *
 *  @return 表情数据
 */
+ (NSData *)middleEmojiDataForContentInfo:(NSDictionary *)contentInfo;

@end

#pragma mark - Category NHFileManager
@interface NHFileManager (ServersUtils)

+ (NSString *)utilsLocalServersCachePath;

+ (NSString *)utilsLocalConfigurePlistFilePath;

+ (NSString *)utilsPraise_imgParamKeyDirectoriesPath;

+ (NSString *)utilsPraisedImageDirectoriesPathForTime:(NSString *)endTime;

//+ (NSArray *)utilsPraiseImageFiles;


@end


@interface NHFileManager (Upload)

///放置需要上传文件的路径
+ (NSString *)uploadDirectoryPath;

+ (NSString *)uploadFileRelativePathForAbsolutePath:(NSString *)absolutePath;
+ (NSString *)uploadFileAbsolutePathForRelativePath:(NSString *)relativePath;

@end

@interface NHFileManager (ImageCache)

+ (NSString *)imageCachedDirectoryPath;

@end

#pragma mark - Category Deprecated
@interface NHFileManager (Deprecated)

/**
 *  如果前面有Document路径,则会删除包括Document路径之前路径
 *  得到相对路径 ->Document/之后的路径
 *
 *  @param path 原路径
 *
 *  @return 相对路径
 */
+ (NSString *)removeDocumentPathIfNeed:(NSString *)path __deprecated_msg("Method deprecated, Use fileRelativePathForAbsolutePath: method");

/**
 *  如果签名木有Document路径, 则会拼接上Document路径
 *
 *  @param path 文件夹路径
 *
 *  @return 当前文件的绝对路径 ->#warning: 绝对路径会因启动而变化, 不要缓存绝对路径
 */
+ (NSString *)appendingDocumentPathIfNeed:(NSString *)path __deprecated_msg("Method deprecated, UsefileAbsolutePathForRelativePath: method");
@end
