//
//  ClassZoneManager.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/2/9.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ClassZoneManager.h"

@implementation ClassZoneManager
SYNTHESIZE_SINGLETON_FOR_CLASS(ClassZoneManager)

- (id)init
{
    self = [super init];
    if(self)
    {
        _itemList = [[NSMutableArray alloc] initWithCapacity:0];
        
    }
    return self;
}

- (void)addItem:(ClassZoneItem *)item
{
    [_itemList addObject:item];
}

- (void)removeItem:(ClassZoneItem *)item
{
    if([_itemList containsObject:item])
        [_itemList removeObject:item];
}

- (NSArray *)itemsForClass:(NSString *)classID
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (ClassZoneItem *item in _itemList) {
        NSDictionary *params = [item params];
        if([[params objectForKey:@"class_id"] isEqualToString:classID])
            [array addObject:item];
    }
    return array;
}
@end
