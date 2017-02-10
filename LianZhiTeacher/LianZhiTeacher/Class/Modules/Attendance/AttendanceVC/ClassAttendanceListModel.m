//
//  ClassAttendanceListModel.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ClassAttendanceListModel.h"
#import "FilterView.h"
@implementation AllInfo

@end

@implementation ClassAttendanceItem

+ (NSDictionary<NSString* ,id > *)modelCustomPropertyMapper{
    return @{@"teacherID" : @"class_info.teacherId",@"schoolID" : @"class_info.school_id", @"teacherName" : @"class_info.teacherName", @"mobile" : @"class_info.teacherMobile"};
}
@end

@implementation AppH5

@end

@implementation ClassAttendanceListModel

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type{
    if(type == REQUEST_REFRESH){
        [self.modelItemArray removeAllObjects];
    }
    TNDataWrapper* h5Wrapper = [data getDataWrapperForKey:@"app_h5"];
    self.appH5 = [AppH5 modelWithJSON:h5Wrapper.data];
    TNDataWrapper* allInfo = [data getDataWrapperForKey:@"all"];
    self.all = [AllInfo modelWithJSON:allInfo.data];
    TNDataWrapper* itemsWrapper = [data getDataWrapperForKey:@"items"];
    NSArray* items = [ClassAttendanceItem nh_modelArrayWithJson:itemsWrapper.data];
    [self.modelItemArray addObjectsFromArray:items];
    self.filterType = [ClassFilterView filterNameForType:AttendanceClassFilterTypeAll];
    return YES;
}

- (NSInteger)lateNum{
    NSInteger num = 0;
    for (ClassAttendanceItem *item in self.modelItemArray) {
        num += item.late_num;
    }
    return num;
}

- (NSInteger)absenceWithoutReasonNum{
    NSInteger num = 0;
    for (ClassAttendanceItem *item in self.modelItemArray) {
        num += item.noleave_num;
    }
    return num;
}

- (NSArray *)filterTypeList{
    NSMutableArray* gradeArray = [NSMutableArray array];
    for (ClassAttendanceItem* item in self.modelItemArray) {
        NSString* gradeName = item.grade_name;
        if([gradeName length] > 0){
            BOOL isIn = NO;
            for (NSString* name in gradeArray) {
                if([name isEqualToString:gradeName]){
                    isIn = YES;
                }
            }
            if(!isIn){
                [gradeArray addObject:gradeName];
            }
        }
    }
    NSMutableArray* gradeNameArray = [NSMutableArray array];
    for (NSString* gradeName in gradeArray) {
        [gradeNameArray addObject:[NSString stringWithFormat:@"显示%@",gradeName]];
    }
    
    NSMutableArray* sortTypeArray = [NSMutableArray array];
    [sortTypeArray addObject:[ClassFilterView filterNameForType:AttendanceClassFilterTypeAll]];
    [sortTypeArray addObject:[ClassFilterView filterNameForType:AttendanceClassFilterTypeUnCommit]];
    [sortTypeArray addObject:[ClassFilterView filterNameForType:AttendanceClassFilterTypeCommited]];
    [sortTypeArray addObject:[ClassFilterView filterNameForType:AttendanceClassFilterTypeWuguQueqin]];
    [sortTypeArray addObject:[ClassFilterView filterNameForType:AttendanceClassFilterTypeLate]];
    [sortTypeArray addObjectsFromArray:gradeNameArray];
    return sortTypeArray;
}

- (void)setFilterType:(NSString *)filterType{
    _filterType = [filterType copy];
    self.filterClassArray = [self classArrayWithFilter];
}

- (NSArray *)classArrayWithFilter{
    NSMutableArray* filterClassArray = [NSMutableArray array];
    for (ClassAttendanceItem *item in self.modelItemArray) {
        if([self.filterType isEqualToString:[ClassFilterView filterNameForType:AttendanceClassFilterTypeAll]]){
            [filterClassArray addObject:item];
        }
        else if([self.filterType isEqualToString:[ClassFilterView filterNameForType:AttendanceClassFilterTypeUnCommit]]){
            if(!item.submit_leave){
                [filterClassArray addObject:item];
            }
        }
        else if([self.filterType isEqualToString:[ClassFilterView filterNameForType:AttendanceClassFilterTypeLate]]){
            if(item.late_num > 0){
                [filterClassArray addObject:item];
            }
        }
        else if([self.filterType isEqualToString:[ClassFilterView filterNameForType:AttendanceClassFilterTypeCommited]]){
            if(item.submit_leave){
                [filterClassArray addObject:item];
            }
        }
        else if([self.filterType isEqualToString:[ClassFilterView filterNameForType:AttendanceClassFilterTypeWuguQueqin]]){
            if(item.noleave_num > 0){
               [filterClassArray addObject:item];
            }
        }
        else{
            NSString* gradeName = [item grade_name];
            if([self.filterType containsString:gradeName]){
                [filterClassArray addObject:item];
            }
        }
    }
    NSString* curTeacherID = [UserCenter sharedInstance].userInfo.uid;
    [filterClassArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        ClassAttendanceItem* item1 = (ClassAttendanceItem *)obj1;
        ClassAttendanceItem* item2 = (ClassAttendanceItem *)obj2;
        if([item1.teacherID isEqualToString:curTeacherID] && [item2.teacherID isEqualToString:curTeacherID]){
            return [[item1.class_info.name transformToPinyin] compare:[item2.class_info.name transformToPinyin]];
        }
        else if([item1.teacherID isEqualToString:curTeacherID]){
            return NSOrderedAscending;
        }
        else if([item2.teacherID isEqualToString:curTeacherID]){
            return NSOrderedDescending;
        }
        else{
            return [[item1.class_info.name transformToPinyin] compare:[item2.class_info.name transformToPinyin]];
        }
    }];
    return filterClassArray;
}

- (NSInteger)numOfRowsInSection:(NSInteger)section{
    return [self.filterClassArray count];
}

- (TNModelItem *)itemForIndexPath:(NSIndexPath *)indexPath{
    if([self.filterClassArray count] > 0){
        return [self.filterClassArray objectAtIndex:indexPath.row];
    }
    return nil;
}

- (void)clear{
    [self.modelItemArray removeAllObjects];
    [self setAppH5:nil];
    [self setAll:nil];
}
@end
