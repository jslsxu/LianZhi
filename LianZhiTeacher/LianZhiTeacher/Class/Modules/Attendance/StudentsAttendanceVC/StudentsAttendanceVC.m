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
@interface StudentsAttendanceVC ()< CalendarDelegate>
@property (nonatomic, strong)StudentsAttendanceHeaderView* headerView;
@property (nonatomic, strong)UIButton* moreButton;
@property (nonatomic, strong)Calendar* calendar;
@end

@implementation StudentsAttendanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [self setupTitle];
    [self setRightbarButtonHighlighted:NO];
    [self.view addSubview:[self calendar]];
    [self.view addSubview:[self headerView]];
    
    [self.tableView setFrame:CGRectMake(0, self.headerView.bottom, self.view.width, self.view.height - self.headerView.bottom)];
    [self.tableView setSectionIndexColor:kColor_66];
    [self bindTableCell:@"StudentsAttendanceCell" tableModel:@"StudentsAttendanceListModel"];
    [self setSupportPullUp:YES];
    [self setSupportPullDown:YES];
    [self requestData:REQUEST_REFRESH];
}

- (Calendar *)calendar{
    if(_calendar == nil){
        _calendar = [[Calendar alloc] initWithDate:[NSDate date]];
        [_calendar setDelegate:self];
    }
    return _calendar;
}

- (void)setupTitle{
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setNumberOfLines:0];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"525252"]];
    NSMutableAttributedString* titleString = [[NSMutableAttributedString alloc] initWithString:@"学生考勤\n" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}];
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
    [_moreButton setImage:[UIImage imageNamed:highlighted ? @"noti_detail_more_highlighted" : @"noti_detail_more"] forState:UIControlStateNormal];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:_moreButton];
    self.navigationItem.rightBarButtonItem = moreItem;
}

- (void)onMoreClicked{
    [self setRightbarButtonHighlighted:YES];
    __weak typeof(self) wself = self;
    NotificationActionItem *settingItem = [NotificationActionItem actionItemWithTitle:@"月考勤" action:^{
        MonthStatisticsVC* monthVC = [[MonthStatisticsVC alloc] init];
        [monthVC setClassInfo:wself.classInfo];
        [CurrentROOTNavigationVC pushViewController:monthVC animated:YES];
    } destroyItem:NO];
    NotificationActionItem *anylizeItem = [NotificationActionItem actionItemWithTitle:@"编辑考勤" action:^{
        EditAttendanceVC* editVC = [[EditAttendanceVC alloc] init];
        [editVC setClassInfo:wself.classInfo];
        [CurrentROOTNavigationVC pushViewController:editVC animated:YES];
    } destroyItem:NO];
    [NotificationDetailActionView showWithActions:@[settingItem, anylizeItem] completion:^{
        [wself setRightbarButtonHighlighted:NO];
    }];
}

- (StudentsAttendanceHeaderView *)headerView{
    if(nil == _headerView){
        _headerView = [[StudentsAttendanceHeaderView alloc] initWithFrame:CGRectMake(0, self.calendar.height + 10, self.view.width, 70)];
    }
    return _headerView;
}

- (NSArray *)indexArray{
    NSMutableArray* titleArray = [NSMutableArray array];
    for (StudentAttendanceItem* item in self.tableViewModel.modelItemArray) {
        [titleArray addObject:[item.studentInfo.name substringToIndex:1]];
    }
    return titleArray;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@""]];
    
    UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.width - 10 * 2, headerView.height)];
    [headerLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [headerLabel setTextColor:kColor_66];
    StudentAttendanceItem* item = self.tableViewModel.modelItemArray[section];
    [headerLabel setText:[item.studentInfo.name substringToIndex:1]];
    [headerView addSubview:headerLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [self indexArray];
}

- (void)TNBaseTableViewControllerRequestSuccess{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
