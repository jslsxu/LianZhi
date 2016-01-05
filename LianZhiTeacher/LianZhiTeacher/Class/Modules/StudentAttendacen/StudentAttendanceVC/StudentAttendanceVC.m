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

@implementation StudentAttendanceHeader
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        NSInteger itemWidth = self.width / 4;
        NSArray *colorArray = @[@"cfcfcf",@"5ed115",@"fecf3c",@"fb7775"];
        NSArray *titleArray = @[@"姓名",@"出勤",@"请假",@"缺勤"];
        for (NSInteger i = 0; i < 4; i++)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, self.height)];
            [label setBackgroundColor:[UIColor colorWithHexString:colorArray[i]]];
            [label setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
            [label setFont:[UIFont systemFontOfSize:14]];
            [label setTextColor:[UIColor whiteColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setText:titleArray[i]];
            [self addSubview:label];
        }
    }
    return self;
}

@end

@interface StudentAttendanceVC ()< DatePickerDelegate>
@property (nonatomic, strong)ClassInfo *curClass;
@end

@implementation StudentAttendanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.classInfo.className;
    _datePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    [self.view addSubview:_datePickerView];

    [self.tableView setHeight:self.view.height - 64 - 40 - 50];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, self.view.width, 50)];
    [self setupBottomView:bottomView];
    [self.view addSubview:bottomView];
    
    [self bindTableCell:@"StudentAttendanceCell" tableModel:@"StudentAttendanceModel"];
}

- (void)setupBottomView:(UIView *)viewParent
{
    [viewParent setBackgroundColor:[UIColor whiteColor]];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewParent.width, 0.5)];
    [topLine setBackgroundColor:[UIColor colorWithHexString:@"d8d8d8"]];
    [viewParent addSubview:topLine];
    
    UIButton *attendanceAllbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [attendanceAllbutton setFrame:CGRectMake(viewParent.width - 80 - 10, (viewParent.height - 36) / 2, 80, 36)];
    [attendanceAllbutton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"5ed115"] size:attendanceAllbutton.size cornerRadius:18] forState:UIControlStateNormal];
    [attendanceAllbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [attendanceAllbutton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [attendanceAllbutton setTitle:@"一键全勤" forState:UIControlStateNormal];
    [viewParent addSubview:attendanceAllbutton];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    return nil;
}

#pragma mark - DatePickerDelegate
- (void)growthDatePickerFinished:(NSDate *)date
{
    
}

#pragma mark - UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *reuseID = @"tableHeader";
    StudentAttendanceHeader *header = (StudentAttendanceHeader *)[tableView dequeueReusableCellWithIdentifier:reuseID];
    if(header)
        header = [[StudentAttendanceHeader alloc] initWithReuseIdentifier:reuseID];
    return header;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
