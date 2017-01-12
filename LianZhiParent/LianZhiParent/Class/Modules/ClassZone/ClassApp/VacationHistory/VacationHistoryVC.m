//
//  VacationHistoryVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/5/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "VacationHistoryVC.h"
#import "RequestVacationVC.h"
@interface VacationHistoryVC ()<MonthIndicatorDelegate>
@property (nonatomic, copy)NSString *month;
@end

@implementation VacationHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考勤记录";
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy-MM"];
    self.month = [fomatter stringFromDate:[NSDate date]];
    [self requestData];
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"04aa73"]];
    
    AvatarView *avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
    [avatarView sd_setImageWithURL:[NSURL URLWithString:[UserCenter sharedInstance].curChild.avatar]];
    [headerView addSubview:avatarView];
    
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarView.right + 20, 20, headerView.width - 20 - (avatarView.right + 20), headerView.height - 20 * 2)];
    [_descLabel setTextColor:[UIColor whiteColor]];
    [_descLabel setFont:[UIFont systemFontOfSize:14]];
    [_descLabel setNumberOfLines:0];
    [_descLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [headerView addSubview:_descLabel];
    
    [self.view addSubview:headerView];
    
    _monthIndicator = [[MonthIndicatorView alloc] initWithFrame:CGRectMake(0, headerView.bottom, self.view.width, 36)];
    [_monthIndicator setDelegate:self];
    [self.view addSubview:_monthIndicator];
    
    _calendarView = [[CalendarView alloc] initWithFrame:CGRectMake(0, _monthIndicator.bottom, self.view.width, 280)];
    [self.view addSubview:_calendarView];
    
    UIButton*   vacationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vacationButton setFrame:CGRectMake(15, self.view.height - 15 - 36 - 64, self.view.width - 15 * 2, 36)];
    [vacationButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"5ed115"] size:vacationButton.size cornerRadius:18] forState:UIControlStateNormal];
    [vacationButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [vacationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [vacationButton setTitle:@"在线请假" forState:UIControlStateNormal];
    [vacationButton addTarget:self action:@selector(onVacationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:vacationButton];
    
    [self requestData];
}

- (void)requestData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    [params setValue:self.classInfo.school.schoolID forKey:@"school_id"];
    [params setValue:[NSString stringWithFormat:@"%@-01",self.month] forKey:@"from_date"];
    [params setValue:[NSString stringWithFormat:@"%@-31",self.month] forKey:@"to_date"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"leave/nget" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        TNDataWrapper *childWrapper = [responseObject getDataWrapperForKey:@"child"];
        [_descLabel setText:[childWrapper getStringForKey:@"record"]];
        TNDataWrapper *leaveListWrapper = [responseObject getDataWrapperForKey:@"leave_info"];
        NSMutableArray *vacationArray = [NSMutableArray array];
        for (NSInteger i = 0; i < leaveListWrapper.count; i++)
        {
            TNDataWrapper *itemWrapper = [leaveListWrapper getDataWrapperForIndex:i];
            VacationHistoryItem *vacationItem = [[VacationHistoryItem alloc] init];
            [vacationItem parseData:itemWrapper];
            [vacationArray addObject:vacationItem];
        }
        [_calendarView setVacationArray:vacationArray];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)onVacationButtonClicked
{
    RequestVacationVC *requestVacationVC = [[RequestVacationVC alloc] init];
//    [requestVacationVC setClassInfo:self.classInfo];
    [CurrentROOTNavigationVC pushViewController:requestVacationVC animated:YES];
}

#pragma mark - MonthIndicatorView
- (void)monthIndicatorDidChangeMonth:(NSDate *)date
{
    [_calendarView setCurMonth:date];
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy-MM"];
    self.month = [fomatter stringFromDate:date];
    [self requestData];
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
