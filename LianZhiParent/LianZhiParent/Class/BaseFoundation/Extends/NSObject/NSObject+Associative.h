//
//  NSObject+Associative.h
//  TravelGuideMdd
//
//  Created by 陈曦 on 13-8-5.
//  Copyright (c) 2013年 mafengwo.com. All rights reserved.
//

#import <objc/runtime.h>

@interface NSObject(Associative)

- (void)setAssignProperty:(id)obj byKey:(const char *)aKey;
- (void)setRetainNonatomicProperty:(id)obj byKey:(const char *)aKey;
- (void)setRetainAtomicProperty:(id)obj byKey:(const char *)aKey;
- (void)setCopyNonatomicProperty:(id)obj byKey:(const char *)aKey;
- (void)setCopyAtomicProperty:(id)obj byKey:(const char *)aKey;

- (id)getAssociativeValue:(const char *)aKey;

@end
