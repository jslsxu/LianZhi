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

- (NSInteger)numOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    for (ClassAttendanceItem *item in self.modelItemArray) {
        if([self.filterType isEqualToString:[ClassFilterView filterNameForType:AttendanceClassFilterTypeAll]]){
            count ++;
        }
        else if([self.filterType isEqualToString:[ClassFilterView filterNameForType:AttendanceClassFilterTypeUnCommit]]){
            if(!item.submit_leave){
                count ++;
            }
        }
        else if([self.filterType isEqualToString:[ClassFilterView filterNameForType:AttendanceClassFilterTypeLate]]){
            if(item.late_num > 0){
                count++;
            }
        }
        else if([self.filterType isEqualToString:[ClassFilterView filterNameForType:AttendanceClassFilterTypeCommited]]){
            if(item.submit_leave){
                count ++;
            }
        }
        else if([self.filterType isEqualToString:[ClassFilterView filterNameForType:AttendanceClassFilterTypeWuguQueqin]]){
            if(item.noleave_num > 0){
                count ++;
            }
        }
        else{
            NSString* gradeName = [item grade_name];
            if([self.filterType containsString:gradeName]){
                count++;
            }
        }
    }
    return count;
}

- (TNModelItem *)itemForIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = 0;
    for (ClassAttendanceItem *item in self.modelItemArray) {
        if([self.filterType isEqualToString:[ClassFilterView filterNameForType:AttendanceClassFilterTypeAll]]){
            count ++;
        }
        else if([self.filterType isEqualToString:[ClassFilterView filterNameForType:AttendanceClassFilterTypeUnCommit]]){
            if(!item.submit_leave){
                count ++;
            }
        }
        else if([self.filterType isEqualToString:[ClassFilterView filterNameForType:AttendanceClassFilterTypeLate]]){
            if(item.late_num > 0){
                count++;
            }
        }
        else if([self.filterType isEqualToString:[ClassFilterView filterNameForType:AttendanceClassFilterTypeCommited]]){
            if(item.submit_leave){
                count ++;
            }
        }
        else if([self.filterType isEqualToString:[ClassFilterView filterNameForType:AttendanceClassFilterTypeWuguQueqin]]){
            if(item.noleave_num > 0){
                count ++;
            }
        }
        else{
            NSString* gradeName = [item grade_name];
            if([self.filterType containsString:gradeName]){
                count++;
            }
        }
        if(count == indexPath.row + 1){
            return item;
        }
    }
    return nil;
}

- (void)clear{
    [self.modelItemArray removeAllObjects];
    [self setAppH5:nil];
    [self setAll:nil];
}
@end
