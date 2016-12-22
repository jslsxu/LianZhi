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
@interface StudentsAttendanceVC ()<UITableViewDelegate, UITableViewDataSource, CalendarDelegate>
@property (nonatomic, strong)UIButton* moreButton;
@property (nonatomic, strong)Calendar* calendar;
@property (nonatomic, strong)UITableView* tableView;
@end

@implementation StudentsAttendanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学生考勤";
    [self setRightbarButtonHighlighted:NO];
    [self.view addSubview:[self calendar]];
}

- (Calendar *)calendar{
    if(_calendar == nil){
        _calendar = [[Calendar alloc] initWithDate:[NSDate date]];
        [_calendar setDelegate:self];
    }
    return _calendar;
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
        StudentAttendanceDetailVC *detailVC = [[StudentAttendanceDetailVC alloc] init];
        [wself.navigationController pushViewController:detailVC animated:YES];
    } destroyItem:NO];
    NotificationActionItem *anylizeItem = [NotificationActionItem actionItemWithTitle:@"编辑考勤" action:^{
    } destroyItem:NO];
    [NotificationDetailActionView showWithActions:@[settingItem, anylizeItem] completion:^{
        [wself setRightbarButtonHighlighted:NO];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
