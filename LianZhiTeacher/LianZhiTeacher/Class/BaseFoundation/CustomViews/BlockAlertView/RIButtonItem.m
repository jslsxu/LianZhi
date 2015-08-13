//
//  RIButtonItem.m
//  Shibui
//
//  Created by Jiva DeVoe on 1/12/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import "RIButtonItem.h"

@implementation RIButtonItem

+(id)item
{
    return [self new];
}

+(id)itemWithTitle:(NSString *)inTitle
{
    id newItem = [self item];
    [newItem setTitle:inTitle];
    return newItem;
}

@end

