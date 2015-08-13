//
//  NSObject+Associative.m
//  TravelGuideMdd
//
//  Created by 陈曦 on 13-8-5.
//  Copyright (c) 2013年 mafengwo.com. All rights reserved.
//

#import "NSObject+Associative.h"

@implementation NSObject(Associative)

- (void)setAssignProperty:(id)obj byKey:(const char *)aKey
{
    objc_setAssociatedObject(self, aKey, obj, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setRetainNonatomicProperty:(id)obj byKey:(const char *)aKey
{
    objc_setAssociatedObject(self, aKey, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setRetainAtomicProperty:(id)obj byKey:(const char *)aKey
{
    objc_setAssociatedObject(self, aKey, obj, OBJC_ASSOCIATION_RETAIN);
}

- (void)setCopyNonatomicProperty:(id)obj byKey:(const char *)aKey
{
    objc_setAssociatedObject(self, aKey, obj, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setCopyAtomicProperty:(id)obj byKey:(const char *)aKey
{
    objc_setAssociatedObject(self, aKey, obj, OBJC_ASSOCIATION_COPY);
}

- (id)getAssociativeValue:(const char *)aKey
{
    return objc_getAssociatedObject(self, aKey);
}

@end
