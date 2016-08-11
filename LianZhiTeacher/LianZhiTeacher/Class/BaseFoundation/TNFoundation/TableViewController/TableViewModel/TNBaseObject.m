//
//  TNBaseObject.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/4.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"

@implementation TNBaseObject
+ (NSArray *)nh_modelArrayWithJson:(id)json {
    return [NSArray modelArrayWithClass:[self class] json:json];
}

+ (instancetype)nh_modelWithJson:(id)json {
    return [self modelWithJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return nil;
}

- (NSString *)description{
    return [self modelDescription];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    return [self modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone{
    return [self modelCopy];
}

- (NSUInteger)hash {
    return [self modelHash];
}

- (BOOL)isEqual:(id)object{
    return [self modelIsEqual:object];
}


@end
