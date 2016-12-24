//
//  AttendanceVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "AttendanceVC.h"
#import "Calendar.h"
#import "ClassAttendanceCell.h"
#import "ClassAttendanceListModel.h"
#import "FilterView.h"
#import "AttendanceHeaderView.h"
#import "StudentsAttendanceVC.h"
@interface AttendanceVC ()<CalendarDelegate>
@property (nonatomic, strong)Calendar* calendar;
@property (nonatomic, strong)FilterView* filterView;
@property (nonatomic, strong)AttendanceHeaderView* headerView;
@end

@implementation AttendanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    self.title = @"学生考勤";
    [self.view addSubview:[self calendar]];
    [self.view addSubview:[self filterView]];
    
    [self.tableView setFrame:CGRectMake(0, self.calendar.bottom, self.view.width, self.filterView.top - self.calendar.bottom)];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self bindTableCell:@"ClassAttendanceCell" tableModel:@"ClassAttendanceListModel"];
    [self setSupportPullUp:YES];
    [self setSupportPullDown:YES];
    [self requestData:REQUEST_REFRESH];
    ClassAttendanceListModel* model = (ClassAttendanceListModel *)self.tableViewModel;
    [self.headerView setModel:model];
    [self.tableView setTableHeaderView:[self headerView]];
}
- (Calendar *)calendar{
    if(_calendar == nil){
        _calendar = [[Calendar alloc] initWithDate:[NSDate date]];
        [_calendar setDelegate:self];
    }
    return _calendar;
}

- (FilterView *)filterView{
    if(nil == _filterView){
        __weak typeof(self) wself = self;
        _filterView = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
        [_filterView setFilterType:AttendanceClassFilterTypeAll];
        [_filterView setFilterChanged:^{
            [wself requestData:REQUEST_REFRESH];
        }];
        [_filterView setTop:self.view.height - _filterView.height];
        [_filterView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    }
    return _filterView;
}

- (AttendanceHeaderView *)headerView{
    if(nil == _headerView){
        _headerView = [[AttendanceHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    }
    return _headerView;
}

- (void)TNBaseTableViewControllerRequestSuccess{
    ClassAttendanceListModel* model = (ClassAttendanceListModel *)self.tableViewModel;
    [self.headerView setModel:model];
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath{
    StudentsAttendanceVC *studentsAttendanceVC = [[StudentsAttendanceVC alloc] init];
    [studentsAttendanceVC setClassInfo:[UserCenter sharedInstance].curSchool.classes[0]];
    [self.navigationController pushViewController:studentsAttendanceVC animated:YES];
}

#pragma mark - CalendarDelegate
- (void)calendarHeightWillChange:(CGFloat)height{
    [self.tableView setFrame:CGRectMake(0, height, self.view.width, self.filterView.top - height)];
}

- (void)calendarDateDidChange:(NSDate *)selectedDate{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
