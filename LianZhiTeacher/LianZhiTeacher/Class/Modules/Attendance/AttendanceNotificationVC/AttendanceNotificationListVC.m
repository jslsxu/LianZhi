//
//  AttendanceNotificationListVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "AttendanceNotificationListVC.h"
#import "AttendanceNotificationCell.h"
#import "AttendanceNotificationListModel.h"
#import "AttendanceVC.h"
#import "StudentsAttendanceVC.h"
@interface AttendanceNotificationListVC ()

@end

@implementation AttendanceNotificationListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学生请假通知";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"eeeef4"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    
    UIButton* manageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [manageButton addTarget:self action:@selector(gotoManage) forControlEvents:UIControlEventTouchUpInside];
    [manageButton setFrame:CGRectMake(10, self.view.height - 10 - 40, self.view.width - 10 * 2, 40)];
    [manageButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [manageButton setBackgroundImage:[UIImage imageWithColor:kCommonTeacherTintColor size:manageButton.size cornerRadius:10] forState:UIControlStateNormal];
    [manageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [manageButton setTitle:@"进入学生考勤管理" forState:UIControlStateNormal];
    [manageButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:manageButton];
    [self.tableView setFrame:CGRectMake(0, 0, self.view.width, manageButton.top - 10)];
    [self bindTableCell:@"AttendanceNotificationCell" tableModel:@"AttendanceNotificationListModel"];
    [self setSupportPullUp:YES];
    [self setSupportPullDown:YES];
    [self requestData:REQUEST_REFRESH];
}

- (void)gotoManage{
    AttendanceVC* attendanceVC = [[AttendanceVC alloc] init];
    [self.navigationController pushViewController:attendanceVC animated:YES];
}

- (void)clear{

    @weakify(self)
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"确定清空吗?" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"清空"];
    [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
    [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setDestructiveHandler:^(LGAlertView *alertView) {
        @strongify(self)
        //删除消息
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.fromInfo.uid forKey:@"from_id"];
        [params setValue:kStringFromValue(self.fromInfo.type) forKey:@"from_type"];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/delete_thread" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [self.tableViewModel.modelItemArray removeAllObjects];
            [self saveCache];
            [self.tableView reloadData];
        } fail:^(NSString *errMsg) {
            
        }];
    }];
    [alertView showAnimated:YES completionHandler:nil];

}

- (void)deleteItem:(AttendanceNotificationItem *)detailItem
{
    
    @weakify(self)
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"确定删除这条信息吗?" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除"];
    [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
    [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setDestructiveHandler:^(LGAlertView *alertView) {
        @strongify(self)
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:detailItem.msgID forKey:@"notice_id"];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/delete_notice" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            NSInteger index = [self.tableViewModel.modelItemArray indexOfObject:detailItem];
            if(index >= 0 && index < self.tableViewModel.modelItemArray.count)
            {
                [self.tableViewModel.modelItemArray removeObject:detailItem];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        } fail:^(NSString *errMsg) {
            [ProgressHUD showHintText:errMsg];
        }];
        
    }];
    [alertView showAnimated:YES completionHandler:nil];
    
}



- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"notice/leave"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.fromInfo.uid forKey:@"from_id"];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)self.fromInfo.type] forKey:@"from_type"];
    if(requestType == REQUEST_GETMORE)
    {
        AttendanceNotificationListModel *detailModel = (AttendanceNotificationListModel *)self.tableViewModel;
        [params setValue:@"old" forKey:@"mode"];
        [params setValue:detailModel.minID forKey:@"min_id"];
    }
    [task setParams:params];
    [task setObserver:self];
    return task;
    
}

- (BOOL)supportCache
{
    return YES;
}

- (NSString *)cacheFileName
{
    return [NSString stringWithFormat:@"%@_%@_%@",[self class],self.fromInfo.uid,kStringFromValue(self.fromInfo.type)];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    AttendanceNotificationCell *itemCell = (AttendanceNotificationCell *)cell;
    AttendanceNotificationItem *detailItem = (AttendanceNotificationItem *)itemCell.modelItem;
    @weakify(self)
    [itemCell setDeleteCallback:^{
        @strongify(self)
        [self deleteItem:detailItem];
    }];
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath{
    AttendanceNotificationItem *detailItem = (AttendanceNotificationItem *)modelItem;
    StudentsAttendanceVC* attendanceVC = [[StudentsAttendanceVC alloc] init];
    [attendanceVC setClassInfo:detailItem.words.class_info];
    [self.navigationController pushViewController:attendanceVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
