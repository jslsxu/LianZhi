//
//  StudentAttendanceDetailVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "StudentAttendanceDetailVC.h"
#import "Calendar.h"
#import "StudentAttendanceHeaderView.h"
#import "StudentAttendanceDetail.h"
@interface StudentAttendanceDetailVC ()<CalendarDelegate>
@property (nonatomic, strong)Calendar* calendar;
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)UIView* contentView;
@property (nonatomic, strong)StudentAttendanceHeaderView* headerView;
@property (nonatomic, strong)StudentAttendanceDetail* attendanceDetail;
@end

@implementation StudentAttendanceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [self setupTitle];
    [self.view addSubview:[self calendar]];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.calendar.height, self.view.width, self.view.height - self.calendar.height)];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_scrollView setAlwaysBounceVertical:YES];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_scrollView];
    
    [_scrollView addSubview:[self headerView]];
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(10, self.headerView.bottom + 10, _scrollView.width - 10 * 2, 0)];
    [_scrollView addSubview:self.contentView];
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, self.contentView.bottom + 10)];
    
    [self requestStudentAttendance];
}

- (void)setupTitle{
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setNumberOfLines:0];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"525252"]];
    NSMutableAttributedString* titleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@考勤详情\n", self.studentInfo.name] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}];
    [titleString appendAttributedString:[[NSAttributedString alloc] initWithString:[self.classInfo name] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}]];
    [titleLabel setAttributedText:titleString];
    [titleLabel sizeToFit];
    [self.navigationItem setTitleView:titleLabel];
}

- (Calendar *)calendar{
    if(_calendar == nil){
        _calendar = [[Calendar alloc] initWithDate:[NSDate date]];
        [_calendar setDelegate:self];
    }
    return _calendar;
}

- (StudentAttendanceHeaderView *)headerView{
    if(nil == _headerView){
        _headerView = [[StudentAttendanceHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, 100)];
    }
    return _headerView;
}

- (void)setupHeaderView{
    [self.headerView setDate:self.calendar.currentSelectedDate];
    [self.headerView setInfo:self.attendanceDetail.info];
    [self.headerView setStudentInfo:self.attendanceDetail.studentInfo];
    [self.headerView setHidden:![self.attendanceDetail isAttendanceValidate]];
}

- (void)setupContentView{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView setHeight:0];
    if(self.headerView.hidden){
        [self.contentView setY:10];
    }
    else{
        [self.contentView setY:self.headerView.bottom];
    }
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView.layer setCornerRadius:10];
    [self.contentView.layer setMasksToBounds:YES];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setTextColor:kColor_33];
    [titleLabel setText:@"当日记录"];
    [titleLabel sizeToFit];
    [titleLabel setOrigin:CGPointMake(10, 10)];
    [self.contentView addSubview:titleLabel];
    
    UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [dateLabel setTextColor:kCommonTeacherTintColor];
    [dateLabel setFont:[UIFont systemFontOfSize:14]];
    [dateLabel setText:[self.calendar.currentSelectedDate stringWithFormat:@"yyyy年MM月dd日"]];
    [dateLabel sizeToFit];
    [dateLabel setOrigin:CGPointMake(self.contentView.width - 10 - dateLabel.width, 10)];
    [self.contentView addSubview:dateLabel];
    
    CGFloat spaceYStart = titleLabel.bottom + 10;
    
    if([self.attendanceDetail.recode count] > 0){
        for (NSInteger i = 0; i < [self.attendanceDetail.recode count]; i++) {
            AttendanceNoteItem* noteItem = self.attendanceDetail.recode[i];
            UIView* dot = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 6, 6)];
            [dot setBackgroundColor:kCommonTeacherTintColor];
            [dot.layer setCornerRadius:3];
            [dot.layer setMasksToBounds:YES];
            [self.contentView addSubview:dot];
            
            UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [timeLabel setTextColor:kCommonTeacherTintColor];
            [timeLabel setFont:[UIFont systemFontOfSize:14]];
            [timeLabel setText:noteItem.ctime];
            [timeLabel sizeToFit];
            [timeLabel setOrigin:CGPointMake(dot.right + 10, spaceYStart)];
            [self.contentView addSubview:timeLabel];
            
            [dot setOrigin:CGPointMake(10, timeLabel.centerY - dot.height / 2)];
            
            UILabel* contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabel.left, 0, self.contentView.width - 10 - timeLabel.left, 0)];
            [contentLabel setTextColor:kColor_66];
            [contentLabel setNumberOfLines:0];
            [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [contentLabel setFont:[UIFont systemFontOfSize:14]];
            [contentLabel setText:noteItem.recode];
            [contentLabel sizeToFit];
            [contentLabel setOrigin:CGPointMake(timeLabel.left, timeLabel.bottom + 5)];
            [self.contentView addSubview:contentLabel];
            
            spaceYStart = contentLabel.bottom + 10;
        }
    }
    else{
        UIView* dot = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 6, 6)];
        [dot setBackgroundColor:kCommonTeacherTintColor];
        [dot.layer setCornerRadius:3];
        [dot.layer setMasksToBounds:YES];
        [self.contentView addSubview:dot];
        
        UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [timeLabel setTextColor:kCommonTeacherTintColor];
        [timeLabel setFont:[UIFont systemFontOfSize:14]];
        [timeLabel setText:@"暂无记录"];
        [timeLabel sizeToFit];
        [timeLabel setOrigin:CGPointMake(dot.right + 10, spaceYStart)];
        [self.contentView addSubview:timeLabel];
        
        [dot setOrigin:CGPointMake(10, timeLabel.centerY - dot.height / 2)];
        
        spaceYStart = timeLabel.bottom + 10;
    }
    
    [self.contentView setHeight:spaceYStart];

    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width, self.contentView.bottom + 10)];
}

- (void)setAttendanceDetail:(StudentAttendanceDetail *)attendanceDetail{
    _attendanceDetail = attendanceDetail;
    [self.calendar setHighlightedDate:attendanceDetail.month_leave];
    [self setupHeaderView];
    [self setupContentView];
}

- (void)requestStudentAttendance{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) wself = self;
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    NSDate *date = self.calendar.currentSelectedDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [params setValue:[formatter stringFromDate:date] forKey:@"cdate"];
    [params setValue:self.studentInfo.uid forKey:@"child_id"];
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"leave/nstudent" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [hud hide:NO];
        StudentAttendanceDetail* attendanceDetail = [StudentAttendanceDetail modelWithJSON:responseObject.data];
        [attendanceDetail setStudentInfo:wself.studentInfo];
        [wself setAttendanceDetail:attendanceDetail];
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
    }];
}

- (void)calendarDateDidChange:(NSDate *)selectedDate{
    [self requestStudentAttendance];
}

- (void)calendarHeightWillChange:(CGFloat)height{
    [self.scrollView setFrame:CGRectMake(0, height, self.view.width, self.view.height - height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
