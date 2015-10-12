//
//  MyAttendanceVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "MyAttendanceVC.h"
#import "AttendanceDatePickerView.h"
#import "MyAttendanceCell.h"
@interface MyAttendanceVC ()<AttendanceDatePickerDelegate>

@end

@implementation MyAttendanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的考勤";
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 95)];
    [self.view addSubview:_headerView];
    [self setupHeadView];
    
    [self.tableView setFrame:CGRectMake(0, _headerView.height, self.view.width, self.view.height - 64 - _headerView.height)];
    
    [self bindTableCell:@"MyAttendanceCell" tableModel:@"MyAttendanceModel"];
    [self setSupportPullDown:YES];
    [self requestData:REQUEST_REFRESH];
}

- (void)setupHeadView
{
    [_headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *todayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _headerView.width, 70)];
    [_headerView addSubview:todayView];
    
    
    AvatarView *avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(30, (todayView.height - 48) / 2, 48, 48)];
    [todayView addSubview:avatarView];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarView.right + 20, 15, todayView.width - 10 - (avatarView.right + 20), 20)];
    [dateLabel setTextColor:[UIColor whiteColor]];
    [dateLabel setFont:[UIFont systemFontOfSize:14]];
    [todayView addSubview:dateLabel];
    
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [startLabel setTextColor:[UIColor whiteColor]];
    [startLabel setFont:[UIFont systemFontOfSize:14]];
    [todayView addSubview:startLabel];
    
    UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [endLabel setTextColor:[UIColor whiteColor]];
    [endLabel setFont:[UIFont systemFontOfSize:14]];
    [todayView addSubview:endLabel];
    
    AttendanceDatePickerView *datePickerView = [[AttendanceDatePickerView alloc] initWithFrame:CGRectMake(0, todayView.bottom, _headerView.width, _headerView.height - todayView.height)];
    [_headerView addSubview:datePickerView];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"sms/get"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [task setParams:params];
    return task;

}

- (void)TNBaseTableViewControllerRequestSuccess
{
    [self setupHeadView];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAttendanceCell *attendanceCell = (MyAttendanceCell *)cell;
    [attendanceCell setIsDark:(indexPath.row % 2 == 1)];
}

#pragma mark - AttendancePickerDelegate
- (void)attendancePickerDidPickAtDate:(NSDate *)date
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
