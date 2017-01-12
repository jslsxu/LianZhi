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
@property (nonatomic, strong)MBProgressHUD* hud;
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
    [self.tableView setTableHeaderView:[self headerView]];
    [self setSupportPullUp:YES];
    [self setSupportPullDown:YES];
    [self requestData:REQUEST_REFRESH];
}

- (void)clear{
    ClassAttendanceListModel *model = (ClassAttendanceListModel *)self.tableViewModel;
    [model clear];
    [self.tableView reloadData];
    [self.headerView setModel:model];
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
        [_filterView setFilterChanged:^(AttendanceClassFilterType filterType) {
            ClassAttendanceListModel* model = (ClassAttendanceListModel *)wself.tableViewModel;
            [model setFilterType:filterType];
            [wself.tableView reloadData];
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

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    task.requestUrl = @"leave/nallclass";
    NSDate *date = self.calendar.currentSelectedDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[formatter stringFromDate:date] forKey:@"cdate"];
    [task setParams:params];
    return task;
}

- (void)TNBaseTableViewControllerRequestStart{
   self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)TNBaseTableViewControllerRequestSuccess{
    [self.hud hide:NO];
    ClassAttendanceListModel* model = (ClassAttendanceListModel *)self.tableViewModel;
    [self.headerView setModel:model];
}

- (void)TNBaseTableViewControllerRequestFailedWithError:(NSString *)errMsg{
    [self.hud hide:NO];
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath{
    ClassAttendanceItem* item = (ClassAttendanceItem *)modelItem;
    StudentsAttendanceVC *studentsAttendanceVC = [[StudentsAttendanceVC alloc] init];
    [studentsAttendanceVC setClassInfo:item.class_info];
    NSMutableArray* classInfoArray = [NSMutableArray array];
    for (ClassAttendanceItem* attendanceItem in self.tableViewModel.modelItemArray) {
        [classInfoArray addObject:attendanceItem.class_info];
    }
    [studentsAttendanceVC setClassInfoArray:classInfoArray];
    [self.navigationController pushViewController:studentsAttendanceVC animated:YES];
}

#pragma mark - CalendarDelegate
- (void)calendarHeightWillChange:(CGFloat)height{
    [self.tableView setFrame:CGRectMake(0, height, self.view.width, self.filterView.top - height)];
}

- (void)calendarDateDidChange:(NSDate *)selectedDate{
    [self clear];
    [self requestData:REQUEST_REFRESH];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
