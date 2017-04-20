//
//  PhotoPickerModel.m
//  LianZhiParent
//
//  Created by jslsxu on 15/3/16.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PhotoPickerModel.h"

@implementation PhotoPickerModel

- (BOOL)hasMoreData{
    return self.total > [self.modelItemArray count];
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    if(type == REQUEST_REFRESH)
    {
        [self.modelItemArray removeAllObjects];
    }
    
    self.total = [data getIntegerForKey:@"total"];
    
    TNDataWrapper *dataArray = [data getDataWrapperForKey:@"pictures"];
    if([dataArray count] > 0)
    {
        for (NSInteger i = 0; i < [dataArray count]; i++) {
            TNDataWrapper *itemInfo = [dataArray getDataWrapperForIndex:i];
            PhotoItem *item = [[PhotoItem alloc] initWithDataWrapper:itemInfo];
            PhotoPickerItem *pickerItem = [[PhotoPickerItem alloc] init];
            [pickerItem setPhotoItem:item];
            [self.modelItemArray addObject:pickerItem];
        }
    }
    return YES;

}
@end
