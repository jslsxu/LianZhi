//
//  NSObject+UnifiedPerformSelector.m
//  TravelGuideMdd
//
//  Created by 陈曦 on 13-5-17.
//  Copyright (c) 2013年 mafengwo.com. All rights reserved.
//

#import "NSObject+UnifiedPerformSelector.h"

@implementation NSObject(UnifiedPerformSelector)

- (void)performSelector:(SEL)aSelector withObject:(id)object withUnified:(BOOL)aUnified
{
    if (aUnified)
    {
        [[NSRunLoop currentRunLoop] cancelPerformSelector:aSelector target:self argument:object];
        [[NSRunLoop currentRunLoop] performSelector:aSelector
                                             target:self
                                           argument:object
                                              order:-1
                                              modes:[NSArray arrayWithObjects:NSDefaultRunLoopMode, nil]];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:aSelector withObject:object];
#pragma clang diagnostic pop
    }
}

@end
