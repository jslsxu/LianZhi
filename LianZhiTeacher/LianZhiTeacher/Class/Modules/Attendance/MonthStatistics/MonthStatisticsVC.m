//
//  MonthStatisticsVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "MonthStatisticsVC.h"
#import "StatisticsMonthHeaderView.h"
#import "MonthStatisticsListModel.h"
#import "StudentAttendanceDetailVC.h"
#import "AttendanceClassSelectVC.h"
#import "MonthStatisticsCell.h"
#import "WYPopoverController.h"
@interface MonthStatisticsVC ()
@property (nonatomic, strong)StatisticsMonthHeaderView* headerView;
@property (nonatomic, strong)MBProgressHUD* hud;
@property (nonatomic, strong)WYPopoverController *popController;
@end

@implementation MonthStatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [self setupTitle];
    [self.view addSubview:[self headerView]];
    [self.tableView setFrame:CGRectMake(0, self.headerView.height, self.view.width, self.view.height - self.headerView.height)];
    [self.tableView setSectionIndexColor:kColor_66];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self bindTableCell:@"MonthStatisticsCell" tableModel:@"MonthStatisticsListModel"];
    [self requestData:REQUEST_REFRESH];
}

- (EmptyHintView *)emptyView{
    if(!_emptyView){
        _emptyView = [[EmptyHintView alloc] initWithImage:@"EmptyMonthStatistics" title:@"暂无月考勤统计"];
    }
    return _emptyView;
}

- (void)setupTitle{
    
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTitleClicked)];
    [titleView addGestureRecognizer:tapGesture];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"525252"]];
    [titleLabel setFont:[UIFont systemFontOfSize:17]];
    [titleLabel setText:@"月考勤统计"];
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
    
    [arrow setHidden:[self.classArray count] <= 1];
    
    CGFloat width = classNameLabel.width + 2 + arrow.width;
    CGFloat height = MAX(classNameLabel.height, arrow.height) + 2 + titleLabel.height;
    [titleView setSize:CGSizeMake(MAX(width, titleLabel.width), height)];
    [titleLabel setOrigin:CGPointMake((titleView.width - titleLabel.width) / 2, 0)];
    [classNameLabel setOrigin:CGPointMake((titleView.width - width) / 2, titleLabel.height + 2)];
    [arrow setOrigin:CGPointMake(classNameLabel.right + 2, classNameLabel.centerY - arrow.height / 2)];
    [self.navigationItem setTitleView:titleView];
}

- (void)onClassChanged:(ClassInfo *)classInfo{
    if(![self.classInfo.classID isEqualToString:classInfo.classID]){
        [self setClassInfo:classInfo];
        [self setupTitle];
        [self requestData:REQUEST_REFRESH];
    }
}

- (void)onTitleClicked{
    if([self.classArray count] > 1){
        __weak typeof(self) wself = self;
        AttendanceClassSelectVC* classSelectVC = [[AttendanceClassSelectVC alloc] init];
        [classSelectVC setClassArray:self.classArray];
        [classSelectVC setClassSelectCallback:^(ClassInfo *classInfo) {
            [wself.popController dismissPopoverAnimated:YES];
            [wself onClassChanged:classInfo];
        }];
        self.popController = [[WYPopoverController alloc] initWithContentViewController:classSelectVC];
        WYPopoverTheme* theme = [WYPopoverTheme theme];
        [theme setOverlayColor:[UIColor clearColor]];
        [theme setTintColor:[UIColor colorWithWhite:0 alpha:0.6]];
        [self.popController setTheme:theme];
        [self.popController setPopoverContentSize:CGSizeMake(120, 40 * MIN(6, self.classArray.count))];
        UIView* titleView = self.navigationItem.titleView;
        [self.popController presentPopoverFromRect:titleView.bounds inView:titleView permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
   
    }
}

- (StatisticsMonthHeaderView *)headerView{
    if(nil == _headerView){
        __weak typeof(self) wself = self;
        _headerView = [[StatisticsMonthHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
        [_headerView setDateChanged:^{
            [wself refreshOnDateChanged];
        }];
        [_headerView setDate:[NSDate date]];
        [_headerView setSortChanged:^(NSInteger sortType) {
            MonthStatisticsListModel *model = (MonthStatisticsListModel *)wself.tableViewModel;
            [model setSortIndex:sortType];
            [wself.tableView reloadData];
        }];
    }
    return _headerView;
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType{
    self.date = [self.headerView date];
    HttpRequestTask* task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"leave/nclassmonth"];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    [params setValue:[dateFormatter stringFromDate:self.date] forKey:@"cdate"];
    [task setParams:params];
    return task;
}

- (void)refreshOnDateChanged{
    [self requestData:REQUEST_REFRESH];
}

- (void)TNBaseTableViewControllerRequestStart{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
}

- (void)TNBaseTableViewControllerRequestFailedWithError:(NSString *)errMsg{
    [self.hud hide:NO];
}

- (void)TNBaseTableViewControllerRequestSuccess{
    [self.hud hide:NO];
    MonthStatisticsListModel* model = (MonthStatisticsListModel *)self.tableViewModel;
    [self.headerView setClass_attendance:model.class_attendance];
    [self showEmptyView:[self.tableViewModel.modelItemArray count] == 0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    MonthStatisticsListModel* model = (MonthStatisticsListModel *)self.tableViewModel;
    if(model.sortIndex == 0){
        return 20;
    }
    else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.width - 10 * 2, headerView.height)];
    [headerLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [headerLabel setTextColor:kColor_66];
    MonthStatisticsListModel* model = (MonthStatisticsListModel *)self.tableViewModel;
    NSArray* titleArray = [model titleArray];
    [headerLabel setText:titleArray[section]];
    [headerView addSubview:headerLabel];
    return headerView;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    MonthStatisticsListModel* model = (MonthStatisticsListModel *)self.tableViewModel;
    return [model titleArray];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonthStatisticsListModel* model = (MonthStatisticsListModel *)self.tableViewModel;
    MonthStatisticsCell* cell = (MonthStatisticsCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if(model.sortIndex == 0){
        [cell setRow:0];
        [cell setShowSepLine:YES];
    }
    else{
        [cell setRow:indexPath.row];
        [cell setShowSepLine:indexPath.row + 1 == [self tableView:tableView numberOfRowsInSection:0]];
    }
    return cell;
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath{
    MonthStatisticsItem *item = (MonthStatisticsItem *)modelItem;
    StudentAttendanceDetailVC* detailVC = [[StudentAttendanceDetailVC alloc] init];
    [detailVC setClassInfo:self.classInfo];
    [detailVC setStudentInfo:item.child_info];
    [CurrentROOTNavigationVC pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
