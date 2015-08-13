//
//  NSObject+Print.m
//  TravelGuideMdd
//
//  Created by 陈曦 on 14-5-29.
//  Copyright (c) 2014年 mafengwo.com. All rights reserved.
//

#import "NSObject+Print.h"
#import <objc/runtime.h>

@implementation NSObject(Print)

+ (void)_printClass:(Class)classss
{
    Class classs = classss;
    
    NSLog(@"%@ print method -------------------------------------",NSStringFromClass(classss));
    NSUInteger methodCount = 0;
    Method *methods = class_copyMethodList(classs, &methodCount);
    for (NSUInteger i = 0 ; i < methodCount ; i ++)
    {
        Method method = methods[i];
        NSLog(@"%@",NSStringFromSelector( method_getName(method)));
    }
    
    NSLog(@"%@ print property -------------------------------------",NSStringFromClass(classss));
    NSUInteger pCount = 0;
    objc_property_t *ps = class_copyPropertyList(classs, &pCount);
    for (NSUInteger i = 0 ; i < pCount ; i ++)
    {
        objc_property_t p = ps[i];
        NSLog(@"%s",property_getName(p));
    }
    
    NSLog(@"%@ print vars -------------------------------------",NSStringFromClass(classss));
    NSUInteger vCount = 0;
    Ivar *vs = class_copyIvarList(classs, &vCount);
    for (NSUInteger i = 0 ; i < vCount ; i ++)
    {
        Ivar v = vs[i];
        NSLog(@"%s",ivar_getName(v));
    }
}

+ (void)printClass
{
    [self _printClass:self];
}

+ (void)printClass:(BOOL)withSuperClass
{
    if (!withSuperClass)
    {
        [self printClass];
    }
    else
    {
        Class classs = self;
        while (classs) {
            [self _printClass:classs];
            classs = class_getSuperclass(classs);
        }
    }
}

@end
