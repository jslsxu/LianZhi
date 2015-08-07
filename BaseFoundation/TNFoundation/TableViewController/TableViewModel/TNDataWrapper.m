//
//  TNDataWrapper.m
//  TNFoundation
//
//  Created by jslsxu on 14-9-4.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNDataWrapper.h"

@implementation TNDataWrapper
- (id)copyWithZone:(NSZone *)zone
{
    TNDataWrapper *result = [[[self class] allocWithZone:zone] init];
    result.data = self.data;
    return result;
}

- (BOOL)isEqual:(id)anObject
{
    if ([anObject isKindOfClass:[TNDataWrapper class]]) {
        return self.data == [anObject data];
    }
    
    return NO;
}

+ (TNDataWrapper *)dataWrapperWithObject:(id)object
{
    TNDataWrapper *jsonObj = [[TNDataWrapper alloc] init];
    if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]]) {
        jsonObj.data = object;
    }
    
    return jsonObj;
}

- (NSUInteger)count
{
    NSUInteger ret = 0;
    
    if ([self.data respondsToSelector:@selector(count)]) {
        ret = [(NSArray *)self.data count];
    }
    
    return ret;
}

- (void)printData
{
    NSLog(@"data is:\r\n %@", _data);
}

- (NSString *)toString
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_data options:0 error:&error];
    
    NSString *stringData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return stringData;
}

- (NSUInteger)hash
{
    return [self.data hash];
}

- (NSString *)description
{
    return [_data description];
}

#pragma mark - Get json element functions
- (id)getObjectForKey:(NSString *)key
{
    id retObj = nil;
    
    if ([_data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *) _data;
        retObj = [dict objectForKey:key];
    }
    
    return retObj;
}

- (TNDataWrapper *)getDataWrapperForKey:(NSString *)key
{
    id retObj = nil;
    
    if ([_data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *) _data;
        retObj = [dict objectForKey:key];
    }
    
    if (retObj == nil) {
        retObj = [NSDictionary dictionary];
    }
    
    return [TNDataWrapper dataWrapperWithObject:retObj];
}

- (NSString *)getStringForKey:(NSString *)key
{
    id retObj = [NSString string];
    
    if ([_data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *) _data;
        retObj = [dict objectForKey:key];
        
        if ([retObj isKindOfClass:[NSNumber class]]) {
            retObj = [retObj stringValue];
        }
        
        if (![retObj isKindOfClass:[NSString class]]) {
            retObj = [NSString string];
        }
    }
    
    return retObj;
}

- (NSInteger)getIntegerForKey:(NSString *)key
{
    return [[self getStringForKey:key] integerValue];
}

- (long long)getLongLongForKey:(NSString *)key
{
    return [[self getStringForKey:key] longLongValue];
}

- (CGFloat)getFloatForKey:(NSString *)key
{
    return [[self getStringForKey:key] floatValue];
}

- (double)getDoubleForKey:(NSString *)key
{
    return [[self getStringForKey:key] doubleValue];
}

- (BOOL)getBoolForKey:(NSString *)key
{
    return [[self getStringForKey:key] boolValue];
}

- (BOOL)setData:(NSObject *)data forKey:(NSString *)key
{
    if (![_data isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    NSDictionary *dic = (NSDictionary *) _data;
    [dic setValue:data forKey:key];
    
    return YES;
}

- (BOOL)removeDataForKey:(NSString *)key
{
    if (![_data isKindOfClass:[NSDictionary class]]) {
        
        return NO;
    }
    
    NSDictionary *dic = (NSDictionary *) _data;
    [dic setNilValueForKey:key];
    
    return YES;
}

#pragma mark - for array
- (id)getObjectForIndex:(NSInteger)index
{
    id retObj = nil;
    if ([_data isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *) _data;
        if ([array count] > index) {
            retObj = [array objectAtIndex:index];
        }
    }
    
    return retObj;
}

- (TNDataWrapper *)getDataWrapperForIndex:(NSInteger)index
{
    id retObj = nil;
    if ([_data isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *) _data;
        if ([array count] > index) {
            retObj = [array objectAtIndex:index];
        }
    }
    
    if (retObj == nil) {
        retObj = [NSArray array];
    }
    
    return [TNDataWrapper dataWrapperWithObject:retObj];
}

- (NSString *)getStringForIndex:(NSInteger)index
{
    id retObj = [NSString string];
    if ([_data isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *) _data;
        if ([array count] > index) {
            retObj = [array objectAtIndex:index];
        }
        
        if ([retObj isKindOfClass:[NSNumber class]]) {
            retObj = [retObj stringValue];
        }
        
        if (![retObj isKindOfClass:[NSString class]]) {
            retObj = [NSString string];
        }
    }
    
    return retObj;
}

- (NSInteger)getIntegerForIndex:(NSInteger)index
{
    return [[self getStringForIndex:index] integerValue];
}

- (long long)getLongLongForIndex:(NSInteger)index
{
    return [[self getStringForIndex:index] longLongValue];
}

- (CGFloat)getFloatForIndex:(NSInteger)index
{
    return [[self getStringForIndex:index] floatValue];
}

- (double)getDoubleForIndex:(NSInteger)index
{
    return [[self getStringForIndex:index] doubleValue];
}

- (BOOL)getBoolForIndex:(NSInteger)index
{
    return [[self getStringForIndex:index] boolValue];
}

- (BOOL)addData:(NSObject *)data
{
    if (![_data isKindOfClass:[NSMutableArray class]]) {
        return NO;
    }
    
    NSMutableArray *array = (NSMutableArray *) _data;
    [array addObject:data];
    
    return YES;
}

- (BOOL)setData:(NSObject *)data atIndex:(NSInteger)index
{
    if (![_data isKindOfClass:[NSMutableArray class]]) {
        return NO;
    }
    
    NSMutableArray *array = (NSMutableArray *) _data;
    if (index < 0 || index >= [self count]) {
        return NO;
    }
    
    [array replaceObjectAtIndex:index withObject:data];
    
    return YES;
}

- (BOOL)insertData:(id)data atIndex:(NSInteger)index
{
    if (![_data isKindOfClass:[NSMutableArray class]]) {
        return NO;
    }
    
    NSMutableArray *array = (NSMutableArray *) _data;
    if (index < 0 || index >= [self count]) {
        return NO;
    }
    
    [array insertObject:data atIndex:index];
    
    return YES;
}

- (BOOL)removeDataAtIndex:(NSInteger)index
{
    if (![_data isKindOfClass:[NSArray class]]) {
        return NO;
    }
    
    if (index < [self count] && index >= 0) {
        [_data removeObjectAtIndex:index];
        return YES;
    }
    
    return NO;
}

@end
