//
//  AttendanceDetailVC.m
//  LianZhiParent
//
//  Created by jslsxu on 16/12/25.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "AttendanceDetailVC.h"
#import "Calendar.h"
#import "NotificationDetailActionView.h"
#import "StudentAttendanceHeaderView.h"
#import "RequestVacationVC.h"
#import "AttendanceDetailResponse.h"
@interface AttendanceDetailVC ()<CalendarDelegate>
@property (nonatomic, strong)UIButton* moreButton;
@property (nonatomic, strong)Calendar* calendar;
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)StudentAttendanceHeaderView* headerView;
@property (nonatomic, strong)UIView* bottomView;
@property (nonatomic, strong)UIView* contentView;
@property (nonatomic, strong)AttendanceDetailResponse* detailResponse;
@end

@implementation AttendanceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [self setupTitle];
    [self setRightbarButtonHighlighted:NO];
    [self.view addSubview:[self calendar]];
    [self.view addSubview:[self bottomView]];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.calendar.height, self.view.width, self.bottomView.top - self.calendar.height)];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_scrollView setAlwaysBounceVertical:YES];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_scrollView];
    
    [_scrollView addSubview:[self headerView]];
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(10, self.headerView.bottom, _scrollView.width - 10 * 2, 0)];
    [_scrollView addSubview:self.contentView];
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, self.contentView.bottom + 10)];
    
    [self requestAttendance];
}

- (Calendar *)calendar{
    if(_calendar == nil){
        _calendar = [[Calendar alloc] initWithDate:[NSDate date]];
        [_calendar setDelegate:self];
    }
    return _calendar;
}

- (void)setupTitle{
    UserInfo* userInfo = [UserCenter sharedInstance].curChild;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setNumberOfLines:0];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"525252"]];
    NSMutableAttributedString* titleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@考勤详情\n", userInfo.name] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}];
    [titleString appendAttributedString:[[NSAttributedString alloc] initWithString:self.classInfo.name attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}]];
    [titleLabel setAttributedText:titleString];
    [titleLabel sizeToFit];
    [self.navigationItem setTitleView:titleLabel];
}

- (void)setRightbarButtonHighlighted:(BOOL)highlighted{
    if(_moreButton == nil){
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setSize:CGSizeMake(30, 40)];
        [_moreButton addTarget:self action:@selector(onMoreClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    [_moreButton setImage:[UIImage imageNamed:highlighted ? @"AttendanceActionHighlighted" : @"AttendanceActionNormal"] forState:UIControlStateNormal];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:_moreButton];
    self.navigationItem.rightBarButtonItem = moreItem;
}

- (void)onMoreClicked{
    [self setRightbarButtonHighlighted:YES];
    __weak typeof(self) wself = self;
    NotificationActionItem *cancelItem = [NotificationActionItem actionItemWithTitle:@"取消当日假条" action:^{
        [wself cancelLeave];
    } destroyItem:NO];
    [NotificationDetailActionView showWithActions:@[cancelItem] completion:^{
        [wself setRightbarButtonHighlighted:NO];
    }];
}

- (void)cancelLeave{
    NSDate *date = self.calendar.currentSelectedDate;
    if(![date isToday] && [date compare:[NSDate date]] == NSOrderedAscending){
        [ProgressHUD showHintText:@"选中的日期应晚于当前日期"];
    }
    else{
        __weak typeof(self) wself = self;
        LGAlertView* alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"您确定取消%@的请假吗?", [date stringWithFormat:@"yyyy-MM-dd"]] style:LGAlertViewStyleAlert buttonTitles:@[@"取消", @"确定"] cancelButtonTitle:nil destructiveButtonTitle:nil];
        [alertView setButtonsTitleColor:kCommonParentTintColor];
        [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
            if(index == 1){
                [wself cancelLeaveOnToday];
            }
        }];
        [alertView showAnimated:YES completionHandler:nil];
    }
}

- (void)cancelLeaveOnToday{
    __weak typeof(self) wself = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    [params setValue:self.classInfo.school.schoolID forKey:@"school_id"];
    NSDate *date = self.calendar.currentSelectedDate;
    [params setValue:[date stringWithFormat:@"yyyy-MM-dd"] forKey:@"cdate"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"leave/ncancel" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [hud hide:NO];
        [ProgressHUD showHintText:@"取消请假成功"];
        [wself requestAttendance];
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
        [ProgressHUD showHintText:errMsg];
    }];
}

- (void)requestLeave{
    __weak typeof(self) wself = self;
    RequestVacationVC* requestVC = [[RequestVacationVC alloc] init];
    [requestVC setClassInfo:self.classInfo];
    [requestVC setCompletion:^{
        [wself requestAttendance];
    }];
    [self.navigationController pushViewController:requestVC animated:YES];
}

- (UIView *)bottomView{
    if(nil == _bottomView){
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 60, self.view.width, 60)];
        [_bottomView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        [_bottomView setBackgroundColor:[UIColor whiteColor]];
        
        UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bottomView.width, kLineHeight)];
        [topLine setBackgroundColor:kSepLineColor];
        [_bottomView addSubview:topLine];
        
        UIButton* requestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [requestButton setFrame:CGRectInset(_bottomView.bounds, 10, 10)];
        [requestButton setBackgroundImage:[UIImage imageWithColor:kCommonParentTintColor size:requestButton.size cornerRadius:5] forState:UIControlStateNormal];
        [requestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [requestButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [requestButton setImage:[UIImage imageNamed:@"RequestLeave"] forState:UIControlStateNormal];
        [requestButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [requestButton setTitle:@"在线请假" forState:UIControlStateNormal];
        [requestButton addTarget:self action:@selector(requestLeave) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:requestButton];
    }
    return _bottomView;
}

- (StudentAttendanceHeaderView* )headerView{
    if(_headerView == nil){
        _headerView = [[StudentAttendanceHeaderView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 0)];
        [_headerView setDate:[[self calendar] currentSelectedDate]];
    }
    return _headerView;
}

- (void)setupContentView{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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
    [dateLabel setTextColor:kCommonParentTintColor];
    [dateLabel setFont:[UIFont systemFontOfSize:14]];
    [dateLabel setText:[self.calendar.currentSelectedDate stringWithFormat:@"yyyy年MM月dd日"]];
    [dateLabel sizeToFit];
    [dateLabel setOrigin:CGPointMake(self.contentView.width - 10 - dateLabel.width, 10)];
    [self.contentView addSubview:dateLabel];
    
    CGFloat spaceYStart = titleLabel.bottom + 10;
    if([self.detailResponse.recode count] > 0){
        for (NSInteger i = 0; i < [self.detailResponse.recode count]; i++) {
            AttendanceNoteItem* noteItem = self.detailResponse.recode[i];
            UIView* dot = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 6, 6)];
            [dot setBackgroundColor:kCommonParentTintColor];
            [dot.layer setCornerRadius:3];
            [dot.layer setMasksToBounds:YES];
            [self.contentView addSubview:dot];
            
            UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [timeLabel setTextColor:kCommonParentTintColor];
            [timeLabel setFont:[UIFont systemFontOfSize:14]];
            NSMutableAttributedString* timeString = [[NSMutableAttributedString alloc] initWithString:noteItem.ctime attributes:@{NSForegroundColorAttributeName : kCommonParentTintColor}];
            if(noteItem.ctype == NoteTypeLeave){
                [timeString appendAttributedString:[[NSAttributedString alloc] initWithString:noteItem.unread ? @"  教师未读" : @"  教师已读" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]}]];
            }
            [timeLabel setAttributedText:timeString];
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
        [dot setBackgroundColor:kCommonParentTintColor];
        [dot.layer setCornerRadius:3];
        [dot.layer setMasksToBounds:YES];
        [self.contentView addSubview:dot];
        
        UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [timeLabel setTextColor:kCommonParentTintColor];
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

- (void)setDetailResponse:(AttendanceDetailResponse *)detailResponse{
    _detailResponse = detailResponse;
    if(_detailResponse == nil){
        [self.scrollView setHidden:YES];
    }
    else{
        [self.scrollView setHidden:NO];
    }
    [self.headerView setInfo:_detailResponse.info];
    [self setupContentView];
}

- (void)requestAttendance{
    __weak typeof(self) wself = self;
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:[self view] animated:NO];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    [params setValue:self.classInfo.school.schoolID forKey:@"school_id"];
    NSDate *date = self.calendar.currentSelectedDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [params setValue:[formatter stringFromDate:date] forKey:@"cdate"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"leave/nget" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [hud hide:NO];
        AttendanceDetailResponse* response = [AttendanceDetailResponse nh_modelWithJson:responseObject.data];
        [wself setDetailResponse:response];
        [wself.calendar setHighlightedDate:response.month_leave];

        [wself.calendar setUnreadDays:response.teacher_submit];
        [self showEmptyView:NO];
        [self.scrollView setHidden:NO];
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
        [self showEmptyView:YES];
        [self.scrollView setHidden:YES];
    }];
}


- (EmptyHintView *)emptyView{
    if(nil == _emptyView){
        _emptyView = [[EmptyHintView alloc] initWithImage:@"AttendanceEmpty" title:@"暂时没有学生考勤"];
    }
    return _emptyView;
}

#pragma mark - CalendarDelegate
- (void)calendarDateDidChange:(NSDate *)selectedDate{
    [self.headerView setDate:selectedDate];
    [self setDetailResponse:nil];
    [self requestAttendance];
}

- (void)calendarHeightWillChange:(CGFloat)height{
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setFrame:CGRectMake(0, height, self.view.width, self.bottomView.y - height)];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
