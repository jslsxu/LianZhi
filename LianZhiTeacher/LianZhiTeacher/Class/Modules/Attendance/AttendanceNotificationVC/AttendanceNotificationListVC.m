//
//  AttendanceNotificationListVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "AttendanceNotificationListVC.h"
#import "AttendanceNotificationCell.h"
@interface AttendanceNotificationListVC ()

@end

@implementation AttendanceNotificationListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学生请假通知";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"eeeef4"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    [self bindTableCell:@"AttendanceNotificationCell" tableModel:@"MessageDetailModel"];
    [self setSupportPullUp:YES];
    [self setSupportPullDown:YES];
    [self requestData:REQUEST_REFRESH];
}

- (void)clear{
    
}

- (void)deleteItem:(MessageDetailItem *)detailItem
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
    [task setRequestUrl:@"notice/thread"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.fromInfo.uid forKey:@"from_id"];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)self.fromInfo.type] forKey:@"from_type"];
    if(requestType == REQUEST_GETMORE)
    {
        MessageDetailModel *detailModel = (MessageDetailModel *)self.tableViewModel;
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
    MessageDetailItem *detailItem = (MessageDetailItem *)itemCell.modelItem;
    @weakify(self)
    [itemCell setDeleteCallback:^{
        @strongify(self)
        [self deleteItem:detailItem];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
