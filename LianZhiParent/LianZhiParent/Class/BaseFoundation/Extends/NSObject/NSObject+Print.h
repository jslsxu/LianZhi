//
//  NSObject+Print.h
//  TravelGuideMdd
//
//  Created by 陈曦 on 14-5-29.
//  Copyright (c) 2014年 mafengwo.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject(Print)

+ (void)printClass;
+ (void)printClass:(BOOL)withSuperClass;

@end
