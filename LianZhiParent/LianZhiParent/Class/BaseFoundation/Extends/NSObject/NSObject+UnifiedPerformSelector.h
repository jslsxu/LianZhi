//
//  NSObject+UnifiedPerformSelector.h
//  TravelGuideMdd
//
//  Created by 陈曦 on 13-5-17.
//  Copyright (c) 2013年 mafengwo.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(UnifiedPerformSelector)

- (void)performSelector:(SEL)aSelector withObject:(id)object withUnified:(BOOL)aUnified;

@end
