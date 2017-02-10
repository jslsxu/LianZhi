//
//  MonthStatisticsListModel.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/23.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "MonthStatisticsListModel.h"

@implementation MonthStatisticsItem

@end

@implementation MonthStatisticsListModel

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type{
    self.class_attendance = [data getIntegerForKey:@"class_attendance"];
    TNDataWrapper* listWrapper = [data getDataWrapperForKey:@"items"];
    if(type == REQUEST_REFRESH){
        [self.modelItemArray removeAllObjects];
    }
    NSArray* items = [MonthStatisticsItem nh_modelArrayWithJson:listWrapper.data];
    [self.modelItemArray addObjectsFromArray:items];
    [self setSortIndex:self.sortIndex];
    return YES;
}

- (NSString *)titleForSection:(NSInteger)section{
    return [self titleArray][section];
}

- (NSArray *)titleArray{
    if(self.sortIndex == 0){
        NSDictionary* dic = [self modelDictionary];
        NSMutableArray* keyArray = [NSMutableArray arrayWithArray:[dic allKeys]];
        [keyArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString* key1 = (NSString *)obj1;
            NSString* key2 = (NSString* )obj2;
            return [key1 compare:key2];
        }];
        return keyArray;
    }
    else{
        return nil;
    }
}

- (NSInteger)numOfSections{
    if(self.sortIndex == 0){
        return [self.titleArray count];
    }
    else{
        return 1;
    }
}

- (NSInteger)numOfRowsInSection:(NSInteger)section{
    if(self.sortIndex == 0){
        NSString* key = [self titleArray][section];
        NSArray* sectionArray = [self modelDictionary][key];
        return [sectionArray count];
    }
    else{
        return [self.modelItemArray count];
    }
//    else if(self.sortIndex == 1){
//        NSInteger count = 0;
//        for (MonthStatisticsItem *item in self.modelItemArray) {
//            if([item attendance] > 0){
//                count ++;
//            }
//        }
//        return count;
//    }
//    else if(self.sortIndex == 2){
//        NSInteger count = 0;
//        for (MonthStatisticsItem *item in self.modelItemArray) {
//            if([item absence] > 0){
//                count ++;
//            }
//        }
//        return count;
//    }
    return 1;
}

- (NSDictionary *)modelDictionary{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    for (MonthStatisticsItem *item in self.modelItemArray) {
        NSString* pinyin = [item.child_info.first_letter capitalizedString];
        if([pinyin length] > 0){
            NSString* title = [pinyin substringToIndex:1];
            NSMutableArray* itemArray = [dic valueForKey:title];
            if(itemArray == nil){
                itemArray = [NSMutableArray array];
                [dic setValue:itemArray forKey:title];
            }
            [itemArray addObject:item];
        }
    }
    if([dic count] > 0){
        return dic;
    }
    return nil;
}

- (TNModelItem *)itemForIndexPath:(NSIndexPath *)indexPath{
    if(self.sortIndex == 0){
        NSDictionary* dic = [self modelDictionary];
        NSArray* allKeys = [self titleArray];
        NSString* key = allKeys[indexPath.section];
        NSArray* sectionItems = dic[key];
        return sectionItems[indexPath.row];
    }
    else{
        return [self.modelItemArray objectAtIndex:indexPath.row];
    }
//    else if(self.sortIndex == 1){
//        NSInteger count = 0;
//        for (MonthStatisticsItem *item in self.modelItemArray) {
//            if([item attendance] > 0){
//                count ++;
//            }
//            if(count == indexPath.row + 1){
//                return item;
//            }
//        }
//    }
//    else if(self.sortIndex == 2){
//        NSInteger count = 0;
//        for (MonthStatisticsItem *item in self.modelItemArray) {
//            if([item absence] > 0){
//                count ++;
//            }
//            if(count == indexPath.row + 1){
//                return item;
//            }
//        }
//    }
    return nil;
}

- (void)setSortIndex:(NSInteger)sortIndex{
    _sortIndex = sortIndex;
    [self.modelItemArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        MonthStatisticsItem* item1 = (MonthStatisticsItem *)obj1;
        MonthStatisticsItem* item2 = (MonthStatisticsItem *)obj2;
        if(_sortIndex == 0){
            return [item1.child_info.first_letter compare:item2.child_info.first_letter];
        }
        else if(_sortIndex == 1){
            if(item1.attendance > item2.attendance){
                return NSOrderedAscending;
            }
            else if(item1.attendance == item2.attendance){
                return [item1.child_info.first_letter compare:item2.child_info.first_letter];
            }
            else{
                return NSOrderedDescending;
            }
        }
        else{
            if(item1.absence > item2.absence){
                return NSOrderedAscending;
            }
            else if(item1.absence == item2.absence){
                return [item1.child_info.first_letter compare:item2.child_info.first_letter];
            }
            else{
                return NSOrderedDescending;
            }
        }
    }];
}
@end
