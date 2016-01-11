//
//  StudentAttendanceVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "StudentAttendanceCell.h"
#import "StudentAttendanceHeaderView.h"
#import "AttendanceDateView.h"
#import "StudentAttendanceModel.h"

@protocol StudentAttendanceDelegate <NSObject>

- (void)studentAttendanceOnSortColumn:(NSInteger)column;

@end

@interface StudentAttendanceHeader : UITableViewHeaderFooterView
{
    NSMutableArray*     _labelArray;
}
@property (nonatomic, strong)StudentAttendanceModel *model;
@property (nonatomic, weak)id<StudentAttendanceDelegate> delegate;
@end

@interface StudentAttendanceVC : TNBaseTableViewController
{
    AttendanceDateView* _datePickerView;
}
@property (nonatomic, copy)NSString *classID;
@end
