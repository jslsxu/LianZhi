//
//  MonthStatisticsVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "MonthStatisticsVC.h"
#import "StatisticsMonthHeaderView.h"
@interface MonthStatisticsVC ()
@property (nonatomic, strong)StatisticsMonthHeaderView* headerView;
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
        _headerView = [[StatisticsMonthHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    }
    return _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
