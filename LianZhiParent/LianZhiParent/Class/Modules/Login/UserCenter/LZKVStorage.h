//
//  LZKVStorage.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LZKVStorageItem : NSObject
@property (nonatomic, copy)NSString* key;
@property (nonatomic, strong)id value;
@property (nonatomic, assign)NSInteger modTime;     //< modification unix timestamp
@property (nonatomic, assign)NSInteger accessTime;  //< last access unix timestamp

@end
@interface LZKVStorage : NSObject
@property (nonatomic, readonly)NSString *path;
- (instancetype)initWithPath:(NSString *)path;

- (BOOL)saveStorageItem:(LZKVStorageItem *)item;
- (LZKVStorageItem *)storageItemForKey:(NSString *)key;

- (BOOL)saveStorageValue:(id)value forKey:(NSString *)key;
- (id)storageValueForKey:(NSString *)key;

+ (instancetype)applicationKVStorage;
+ (instancetype)userKVStorage;
@end
