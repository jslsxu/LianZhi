//
//  LZKVStorage.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "LZKVStorage.h"
#import <YYKit/YYKVStorage.h>
#import "NHFileManager.h"
#import <FCFileManager/FCFileManager.h>

@implementation LZKVStorageItem

+ (id)transformArchivedDataValue:(NSData *)dataValue {
    id value = [NSKeyedUnarchiver unarchiveObjectWithData:dataValue];
    if (!value) {
        value = dataValue;
    }
    
    return value;
}

+ (NSData *)transformIDValue:(id)value {
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    else {
        return [NSKeyedArchiver archivedDataWithRootObject:value];
    }
}

@end

@interface LZKVStorage ()
{
    YYKVStorage *_storage;
    dispatch_queue_t _queue;
}
@end
@implementation LZKVStorage

+ (instancetype)applicationKVStorage {
    
    static LZKVStorage *__applicationStorage = nil;
    
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        
        __applicationStorage = [[LZKVStorage alloc] initWithPath:[NHFileManager applicationStoragePath]];
    });
    
    return __applicationStorage;
}

+ (instancetype)userKVStorage {
    NSString *uid = [[UserCenter sharedInstance].userInfo uid];
    if ([uid length] == 0) {
        return nil;
    }
    
    static LZKVStorage *__userStorage = nil;
    
    @synchronized(self.class) {
        NSString *storagePath = [NHFileManager localCurrentUserStoragePath];
        
        if ([storagePath isEqualToString:__userStorage.path]) {
            return __userStorage;
        }
        
        __userStorage = [[LZKVStorage alloc] initWithPath:storagePath];
        
        return __userStorage;
    }
}

- (void)dealloc {
    if (_queue) {
        _queue = NULL;
    }
}

- (instancetype)initWithPath:(NSString *)path {
    self = [self init];
    if (self) {
        _storage = [[YYKVStorage alloc] initWithPath:path type:YYKVStorageTypeSQLite];
        _queue = dispatch_queue_create("com.being.beingcom.KVStorageReadWriteQueue", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (NSString *)path {
    return _storage.path;
}

- (BOOL)saveStorageItem:(LZKVStorageItem *)item {
    YYKVStorageItem *yyItem = [[YYKVStorageItem alloc] init];
    yyItem.key = item.key;
    
    NSData *value = [LZKVStorageItem transformIDValue:item.value];
    
    yyItem.value = value;
    
    __block BOOL ret = NO;
    dispatch_sync(_queue, ^{
        ret = [self->_storage saveItem:yyItem];
    });
    
    return ret;
}

- (LZKVStorageItem *)storageItemForKey:(NSString *)key {
    __block YYKVStorageItem *yyItem = nil;
    
    dispatch_sync(_queue, ^{
        yyItem = [self->_storage getItemForKey:key];
    });
    
    LZKVStorageItem *item = nil;
    if (yyItem) {
        item = [[LZKVStorageItem alloc] init];
        item.key = yyItem.key;
        
        id value = [LZKVStorageItem transformArchivedDataValue:yyItem.value];
        
        item.value = value;
        item.accessTime = yyItem.accessTime;
        item.modTime = yyItem.modTime;
    }
    
    return item;
}

- (BOOL)saveStorageValue:(id)value forKey:(NSString *)key {
    __block BOOL ret = NO;
    
    if (!value) {
        dispatch_sync(_queue, ^{
            ret = [self->_storage removeItemForKey:key];
        });
        return ret;
    }
    
    dispatch_sync(_queue, ^{
        ret = [self->_storage saveItemWithKey:key value:[LZKVStorageItem transformIDValue:value]];
    });
    
    return ret;
}

- (id)storageValueForKey:(NSString *)key {
    __block NSData *value = nil;
    
    dispatch_sync(_queue, ^{
        value = [self->_storage getItemValueForKey:key];
    });
    
    return [LZKVStorageItem transformArchivedDataValue:value];
}

@end
