//
//  StudentAttendanceVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "StudentAttendanceVC.h"
#import "ClassSelectionVC.h"
#import "AttendanceOperationVC.h"
#import "LeaveRegisterVC.h"
#import "StudentAttendanceDetailView.h"
@implementation StudentAttendanceHeader
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        _labelArray = [NSMutableArray array];
        NSInteger itemWidth = self.width / 4;
        NSArray *colorArray = @[@"cfcfcf",@"5ed115",@"fecf3c",@"fb7775"];
        NSArray *titleArray = @[@"姓名",@"出勤",@"请假",@"缺勤"];
        for (NSInteger i = 0; i < 4; i++)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, self.height)];
            [label setUserInteractionEnabled:YES];
            [label setBackgroundColor:[UIColor colorWithHexString:colorArray[i]]];
            [label setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
            [label setFont:[UIFont systemFontOfSize:14]];
            [label setTextColor:[UIColor whiteColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setText:titleArray[i]];
            [_labelArray addObject:label];
            [self addSubview:label];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onColumnClicked:)];
            [label addGestureRecognizer:tapGesture];
        }
    }
    return self;
}

- (void)setModel:(StudentAttendanceModel *)model
{
    _model = model;
    NSArray *titleArray = @[@"姓名",@"出勤",@"请假",@"缺勤"];
    for (NSInteger i = 1; i < _labelArray.count; i++)
    {
        UILabel *label = _labelArray[i];
        NSInteger num = 0;
        if(i == 1)
            num = model.normalNum;
        else if(i == 2)
            num = model.leaveNum;
        else
            num = model.absenceNum;
        [label setText:[NSString stringWithFormat:@"%@(%ld)",titleArray[i],num]];
    }
}

- (void)onColumnClicked:(UITapGestureRecognizer *)tapGesture
{
    UIView *targetView = tapGesture.view;
    NSInteger column = [_labelArray indexOfObject:targetView];
    if([self.delegate respondsToSelector:@selector(studentAttendanceOnSortColumn:)])
    {
        [self.delegate studentAttendanceOnSortColumn:column];
    }
}

@end

@interface StudentAttendanceVC ()< AttendanceDateDelegate, StudentAttendanceDelegate>
@property (nonatomic, copy)NSString *leaveDate;
@end

@implementation StudentAttendanceVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    [dateView setBackgroundColor:[UIColor colorWithHexString:@"0eadc0"]];
    [self.view addSubview:dateView];
    
    _datePickerView = [[AttendanceDateView alloc] initWithFrame:dateView.bounds];
    [_datePickerView setDelegate:self];
    [dateView addSubview:_datePickerView];

    [self.tableView setFrame:CGRectMake(0, 40, self.view.width, self.view.height - 50 - 40)];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 50 - 64, self.view.width, 50)];
    [self setupBottomView:bottomView];
    [self.view addSubview:bottomView];
    
    [self bindTableCell:@"StudentAttendanceCell" tableModel:@"StudentAttendanceModel"];
    
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yyyy-MM-dd"];
    self.leaveDate = [formmater stringFromDate:[NSDate date]];
    [self requestData:REQUEST_REFRESH];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatus:) name:kStudentAttendanceStatusChanged object:nil];
}

- (void)setupBottomView:(UIView *)viewParent
{
    [viewParent setBackgroundColor:[UIColor whiteColor]];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewParent.width, 0.5)];
    [topLine setBackgroundColor:[UIColor colorWithHexString:@"d8d8d8"]];
    [viewParent addSubview:topLine];
    
    UIButton *attendanceAllbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [attendanceAllbutton addTarget:self action:@selector(onAllAttendance) forControlEvents:UIControlEventTouchUpInside];
    [attendanceAllbutton setFrame:CGRectMake(viewParent.width - 80 - 10, (viewParent.height - 36) / 2, 80, 36)];
    [attendanceAllbutton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"5ed115"] size:attendanceAllbutton.size cornerRadius:18] forState:UIControlStateNormal];
    [attendanceAllbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [attendanceAllbutton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [attendanceAllbutton setTitle:@"一键全勤" forState:UIControlStateNormal];
    [viewParent addSubview:attendanceAllbutton];
}

- (void)onAllAttendance
{
    __weak typeof(self) wself = self;
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classID forKey:@"class_id"];
    [params setValue:self.leaveDate forKey:@"leave_date"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"leave/leave" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [hud hide:NO];
        [ProgressHUD showHintText:@"一键全勤成功"];
        [wself requestData:REQUEST_REFRESH];
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
    }];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"leave/detail"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classID forKey:@"class_id"];
    [params setValue:self.leaveDate forKey:@"leave_date"];
    [task setParams:params];
    return task;
}

- (void)changeStatus:(NSNotification *)noti
{
    NSMutableDictionary *params = (NSMutableDictionary *)[noti userInfo];
    [params setValue:self.classID forKey:@"class_id"];
    [params setValue:self.leaveDate forKey:@"leave_date"];
    
    StudentAttendanceItem *item = nil;
    for (StudentAttendanceItem *attendanceItem in self.tableViewModel.modelItemArray)
    {
        if([attendanceItem.studentID isEqualToString:params[@"child_id"]])
        {
            item = attendanceItem;
        }
    }
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"leave/leave" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        item.leaveType = [params[@"status"] integerValue];
        StudentAttendanceModel *model = (StudentAttendanceModel *)wself.tableViewModel;
        NSInteger absenseNum = 0,leaveNum = 0,normalNum = 0;
        for (StudentAttendanceItem *item in model.modelItemArray)
        {
            if(item.leaveType == LeaveTypeAbsence)
                absenseNum ++;
            if(item.leaveType == LeaveTypeLeave)
                leaveNum ++;
            if(item.leaveType == LeaveTypeNormal)
                normalNum ++;
        }
        model.absenceNum = absenseNum;
        model.leaveNum = leaveNum;
        model.normalNum = normalNum;
        [wself.tableView reloadData];
    } fail:^(NSString *errMsg) {
        
    }];
}

#pragma mark - DatePickerDelegate
- (void)growthDatePickerFinished:(NSDate *)date
{
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yyyy-MM-dd"];
    self.leaveDate = [formmater stringFromDate:date];
    [self requestData:REQUEST_REFRESH];
}

#pragma mark - Student
- (void)studentAttendanceOnSortColumn:(NSInteger)column
{
    StudentAttendanceModel *model = (StudentAttendanceModel *)self.tableViewModel;
    [model setSortColumn:column];
    [model sort];
    [self.tableView reloadData];
}

- (void)TNBaseTableViewControllerRequestSuccess
{
    if(self.targetStudentID)
    {
        for (StudentAttendanceItem *item in self.tableViewModel.modelItemArray)
        {
            if([item.studentID isEqualToString:self.targetStudentID])
            {
                item.leaveDate = self.leaveDate;
                StudentAttendanceDetailView *detailView = [[StudentAttendanceDetailView alloc] initWithVacationItem:item];
                [detailView show];
            }
        }
        self.targetStudentID = nil;
    }
}

#pragma mark - UItableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *reuseID = @"tableHeader";
    StudentAttendanceHeader *header = (StudentAttendanceHeader *)[tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!header)
        header = [[StudentAttendanceHeader alloc] initWithReuseIdentifier:reuseID];
    [header setDelegate:self];
    StudentAttendanceModel *model = (StudentAttendanceModel *)self.tableViewModel;
    [header setModel:model];
    return header;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:(indexPath.row % 2 == 0) ? [UIColor whiteColor] : [UIColor colorWithHexString:@"ebebeb"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudentAttendanceItem *item = self.tableViewModel.modelItemArray[indexPath.row];
    item.leaveDate = self.leaveDate;
    StudentAttendanceDetailView *detailView = [[StudentAttendanceDetailView alloc] initWithVacationItem:item];
    [detailView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
