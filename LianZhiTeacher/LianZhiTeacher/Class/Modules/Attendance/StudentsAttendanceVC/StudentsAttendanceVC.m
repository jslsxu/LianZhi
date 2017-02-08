//
//  ClassAttendanceVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "StudentsAttendanceVC.h"
#import "Calendar.h"
#import "NotificationDetailActionView.h"
#import "StudentAttendanceDetailVC.h"
#import "EditAttendanceVC.h"
#import "MonthStatisticsVC.h"
#import "StudentsAttendanceHeaderView.h"
#import "StudentsAttendanceListModel.h"
#import "StudentsAttendanceEmptyView.h"
#import <WYPopoverController.h>
#import "AttendanceClassSelectVC.h"
@interface StudentsAttendanceVC ()< CalendarDelegate>
@property (nonatomic, strong)StudentsAttendanceHeaderView* headerView;
@property (nonatomic, strong)UIButton* moreButton;
@property (nonatomic, strong)Calendar* calendar;
@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, strong)StudentsAttendanceEmptyView* attendanceEmptyView;
@property (nonatomic, strong)WYPopoverController *popController;
@end

@implementation StudentsAttendanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self setupTitle];
    [self setRightbarButtonHighlighted:NO];
    [self.view addSubview:[self calendar]];
    [self.view addSubview:[self headerView]];
    
    [self.view addSubview:[self attendanceEmptyView]];
    [self.attendanceEmptyView setFrame:CGRectMake(0, self.headerView.bottom, self.view.width, self.view.height - self.headerView.bottom)];
    
    [self.tableView setFrame:CGRectMake(0, self.headerView.bottom, self.view.width, self.view.height - self.headerView.bottom)];
    [self.tableView setSectionIndexColor:kColor_66];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self bindTableCell:@"StudentsAttendanceCell" tableModel:@"StudentsAttendanceListModel"];
    [self requestData:REQUEST_REFRESH];
}

- (Calendar *)calendar{
    if(_calendar == nil){
        _calendar = [[Calendar alloc] initWithDate:[NSDate date]];
        [_calendar setDelegate:self];
    }
    return _calendar;
}

- (StudentsAttendanceEmptyView *)attendanceEmptyView{
    if(nil == _attendanceEmptyView){
        __weak typeof(self) wself = self;
        _attendanceEmptyView = [[StudentsAttendanceEmptyView alloc] initWithFrame:self.tableView.frame];
        [_attendanceEmptyView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [_attendanceEmptyView setHidden:YES];
        [_attendanceEmptyView setEditAttendanceCallback:^{
            [wself startAttendance];
        }];
    }
    return _attendanceEmptyView;
}

- (void)setupTitle{
    
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTitleClicked)];
    [titleView addGestureRecognizer:tapGesture];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"525252"]];
    [titleLabel setFont:[UIFont systemFontOfSize:17]];
    [titleLabel setText:@"学生考勤"];
    [titleLabel sizeToFit];
    [titleView addSubview:titleLabel];
    
    UILabel* classNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [classNameLabel setFont:[UIFont systemFontOfSize:12]];
    [classNameLabel setTextColor:[UIColor colorWithHexString:@"525252"]];
    [classNameLabel setText:self.classInfo.name];
    [classNameLabel sizeToFit];
    [titleView addSubview:classNameLabel];
    
    UIImageView* arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ClassUpArrow"]];
    [arrow setTransform:CGAffineTransformMakeRotation(M_PI)];
    [titleView addSubview:arrow];
    [arrow setHidden:[self.classInfoArray count] == 1];
    
    CGFloat width = classNameLabel.width + 2 + arrow.width;
    CGFloat height = MAX(classNameLabel.height, arrow.height) + 2 + titleLabel.height;
    [titleView setSize:CGSizeMake(MAX(width, titleLabel.width), height)];
    [titleLabel setOrigin:CGPointMake((titleView.width - titleLabel.width) / 2, 0)];
    [classNameLabel setOrigin:CGPointMake((titleView.width - width) / 2, titleLabel.height + 2)];
    [arrow setOrigin:CGPointMake(classNameLabel.right + 2, classNameLabel.centerY - arrow.height / 2)];
    [self.navigationItem setTitleView:titleView];
}


- (void)setRightbarButtonHighlighted:(BOOL)highlighted{
    if(_moreButton == nil){
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setSize:CGSizeMake(30, 40)];
        [_moreButton addTarget:self action:@selector(onMoreClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    [_moreButton setImage:[UIImage imageNamed:highlighted ? @"noti_detail_more_highlighted" : @"noti_detail_more"] forState:UIControlStateNormal];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:_moreButton];
    self.navigationItem.rightBarButtonItem = moreItem;
}

- (void)onTitleClicked{
    if([self.classInfoArray count] > 1){
        __weak typeof(self) wself = self;
        AttendanceClassSelectVC* classSelectVC = [[AttendanceClassSelectVC alloc] init];
        [classSelectVC setClassArray:self.classInfoArray];
        [classSelectVC setClassSelectCallback:^(ClassInfo *classInfo) {
            [wself.popController dismissPopoverAnimated:YES];
            [wself onClassChanged:classInfo];
        }];
        self.popController = [[WYPopoverController alloc] initWithContentViewController:classSelectVC];
        WYPopoverTheme* theme = [WYPopoverTheme theme];
        [theme setOverlayColor:[UIColor clearColor]];
        [theme setTintColor:[UIColor colorWithWhite:0 alpha:0.6]];
        [self.popController setTheme:theme];
        [self.popController setPopoverContentSize:CGSizeMake(120, 40 * MIN(6, self.classInfoArray.count))];
        UIView* titleView = self.navigationItem.titleView;
        [self.popController presentPopoverFromRect:titleView.bounds inView:titleView permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
    }
}

- (void)onClassChanged:(ClassInfo *)classInfo{
    if(![self.classInfo.classID isEqualToString:classInfo.classID]){
        [self setClassInfo:classInfo];
        [self setupTitle];
        [self requestData:REQUEST_REFRESH];
    }
}

- (NSString *)curDate{
    NSDate *date = self.calendar.currentSelectedDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

- (void)startAttendance{
    __weak typeof(self) wself = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[self curDate] forKey:@"cdate"];
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"leave/nstartleave" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [hud hide:NO];
        TNDataWrapper* lockWrapper = [responseObject getDataWrapperForKey:@"lock"];
        BOOL locked = [lockWrapper getBoolForKey:@"flg"];
        NSString* message = [lockWrapper getStringForKey:@"msg"];
        if(locked){
            [ProgressHUD showHintText:message];
        }
        else{
            TNDataWrapper *itemsWrapper = [responseObject getDataWrapperForKey:@"items"];
            NSArray* items = [StudentAttendanceItem nh_modelArrayWithJson:itemsWrapper.data];
            for (StudentAttendanceItem* attendanceItem in items) {
                attendanceItem.newStatus = attendanceItem.status;
                attendanceItem.edit_mark = attendanceItem.mark_time;
            }
            [wself gotoEditAttendanceWithData:items];
        }
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
        [ProgressHUD showHintText:errMsg];
    }];
}

- (void)onMoreClicked{
    [self setRightbarButtonHighlighted:YES];
    __weak typeof(self) wself = self;
    NSMutableArray* actionArray = [NSMutableArray array];
    NotificationActionItem *settingItem = [NotificationActionItem actionItemWithTitle:@"月考勤" action:^{
        MonthStatisticsVC* monthVC = [[MonthStatisticsVC alloc] init];
        [monthVC setClassArray:wself.classInfoArray];
        [monthVC setClassInfo:wself.classInfo];
        [monthVC setDate:wself.calendar.currentSelectedDate];
        [CurrentROOTNavigationVC pushViewController:monthVC animated:YES];
    } destroyItem:NO];
    [actionArray addObject:settingItem];
    if([self.calendar.currentSelectedDate isToday]){
        NotificationActionItem *anylizeItem = [NotificationActionItem actionItemWithTitle:@"编辑考勤" action:^{
            [wself startAttendance];
        } destroyItem:NO];
        [actionArray addObject:anylizeItem];
    }
    [NotificationDetailActionView showWithActions:actionArray completion:^{
        [wself setRightbarButtonHighlighted:NO];
    }];
}

- (void)gotoEditAttendanceWithData:(NSArray *)items{
    __weak typeof(self) wself = self;
    EditAttendanceVC* editVC = [[EditAttendanceVC alloc] init];
    [editVC setDate:self.calendar.currentSelectedDate];
    [editVC setClassInfo:self.classInfo];
    [editVC setStudentAttendanceArray:items];
    [editVC setEditFinished:^{
        [wself requestData:REQUEST_REFRESH];
    }];
    [CurrentROOTNavigationVC pushViewController:editVC animated:YES];
}

- (StudentsAttendanceHeaderView *)headerView{
    if(nil == _headerView){
        __weak typeof(self) wself = self;
        _headerView = [[StudentsAttendanceHeaderView alloc] initWithFrame:CGRectMake(0, self.calendar.height + 10, self.view.width, 70)];
        [_headerView setSortCallback:^(NSInteger sortType) {
            StudentsAttendanceListModel* model = (StudentsAttendanceListModel *)wself.tableViewModel;
            [model setSortIndex:sortType];
            [wself.tableView reloadData];
        }];
    }
    return _headerView;
}

- (void)updateSubviews{
    [self.headerView setTop:self.calendar.height + 10];
    [self.tableView setFrame:CGRectMake(0, self.headerView.bottom, self.view.width, self.view.height - self.headerView.bottom)];
    [self.attendanceEmptyView setFrame:self.tableView.frame];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    task.requestUrl = @"leave/nclass";
    
    NSDate *date = self.calendar.currentSelectedDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[formatter stringFromDate:date] forKey:@"cdate"];
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    [task setParams:params];

    return task;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.width - 10 * 2, headerView.height)];
    [headerLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [headerLabel setTextColor:kColor_66];
    StudentsAttendanceListModel* model = (StudentsAttendanceListModel *)self.tableViewModel;
    NSArray* titleArray = [model titleArray];
    [headerLabel setText:titleArray[section]];
    [headerView addSubview:headerLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    StudentsAttendanceListModel* model = (StudentsAttendanceListModel *)self.tableViewModel;
    if(model.sortIndex == 0){
        return 20;
    }
    else{
        return 0;
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    StudentsAttendanceListModel* model = (StudentsAttendanceListModel *)self.tableViewModel;
    return [model titleArray];
}

- (void)TNBaseTableViewControllerRequestStart{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)TNBaseTableViewControllerRequestSuccess{
    [self.hud hide:NO];
    
    BOOL empty = [self.tableViewModel.modelItemArray count] == 0;
    StudentsAttendanceListModel *model = (StudentsAttendanceListModel *)self.tableViewModel;
    [self showEmptyView:empty];
    [self.headerView setTitleHidden:empty];
    [self updateSubviews];
    [self.headerView.titleLabel setText:[NSString stringWithFormat:@"当日出勤率:%@%%",model.info.rate]];
    [self.headerView.nameButton setTitle:[NSString stringWithFormat:@"姓名(%zd)", [self.tableViewModel.modelItemArray count]] forState:UIControlStateNormal];
    [self.headerView.attendanceButton setTitle:[NSString stringWithFormat:@"出勤(%zd)", model.info.attendance] forState:UIControlStateNormal];
    [self.headerView.offButton setTitle:[NSString stringWithFormat:@"缺勤(%zd)", [model.info absence]] forState:UIControlStateNormal];
    if([self checkDate] <= 0){
        [self.attendanceEmptyView setHidden:[model.modelItemArray count] != 0];
        [self.attendanceEmptyView setDate:self.calendar.currentSelectedDate];
    }
}

- (void)TNBaseTableViewControllerRequestFailedWithError:(NSString *)errMsg{
    [self.hud hide:NO];
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath{
    StudentAttendanceItem* item = (StudentAttendanceItem *)modelItem;
    StudentAttendanceDetailVC* detailVC = [[StudentAttendanceDetailVC alloc] init];
    [detailVC setClassInfo:self.classInfo];
    [detailVC setStudentInfo:item.child_info];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - CalendaDelegate
- (void)calendarDateDidChange:(NSDate *)selectedDate{
    StudentsAttendanceListModel* model = (StudentsAttendanceListModel *)self.tableViewModel;
    if([self checkDate] <= 0){
        [model setSortIndex:0];
        [self requestData:REQUEST_REFRESH];
    }
    else{
        [self.attendanceEmptyView setHidden:NO];
        [self.attendanceEmptyView setDate:self.calendar.currentSelectedDate];
        [model.modelItemArray removeAllObjects];
        [self.tableView reloadData];
    }
}

- (void)calendarHeightWillChange:(CGFloat)height{
    [self updateSubviews];
}

- (NSInteger)checkDate{
    NSString* todayString = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    NSString* dateString = [self.calendar.currentSelectedDate stringWithFormat:@"yyyy-MM-dd"];
    NSComparisonResult result = [dateString compare:todayString];
    if(result == NSOrderedAscending){
        return -1;
    }
    else if(result == NSOrderedSame){
        return 0;
    }
    else{
        return 1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
