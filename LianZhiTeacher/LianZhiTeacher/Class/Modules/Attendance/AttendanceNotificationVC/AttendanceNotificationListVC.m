//
//  AttendanceNotificationListVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "AttendanceNotificationListVC.h"

@interface AttendanceNotificationListVC ()

@end

@implementation AttendanceNotificationListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学生请假通知";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    [self bindTableCell:@"AttendanceNotificationCell" tableModel:@"MessageDetailModel"];
    [self setSupportPullUp:YES];
    [self setSupportPullDown:YES];
    [self requestData:REQUEST_REFRESH];
}

- (void)clear{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
