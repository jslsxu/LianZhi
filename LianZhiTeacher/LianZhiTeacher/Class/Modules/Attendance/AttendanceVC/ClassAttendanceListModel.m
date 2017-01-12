//
//  ClassAttendanceListModel.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ClassAttendanceListModel.h"

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
    return YES;
}

- (NSInteger)numOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    for (ClassAttendanceItem *item in self.modelItemArray) {
        if(self.filterType == AttendanceClassFilterTypeAll){
            count ++;
        }
        else if(self.filterType == AttendanceClassFilterTypeUnCommit){
            if(!item.submit_leave){
                count ++;
            }
        }
        else if(self.filterType == AttendanceClassFilterTypeLate){
            if(item.late_num > 0){
                count++;
            }
        }
        else if(self.filterType == AttendanceClassFilterTypeCommited){
            if(item.submit_leave){
                count ++;
            }
        }
        else if(self.filterType == AttendanceClassFilterTypeWuguQueqin){
            if(item.noleave_num > 0){
                count ++;
            }
        }
    }
    return count;
}

- (TNModelItem *)itemForIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = 0;
    for (ClassAttendanceItem *item in self.modelItemArray) {
        if(self.filterType == AttendanceClassFilterTypeAll){
            count ++;
        }
        else if(self.filterType == AttendanceClassFilterTypeUnCommit){
            if(!item.submit_leave){
                count ++;
            }
        }
        else if(self.filterType == AttendanceClassFilterTypeLate){
            if(item.late_num > 0){
                count++;
            }
        }
        else if(self.filterType == AttendanceClassFilterTypeCommited){
            if(item.submit_leave){
                count ++;
            }
        }
        else if(self.filterType == AttendanceClassFilterTypeWuguQueqin){
            if(item.noleave_num > 0){
                count ++;
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
