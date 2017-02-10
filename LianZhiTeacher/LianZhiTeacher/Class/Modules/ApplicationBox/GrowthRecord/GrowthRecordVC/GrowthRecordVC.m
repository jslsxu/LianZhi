//
//  GrowthRecordVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/4.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "GrowthRecordVC.h"
#import "NotificationDetailActionView.h"
#import "Calendar.h"
#import "GrowthRecordCell.h"
#import "PublishGrowthRecordVC.h"
@interface GrowthRecordVC ()<CalendarDelegate>
@property (nonatomic, strong)UIButton* moreButton;
@property (nonatomic, strong)Calendar* calendar;
@end

@implementation GrowthRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"家园手册"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [self setRightbarButtonHighlighted:NO];
    [self.view addSubview:[self calendar]];
    
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 60, self.view.width, 60)];
    [bottomView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton* editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton addTarget:self action:@selector(publishRecord) forControlEvents:UIControlEventTouchUpInside];
    [editButton setFrame:CGRectMake(10, 10, bottomView.width - 10 * 2, bottomView.height - 10 * 2)];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [editButton setTitle:@"批量评价" forState:UIControlStateNormal];
    [editButton setBackgroundImage:[UIImage imageWithColor:kCommonTeacherTintColor size:editButton.size cornerRadius:10] forState:UIControlStateNormal];
    [bottomView addSubview:editButton];
    
    [self.view addSubview:bottomView];
    
    [self.tableView setFrame:CGRectMake(0, self.calendar.bottom + 10, self.view.width, bottomView.top - (self.calendar.bottom + 10))];
    [self bindTableCell:@"GrowthRecordCell" tableModel:@"GrowthClassListModel"];

//    [self requestData:REQUEST_REFRESH];
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
    NSMutableArray* actionArray = [NSMutableArray array];
    NotificationActionItem *settingItem = [NotificationActionItem actionItemWithTitle:@"清除当日未读提醒" action:^{
    } destroyItem:NO];
    [actionArray addObject:settingItem];
    NotificationActionItem *clearAllItem = [NotificationActionItem actionItemWithTitle:@"清除所有未读提醒" action:^{
    } destroyItem:NO];
    [actionArray addObject:clearAllItem];
    [NotificationDetailActionView showWithActions:actionArray completion:^{
        [wself setRightbarButtonHighlighted:NO];
    }];
}

- (void)publishRecord{
    PublishGrowthRecordVC* publishRecordVC = [[PublishGrowthRecordVC alloc] init];
    [publishRecordVC setDate:[self.calendar currentSelectedDate]];
    [CurrentROOTNavigationVC pushViewController:publishRecordVC animated:YES];
}

- (void)requestGrowthRecord{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
}

#pragma mark - CalendarDelegate
- (void)calendarHeightWillChange:(CGFloat)height{
    
}

- (void)calendarDateDidChange:(NSDate *)selectedDate{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
