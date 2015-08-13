//
//  TNDataWrapper.h
//  TNFoundation
//
//  Created by jslsxu on 14-9-4.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNDataWrapper : NSObject
@property (nonatomic, strong)id data;
+ (TNDataWrapper*)dataWrapperWithObject:(id)object;
- (NSUInteger)count;
- (void)printData;
- (NSString *)toString;

// for dictionary
- (id)getObjectForKey:(NSString *)key;
- (TNDataWrapper*)getDataWrapperForKey:(NSString*)key;
- (NSString*)getStringForKey:(NSString*)key;
- (NSInteger)getIntegerForKey:(NSString*)key;
- (long long)getLongLongForKey:(NSString*)key;

- (CGFloat)getFloatForKey:(NSString *)key;
- (double)getDoubleForKey:(NSString *)key;
- (BOOL)getBoolForKey:(NSString*)key;
- (BOOL)setData:(NSObject*)data forKey:(NSString*)key;
- (BOOL)removeDataForKey:(NSString*)key;

// for array
- (id)getObjectForIndex:(NSInteger)index;
- (TNDataWrapper*)getDataWrapperForIndex:(NSInteger)index;
- (NSString*)getStringForIndex:(NSInteger)index;
- (NSInteger)getIntegerForIndex:(NSInteger)index;
- (long long)getLongLongForIndex:(NSInteger)index;
- (CGFloat)getFloatForIndex:(NSInteger)index;
- (double)getDoubleForIndex:(NSInteger)index;
- (BOOL)getBoolForIndex:(NSInteger)index;

- (BOOL)addData:(NSObject*)data;
- (BOOL)setData:(NSObject*)data atIndex:(NSInteger)index;
- (BOOL)insertData:(id)data atIndex:(NSInteger)index;
- (BOOL)removeDataAtIndex:(NSInteger)index;
@end
