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
@interface MonthStatisticsVC ()
@property (nonatomic, strong)StatisticsMonthHeaderView* headerView;
@property (nonatomic, strong)MBProgressHUD* hud;
@end

@implementation MonthStatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [self setupTitle];
    [self.view addSubview:[self headerView]];
    [self.tableView setFrame:CGRectMake(0, self.headerView.height, self.view.width, self.view.height - self.headerView.height)];
    [self bindTableCell:@"MonthStatisticsCell" tableModel:@"MonthStatisticsListModel"];
    [self requestData:REQUEST_REFRESH];
}

- (void)setupTitle{
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setNumberOfLines:0];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"525252"]];
    NSMutableAttributedString* titleString = [[NSMutableAttributedString alloc] initWithString:@"月考勤统计\n" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}];
    [titleString appendAttributedString:[[NSAttributedString alloc] initWithString:self.classInfo.name attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}]];
    [titleLabel setAttributedText:titleString];
    [titleLabel sizeToFit];
    [self.navigationItem setTitleView:titleLabel];
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
            [wself sortWithType:sortType];
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

- (void)sortWithType:(NSInteger)sortType{
    NSMutableArray* listArray = [self.tableViewModel modelItemArray];
    [listArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        MonthStatisticsItem* item1 = (MonthStatisticsItem *)obj1;
        MonthStatisticsItem* item2 = (MonthStatisticsItem *)obj2;
        if(sortType == 0){
            return [item1.child_info.first_letter compare:item2.child_info.first_letter];
        }
        else if(sortType == 1){
            if(item1.attendance > item2.attendance){
                return NSOrderedAscending;
            }
            else if(item1.attendance == item2.attendance){
                return NSOrderedSame;
            }
            else{
                return NSOrderedDescending;
            }
        }
        else{
            if(item1.absence > item2.absence){
                return NSOrderedAscending;
            }
            else if(item1.absence == item2.absence){
                return NSOrderedSame;
            }
            else{
                return NSOrderedDescending;
            }
        }
    }];
    [self.tableView reloadData];
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
