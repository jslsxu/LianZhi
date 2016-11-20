//
//  HomeworkListVC.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkListVC.h"
#import "HomeworkListModel.h"
#import "HomeworkDetailVC.h"
#import "HomeworkNotificationListModel.h"
#import "HomeworkNotificationCell.h"
@interface HomeworkListVC ()
@end

@implementation HomeworkListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"作业通知";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"eeeef4"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    [self bindTableCell:@"HomeworkNotificationCell" tableModel:@"HomeworkNotificationListModel"];
    [self setSupportPullUp:YES];
    [self setSupportPullDown:YES];
    [self requestData:REQUEST_REFRESH];
}

- (void)clear{
    __weak typeof(self) wself = self;
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"确定清空吗?" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"清空"];
    [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
    [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setDestructiveHandler:^(LGAlertView *alertView) {
        //删除消息
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:wself.fromInfo.uid forKey:@"from_id"];
        [params setValue:kStringFromValue(wself.fromInfo.type) forKey:@"from_type"];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/delete_thread" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [wself.tableViewModel.modelItemArray removeAllObjects];
            [wself saveCache];
            [wself.tableView reloadData];
        } fail:^(NSString *errMsg) {
            
        }];
    }];
    [alertView showAnimated:YES completionHandler:nil];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType{
    HttpRequestTask *task = [HttpRequestTask alloc];
    [task setRequestUrl:@"notice/exercises"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.fromInfo.uid forKey:@"from_id"];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)self.fromInfo.type] forKey:@"from_type"];
    if(requestType == REQUEST_GETMORE){
        HomeworkNotificationListModel *model = (HomeworkNotificationListModel *)self.tableViewModel;
        [params setValue:@"old" forKey:@"mode"];
        [params setValue:model.minID forKey:@"min_id"];
    }
    [task setParams:params];
    return task;
}

- (void)deleteNotificationItem:(HomeworkNotificationItem *)item{
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/delete_notice" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"notice_id":(item.msgId)} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        NSInteger index = [wself.tableViewModel.modelItemArray indexOfObject:item];
        if(index >= 0 && index < wself.tableViewModel.modelItemArray.count)
        {
            [wself.tableViewModel.modelItemArray removeObject:item];
            [wself.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    } fail:^(NSString *errMsg) {
        [ProgressHUD showHintText:errMsg];
    }];

}

- (BOOL)supportCache
{
    return YES;
}

- (NSString *)cacheFileName
{
    return [NSString stringWithFormat:@"%@_%@_%@",[self class],self.fromInfo.uid,kStringFromValue(self.fromInfo.type)];
}

#pragma mark - 

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) wself = self;
    HomeworkNotificationItem *notificationItem = [self.tableViewModel.modelItemArray objectAtIndex:indexPath.row];
    HomeworkNotificationCell* notificationCell = (HomeworkNotificationCell *)cell;
    [notificationCell setDeleteCallback:^{
        [wself deleteNotificationItem:notificationItem];
    }];
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath{
    __weak typeof(self) wself = self;
    HomeworkNotificationItem *homeworkItem = (HomeworkNotificationItem *)modelItem;
    HomeworkDetailVC *homeworkDetailVC = [[HomeworkDetailVC alloc] init];
    [homeworkDetailVC setEid:homeworkItem.eid];
    [homeworkDetailVC setHomeworkStatusCallback:^(HomeworkStatus status) {
        [homeworkItem setIs_new:NO];
        [homeworkItem setStatus:status];
        [wself.tableView reloadData];
    }];
    [homeworkDetailVC setDeleteCallback:^(NSString *eid) {
        [wself.tableViewModel.modelItemArray removeObject:homeworkItem];
        [wself.tableView reloadData];
    }];
    [self.navigationController pushViewController:homeworkDetailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
