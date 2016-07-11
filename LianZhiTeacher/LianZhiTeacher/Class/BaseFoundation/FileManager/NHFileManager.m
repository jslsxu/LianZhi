//
//  NHFileManager.m
//  NHFileDownloadManager-demo
//
//  Created by Wilson Yuan on 15/11/18.
//  Copyright © 2015年 Wilson-Yuan. All rights reserved.
//

#import "NHFileManager.h"
#import <FCFileManager.h>
#import "UserCenter.h"


static NSString *kNHFileManagerChatDirectoryName = @"Chat/";
static NSString *kNHFileManagerUploadDirectoryName = @"Upload/";
static NSString *kNHFileManagerImageCacheDirectoryName = @"ImageCache/";
static NSString *kLocalCachePath = @"LocalCache";
static NSString *kLocalStorePath = @"LocalStore";

@implementation NHFileManager


+ (NSString *)documentPath {
    return [FCFileManager pathForDocumentsDirectory];
}

+ (NSString *)localCachePath
{
    NSString *cahcePath = [[self documentPath] stringByAppendingPathComponent:kLocalCachePath];
    if(![[NSFileManager defaultManager] fileExistsAtPath:cahcePath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:cahcePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return cahcePath;
}

+ (NSString *)localFilePath{
    NSString *localFilePath = [[self documentPath] stringByAppendingPathComponent:kLocalStorePath];
    if(![[NSFileManager defaultManager] fileExistsAtPath:localFilePath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:localFilePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return localFilePath;
}

//可以获得各个文件存放的文件夹的目录
+ (NSString *)chatDirectoryPathForUid:(NSString *)uid {
    //uid
    NSString *pathComponent = [[self uidDirectoryPathByUid:uid] stringByAppendingPathComponent:kNHFileManagerChatDirectoryName];
    
    if (![FCFileManager existsItemAtPath:pathComponent] ) {
        NSError *error;
        if ([FCFileManager createDirectoriesForPath:pathComponent error:&error] && !error) {
            NSLog(@"success created chat directory");
        }
        else {
            NSLog(@"chatDirectoryPathForUid: %@", error.description);
        }
    }
    return pathComponent;
}

+ (NSString *)uidDirectoryPathByUid:(NSString *)uid {
    NSString *chatDirectory = [FCFileManager pathForDocumentsDirectoryWithPath:uid];
    if (![FCFileManager existsItemAtPath:chatDirectory]) {
        NSError *error;
        if ([FCFileManager createDirectoriesForPath:chatDirectory error:&error] && !error) {
            NSLog(@"success created uid directory path");
        }
        else {
            NSLog(@"failure created uid directory path");
        }
    }
    return chatDirectory;
}

+ (NSDictionary *)attribuateOfItemAtPath:(NSString *)path {
    NSError *error;
    NSDictionary *attribuate = [FCFileManager attributesOfItemAtPath:path error:&error];
    if (error) {
        NSLog(@"%s, %@",__FUNCTION__, error.description);
    }
    return attribuate;
}

+ (NSString *)fileRelativePathForAbsolutePath:(NSString *)absolutePath {
    return [self _removeDocumentPathIfNeed:absolutePath];
}

+ (NSString *)fileAbsolutePathForRelativePath:(NSString *)relativePath {
    return [self _appendingDocumentPathIfNeed:relativePath];
}


+ (NSUInteger)fileSizeAtPath:(NSString *)filePath {
    
    if ([FCFileManager existsItemAtPath:filePath]) {
        NSError *error;
        NSDictionary *attributes = [FCFileManager attributesOfItemAtPath:filePath error:&error];
        return [[attributes objectForKey:NSFileSize] integerValue];
    }
    else {
        NSLog(@"File not exists");
        return 0;
    }

}
+ (BOOL)existsItemAtPath:(NSString *)path {
    return [FCFileManager existsItemAtPath:path];
}


+ (NSArray *)listDirectoriesInDirectoryAtPath:(NSString *)path {
    return [FCFileManager listDirectoriesInDirectoryAtPath:path];
}
+ (NSArray *)listDirectoriesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep {
    return [FCFileManager listDirectoriesInDirectoryAtPath:path deep:deep];
}

+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path {
    return [FCFileManager listFilesInDirectoryAtPath:path];
}
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep {
    return [FCFileManager listFilesInDirectoryAtPath:path deep:deep];
}

+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension {
    return [FCFileManager listFilesInDirectoryAtPath:path withExtension:extension];
}
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension deep:(BOOL)deep {
    return [FCFileManager listFilesInDirectoryAtPath:path withExtension:extension deep:deep];
}

+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix {
    return [FCFileManager listFilesInDirectoryAtPath:path withPrefix:prefix];
}
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix deep:(BOOL)deep {
    return [FCFileManager listFilesInDirectoryAtPath:path withPrefix:prefix deep:deep];
}

+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix {
    return [FCFileManager listFilesInDirectoryAtPath:path withSuffix:suffix];
}
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix deep:(BOOL)deep {
    return [FCFileManager listFilesInDirectoryAtPath:path withSuffix:suffix deep:deep];
}

+ (BOOL)removeItemAtPath:(NSString *)path {
    return [FCFileManager removeItemAtPath:path];
}

+ (BOOL)removeItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [FCFileManager removeItemAtPath:path error:error];
}

+ (BOOL)createDirectoriesForPath:(NSString *)path {
    return [FCFileManager createDirectoriesForPath:path];
}

+ (BOOL)createFileAtPath:(NSString *)path {
    return [FCFileManager createFileAtPath:path];
}
+ (BOOL)createFileAtPath:(NSString *)path error:(NSError **)error {
    return [FCFileManager createFileAtPath:path error:error];
}

+ (BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content {
    return [self createFileAtPath:path withContent:content error:nil];
}
+ (BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content error:(NSError **)error {
    return [FCFileManager createFileAtPath:path withContent:content error:error];
}

+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath {
    return [self moveItemAtPath:path toPath:toPath error:nil];
}

+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError **)error {
    return [FCFileManager moveItemAtPath:path toPath:toPath error:error];
}


+ (void)removeMACOSXDirectoryForDirectoryPath:(NSString *)path {
    NSArray *directories = [self listDirectoriesInDirectoryAtPath:path];
    for (NSString *directoryPath in directories) {
        NSString *directoryName = directoryPath.lastPathComponent.stringByDeletingPathExtension;
        if ([directoryName.uppercaseString isEqualToString:@"__MACOSX"]) {
            [self removeItemAtPath:directoryPath];
        }
    }
}

#pragma mark - Private method
/**
 *  如果前面有Document路径,则会删除包括Document路径之前路径
 *  得到绝对路径 ->Document/之后的路径
 *
 *  @param path 原路径
 *
 *  @return 绝对路径
 */

+ (NSString *)_removeDocumentPathIfNeed:(NSString *)path {
    
    NSRange docRange = [path rangeOfString:[self documentPath]];
    //有对应的文件夹
    if (docRange.location != NSNotFound) {
        //得到Document之后的文件地址
        return [path substringFromIndex:docRange.length];
    }
    else {
        return path;
    }
}


/**
 *  如果签名木有Document路径, 则会拼接上Document路径
 *
 *  @param path 文件夹路径
 *
 *  @return 完成路径
 */

+ (NSString *)_appendingDocumentPathIfNeed:(NSString *)path {
    NSRange docRange = [path rangeOfString:[self documentPath]];
    //有对应的文件夹
    if (docRange.location == NSNotFound) {
        //得到Document之后的文件地址
        return [[self documentPath] stringByAppendingString:path];
    }
    else {
        return path;
    }
}
@end

#pragma mark - Category NHUser
@implementation NHFileManager (NHUser)


+ (NSString *)currentUserDirectoryPath {
//    NSAssert([NHLoginManager isLogin], @"Has not login yet!!");
    if (![UserCenter sharedInstance].hasLogin) {
        return [self uidDirectoryPathByUid:@"Temp"];
    }
    else {
        return [self uidDirectoryPathByUid:[[UserCenter sharedInstance].userInfo uid]];
    }

}

+ (NSString *)currentChatDirectoryPath {
//    NSAssert([NHLoginManager isLogin], @"Has not login yet!!");
    if (![UserCenter sharedInstance].hasLogin) {
        return [self chatDirectoryPathForUid:@"Temp"];
    }
    else {
        return [self chatDirectoryPathForUid:[[UserCenter sharedInstance].userInfo uid]];
    }
}


@end

#pragma mark - Category NHAudioTool
@implementation NHFileManager (NHAudioTool)

+ (NSString *)audioFileAbsolutePathForRelativePath:(NSString *)relativePath {
    return [self fileAbsolutePathForRelativePath:relativePath];
}

+ (NSString *)audioFileRelativePathForAbsolutePath:(NSString *)absolutePath {
    return [self fileRelativePathForAbsolutePath:absolutePath];
}

@end


#pragma mark - Category NHFileServer

@implementation NHFileManager (NHFileServer)

+ (NSString *)serverFileAbsolutePathForRelativePath:(NSString *)relativePath {
    return [self fileAbsolutePathForRelativePath:relativePath];
}

+ (NSString *)serverFileRelativePathForAbsolutePath:(NSString *)absolutePath {
    return [self fileRelativePathForAbsolutePath:absolutePath];
}

@end


#pragma mark - Category NHFileCache
@implementation NHFileManager (NHFileCache)

+ (NSString *)cacheFileAbsolutePathForRelativePath:(NSString *)relativePath {
    return [self fileAbsolutePathForRelativePath:relativePath];
}

+ (NSString *)cacheFileRelativePathForAbsolutePath:(NSString *)absolutePath {
    return [self fileRelativePathForAbsolutePath:absolutePath];
}

@end

@implementation NHFileManager (NHEmojiManager)

+ (NSArray *)emojiArrayForBundleName:(NSString *)bundleName resourcesOftype:(NSString *)type {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSBundle *aliBundle  = [NSBundle bundleWithURL:[bundle URLForResource:bundleName withExtension:@"bundle"]];
   return [aliBundle pathsForResourcesOfType:type inDirectory:nil];
}

+ (NSString *)middleEmojiAbsolutePathForEmojiContent:(NSDictionary *)contentInfo  {
    
    if (!contentInfo ||
        ![contentInfo isKindOfClass:[NSDictionary class]] ||
        !contentInfo[kNHMiddleEmojiBundleNameKey] ||
        !contentInfo[kNHMiddleEmojiItemNameKey]) {
        return nil;
    }
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSBundle *aliBundle  = [NSBundle bundleWithURL:[bundle URLForResource:contentInfo[kNHMiddleEmojiBundleNameKey] withExtension:@"bundle"]];
    NSString *path = [aliBundle pathForResource:contentInfo[kNHMiddleEmojiItemNameKey] ofType:contentInfo[kNHMiddleEmojiItemTypeKey]];
    return path;
}

+ (NSData *)middleEmojiDataForContentInfo:(NSDictionary *)contentInfo {
    return [NSData dataWithContentsOfFile:[self middleEmojiAbsolutePathForEmojiContent:contentInfo]];
}

@end


static NSString * const NHServersUtils_CachePathComponent = @"Online";
static NSString * const NHServersUtils_JsonFileNamed = @"ConfigParams.plist";
static NSString * const NHServersUtilsConfigParamKey_PraiseImg = @"praise_img";
extern NSString * const NHServersUtilsConfigParamKey_Splashscreen;
extern NSString * const NHServersUtilsConfigParamKey_FileNameSeparator;

@implementation NHFileManager (ServersUtils)

+ (NSString *)utilsLocalServersCachePath {
    NSString *path = [[FCFileManager pathForDocumentsDirectory] stringByAppendingPathComponent: NHServersUtils_CachePathComponent];
    if (![FCFileManager existsItemAtPath: path]) {
        [FCFileManager createDirectoriesForPath: path];
    }
    return path;
}

+ (NSString *)utilsLocalConfigurePlistFilePath {
    return [[self utilsLocalServersCachePath] stringByAppendingPathComponent: NHServersUtils_JsonFileNamed];
}


+ (NSString *)utilsPraise_imgParamKeyDirectoriesPath {
    return [[self utilsLocalServersCachePath] stringByAppendingPathComponent: NHServersUtilsConfigParamKey_PraiseImg];
}

+ (NSString *)utilsPraisedImageDirectoriesPathForTime:(NSString *)endTime {
    return [[self utilsPraise_imgParamKeyDirectoriesPath] stringByAppendingPathComponent:endTime];
}

//+ (NSArray *)utilsPraiseImageFiles {
//    //存在文件夹
//    //取有效的
//    NSArray *images = nil;
//    NSString *unzipDirectoryPath = [self utilsPraise_imgParamKeyDirectoriesPath];
//    if ([self existsItemAtPath:unzipDirectoryPath]) {
//        
//        //文件夹存在
//        NSArray<NSString *> *directorys = [self listDirectoriesInDirectoryAtPath:unzipDirectoryPath];
//        NSMutableArray *mutableImages = [NSMutableArray array];
//        [directorys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//           //
//            //判断时间是否过期
//            NSString *timeStemp = obj.lastPathComponent;
//            double startTime = [[timeStemp componentsSeparatedByString:NHServersUtilsConfigParamKey_FileNameSeparator].firstObject doubleValue];
//            double endTime = [[timeStemp componentsSeparatedByString:NHServersUtilsConfigParamKey_FileNameSeparator].lastObject doubleValue];
//            double serverTime = [[NHOnlineConfigUtils getConfigParams:NHServersUtilsConfigParamKey_TimeStamp] doubleValue];
//            
//            //如果server时间再结束时间之前,
//            if (startTime < serverTime && serverTime < endTime) {
//                
//                NSArray *array = [self listFilesInDirectoryAtPath:obj withExtension:@"png" deep:YES];
//                if (NHValidArrayify(array)) {
//                    [mutableImages addObjectsFromArray:array];
//                }
//                
//            }
//            
//        }];
//        if (NHValidArrayify(mutableImages)) {
//            images = mutableImages;
//        }
//    }
//    return images;
//}

@end

@implementation NHFileManager (Upload)

+ (NSString *)uploadDirectoryPath {
    NSString *uploadDirectory = [[self currentUserDirectoryPath] stringByAppendingPathComponent:kNHFileManagerUploadDirectoryName];
    if (![FCFileManager existsItemAtPath:uploadDirectory]) {
        NSError *error;
        if ([FCFileManager createDirectoriesForPath:uploadDirectory error:&error] && !error) {
            NSLog(@"success created upload directory path");
        }
        else {
            NSLog(@"failure created upload directory path");
        }
    }
    return uploadDirectory;
}
+ (NSString *)uploadFileAbsolutePathForRelativePath:(NSString *)relativePath {
    return [self _appendingDocumentPathIfNeed:relativePath];
}

+ (NSString *)uploadFileRelativePathForAbsolutePath:(NSString *)absolutePath {
    return [self _removeDocumentPathIfNeed:absolutePath];
}

@end

@implementation NHFileManager (ImageCache)

+ (NSString *)imageCachedDirectoryPath {
    NSString *imageCacheDirectory = [[self currentUserDirectoryPath] stringByAppendingPathComponent:kNHFileManagerImageCacheDirectoryName];
    if (![FCFileManager existsItemAtPath:imageCacheDirectory]) {
        NSError *error;
        if ([FCFileManager createDirectoriesForPath:imageCacheDirectory error:&error] && !error) {
            NSLog(@"success created imageCache directory path");
        }
        else {
            NSLog(@"failure created imageCache directory path");
        }
    }
    return imageCacheDirectory;
}
+ (NSString *)imageCacheFileAbsolutePathForRelativePath:(NSString *)relativePath {
    return [self _appendingDocumentPathIfNeed:relativePath];
}

+ (NSString *)imageCacheFileRelativePathForAbsolutePath:(NSString *)absolutePath {
    return [self _removeDocumentPathIfNeed:absolutePath];
}




@end

#pragma mark - Category Deprecated

@implementation NHFileManager (Deprecated)

/**
 *  如果前面有Document路径,则会删除包括Document路径之前路径
 *  得到绝对路径 ->Document/之后的路径
 *
 *  @param path 原路径
 *
 *  @return 绝对路径
 */

+ (NSString *)removeDocumentPathIfNeed:(NSString *)path {
    return [self _removeDocumentPathIfNeed:path];
}


/**
 *  如果签名木有Document路径, 则会拼接上Document路径
 *
 *  @param path 文件夹路径
 *
 *  @return 完成路径
 */

+ (NSString *)appendingDocumentPathIfNeed:(NSString *)path {
    return [self _appendingDocumentPathIfNeed:path];
}


@end