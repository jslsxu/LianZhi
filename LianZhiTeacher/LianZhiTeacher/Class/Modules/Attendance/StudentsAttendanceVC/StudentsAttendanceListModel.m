//
//  StudentsAttendanceListModel.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/23.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "StudentsAttendanceListModel.h"

static NSString* attendanceStringFroType(AttendanceStatus status){
    static NSString* attendanceNameArray[] = {@"正常出勤", @"迟到", @"请假", @"缺勤"};
    return attendanceNameArray[status];
}

@implementation AttendanceNoteItem

@end

@implementation StudentAttendanceItem

+ (NSDictionary<NSString*, id> *)modelContainerPropertyGenericClass{
    return @{@"recode" : [AttendanceNoteItem class]};
}

- (BOOL)edited{
    if(!self.teacher_edit){
        return YES;
    }
    if(self.status != self.newStatus){
        return YES;
    }
    if([self.edit_mark length] + [self.mark_info length] > 0 && ![self.edit_mark isEqualToString:self.mark_info]){
        return YES;
    }
    return NO;
}

- (NSString *)editComment{
    if([self edited]){
        NSString* comment = [NSString stringWithFormat:@"%@教师提交为%@。", [UserCenter sharedInstance].userInfo.name,attendanceStringFroType(self.newStatus)];
        NSString* markInfo = [self.edit_mark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([markInfo length] > 0){
            comment = [NSString stringWithFormat:@"%@ 备注:%@", comment, self.edit_mark];
        }
        return comment;
    }
    return nil;
}

- (BOOL)normalAttendance{
    return self.status == AttendanceStatusNormal || self.status == AttendanceStatusLate;
}

- (BOOL)editNormalAttenance{
    return self.newStatus == AttendanceStatusNormal || self.newStatus == AttendanceStatusLate;
}

- (NSDictionary *)attedanceInfo{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:self.child_info.uid forKey:@"child_id"];
    [dictionary setValue:kStringFromValue(self.newStatus) forKey:@"status"];
    [dictionary setValue:[self editComment] forKey:@"recode"];
    return dictionary;
}
@end

@implementation ClassAttendanceInfo


@end

@implementation StudentsAttendanceListModel

- (instancetype)init{
    self = [super init];
    if(self){
        self.absenceIndex = -1;
    }
    return self;
}

- (NSInteger)attendanceNum{
    NSInteger count = 0;
    for (StudentAttendanceItem* item in self.modelItemArray) {
        if([item normalAttendance]){
            count++;
        }
    }
    return count;
}

- (NSInteger)absenceNum{
    return self.modelItemArray.count - [self attendanceNum];
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type{
    if(type == REQUEST_REFRESH){
        [self.modelItemArray removeAllObjects];
    }
    TNDataWrapper *infoWrapper = [data getDataWrapperForKey:@"info"];
    self.info = [ClassAttendanceInfo modelWithJSON:infoWrapper.data];
    
    TNDataWrapper *itemsWrapper = [data getDataWrapperForKey:@"items"];
    NSArray* items = [StudentAttendanceItem nh_modelArrayWithJson:itemsWrapper.data];
    for (StudentAttendanceItem* attendanceItem in items) {
        attendanceItem.newStatus = attendanceItem.status;
        attendanceItem.edit_mark = attendanceItem.mark_time;
    }
    [self.modelItemArray addObjectsFromArray:items];
    self.submit_leave = [data getBoolForKey:@"submit_leave"];
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

- (NSDictionary *)modelDictionary{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    for (StudentAttendanceItem *item in self.modelItemArray) {
        NSString* pinyin = [[item.child_info namePinyin] capitalizedString];
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
//        for (StudentAttendanceItem *item in self.modelItemArray) {
//            if([item normalAttendance]){
//                count ++;
//            }
//        }
//        return count;
//    }
//    else if(self.sortIndex == 2){
//        NSInteger count = 0;
//        for (StudentAttendanceItem *item in self.modelItemArray) {
//            if(![item normalAttendance]){
//                count ++;
//            }
//        }
//        return count;
//    }
    return 1;
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
//        for (StudentAttendanceItem *item in self.modelItemArray) {
//            if([item normalAttendance]){
//                count ++;
//            }
//            if(count == indexPath.row + 1){
//                return item;
//            }
//        }
//    }
//    else if(self.sortIndex == 2){
//        NSInteger count = 0;
//        for (StudentAttendanceItem *item in self.modelItemArray) {
//            if(![item normalAttendance]){
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
    if(!self.attendaceEdit){
        _sortIndex = sortIndex;
        [self sortModelList:_sortIndex];
    }
    else{
        if(sortIndex == 2){
            if(self.absenceIndex < [self absenceNum] - 1){
                self.absenceIndex ++;
            }
            else{
                self.absenceIndex = 0;
            }
        }
    }
}

- (void)sortModelList:(NSInteger)sortIndex{
    [self.modelItemArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        StudentAttendanceItem* item1 = (StudentAttendanceItem *)obj1;
        StudentAttendanceItem* item2 = (StudentAttendanceItem *)obj2;
        if(sortIndex == 0){
            return [[item1.child_info namePinyin] compare:[item2.child_info namePinyin]];
        }
        else if(sortIndex == 1){
            if([item1 normalAttendance] && [item2 normalAttendance]){
                return [[item1.child_info namePinyin] compare:[item2.child_info namePinyin]];
            }
            else if([item1 normalAttendance]){
                return NSOrderedAscending;
            }
            else if([item2 normalAttendance]){
                return NSOrderedDescending;
            }
            else{
                return [[item1.child_info namePinyin] compare:[item2.child_info namePinyin]];
            }
        }
        else{
            if(![item1 normalAttendance] && ![item2 normalAttendance]){
                return [[item1.child_info namePinyin] compare:[item2.child_info namePinyin]];
            }
            else if(![item1 normalAttendance]){
                return NSOrderedAscending;
            }
            else if(![item2 normalAttendance]){
                return NSOrderedDescending;
            }
            else{
                return [[item1.child_info namePinyin] compare:[item2.child_info namePinyin]];
            }
        }
    }];
}

@end
