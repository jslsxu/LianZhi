//
//  ClassZoneManager.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/2/9.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassZoneModel.h"
@interface ClassZoneManager : NSObject
{
    NSMutableArray* _itemList;
}
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(ClassZoneManager)
- (void)addItem:(ClassZoneItem *)item;
- (void)removeItem:(ClassZoneItem *)item;
- (NSArray *)itemsForClass:(NSString *)classID;
@end
