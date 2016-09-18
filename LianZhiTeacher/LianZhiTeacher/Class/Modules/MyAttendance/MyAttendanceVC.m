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
@property (nonatomic, copy)NSString *month;
@property (nonatomic, strong)MyAttendanceItem *todayItem;
@end

@implementation MyAttendanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的考勤";
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 70)];
    [self.view addSubview:_headerView];
    [self setupHeadView];
    
    AttendanceDatePickerView *datePickerView = [[AttendanceDatePickerView alloc] initWithFrame:CGRectMake(0, 70, _headerView.width, 25)];
    [datePickerView setDelegate:self];
    [self.view addSubview:datePickerView];
    
    [self.tableView setFrame:CGRectMake(0, datePickerView.bottom, self.view.width, self.view.height - 64 - datePickerView.bottom)];
    
    [self bindTableCell:@"MyAttendanceCell" tableModel:@"MyAttendanceModel"];
    [self setSupportPullDown:YES];
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yyyy-MM"];
    self.month = [formmater stringFromDate:[NSDate date]];
    [self requestData:REQUEST_REFRESH];
}

- (void)setupHeadView
{
    [_headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yyyy年MM月dd日"];
    for (MyAttendanceItem *item in self.tableViewModel.modelItemArray)
    {
        NSString *dateStr = [formmater stringFromDate:[NSDate dateWithTimeIntervalSince1970:item.timeStamp]];
        if([dateStr isEqualToString:[formmater stringFromDate:[NSDate date]]])
            self.todayItem = item;
    }
    UIView *todayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _headerView.width, 70)];
    [todayView setBackgroundColor:[UIColor colorWithHexString:@"0eadc0"]];
    [_headerView addSubview:todayView];
    
    
    AvatarView *avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(30, (todayView.height - 48) / 2, 48, 48)];
    [avatarView sd_setImageWithURL:[NSURL URLWithString:[UserCenter sharedInstance].userInfo.avatar]];
    [todayView addSubview:avatarView];
    
    if(self.todayItem)
    {
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarView.right + 20, 15, todayView.width - 10 - (avatarView.right + 20), 20)];
        [dateLabel setTextColor:[UIColor whiteColor]];
        [dateLabel setFont:[UIFont systemFontOfSize:14]];
        [dateLabel setText:[formmater stringFromDate:[NSDate date]]];
        [todayView addSubview:dateLabel];
        
        UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [startLabel setFrame:CGRectMake(dateLabel.x, 40, (_headerView.width - dateLabel.x) / 2, 16)];
        [startLabel setTextColor:[UIColor whiteColor]];
        [startLabel setFont:[UIFont systemFontOfSize:14]];
        [startLabel setText:[NSString stringWithFormat:@"%@ %@",self.todayItem.startRegion, self.todayItem.startTime]];
        [todayView addSubview:startLabel];
        
        UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [endLabel setFrame:CGRectMake(startLabel.right, 40, startLabel.width, 16)];
        [endLabel setTextColor:[UIColor whiteColor]];
        [endLabel setFont:[UIFont systemFontOfSize:14]];
        [endLabel setText:[NSString stringWithFormat:@"%@ %@",self.todayItem.endRegion, self.todayItem.endTime]];
        [todayView addSubview:endLabel];
    }
    
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"leave/record"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.month forKey:@"ym"];
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
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yyyy-MM"];
    self.month = [formmater stringFromDate:date];
    [self requestData:REQUEST_REFRESH];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
