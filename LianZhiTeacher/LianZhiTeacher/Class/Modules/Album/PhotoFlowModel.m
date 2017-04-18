//
//  PhotoFlowModel.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/22.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PhotoFlowModel.h"

@interface PhotoFlowModel ()
@property (nonatomic, strong)NSMutableArray *dayList;
@end

@implementation PhotoFlowModel

- (NSMutableArray *)dayList{
    if(_dayList == nil){
        _dayList = [NSMutableArray array];
    }
    return _dayList;
}

- (BOOL)showYearForSection:(NSInteger)section{
    NSString* date = [self dataOfHeaderForSection:section];
    NSString* year = [date substringToIndex:4];
    if(section == 0){
        NSInteger currentYear = [[NSDate date] year];
        if(currentYear == [year integerValue]){//当前，不显示
            return NO;
        }
        else{
            return YES;
        }
    }
    else{
        NSString* preDate = [self dataOfHeaderForSection:section - 1];
        NSString* preYear = [preDate substringToIndex:4];
        return ![preYear isEqualToString:year];
    }
}

- (id)dataOfHeaderForSection:(NSInteger)section
{
    return self.dayList[section];
}

- (NSInteger)numOfSections{
    return [self.dayList count];
}

- (NSInteger)numOfRowsInSection:(NSInteger)section{
    NSString* day = [self.dayList objectAtIndex:section];
    NSInteger count = 0;
    for (PhotoItem *item in self.modelItemArray) {
        if([day isEqualToString:[item day]]){
            count ++;
        }
    }
    return count;
}

- (TNModelItem *)itemForIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString* day = [self.dayList objectAtIndex:section];
    NSInteger index = -1;
    for (NSInteger i = 0; i < [self.modelItemArray count]; i++) {
        PhotoItem *photoItem = self.modelItemArray[i];
        if([day isEqualToString:photoItem.day]){
            index ++;
            if(index == row){
                return photoItem;
            }
        }
    }
    return nil;
}

- (void)setForPhotoPicker:(BOOL)forPhotoPicker
{
    _forPhotoPicker = forPhotoPicker;
    PhotoItem *holdItem = [[PhotoItem alloc] init];
    [holdItem setWidth:1];
    [holdItem setHeight:1];
    [self.modelItemArray addObject:holdItem];
}

- (BOOL)hasMoreData
{
    return self.total + (self.forPhotoPicker ? 1 : 0) > self.modelItemArray.count;
}


- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    BOOL parse = [super parseData:data type:type];
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
            [self.modelItemArray addObject:item];
        }
    }
    
    [self.dayList removeAllObjects];
    for (PhotoItem *item in self.modelItemArray) {
        BOOL contains = NO;
        for (NSString *day in self.dayList) {
            if([day isEqualToString:[item day]]){
                contains = YES;
                break;
            }
        }
        if(!contains){
            [self.dayList addObject:[item day]];
        }
    }
    return parse;
}
@end
