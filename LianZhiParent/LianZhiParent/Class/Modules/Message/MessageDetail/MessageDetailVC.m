//
//  MessageDetailVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/24.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "MessageDetailVC.h"
#import "MessageDetailItemCell.h"
#import "MessageDetailModel.h"
#import "MessageNotificationDetailVC.h"

@implementation MessageDetailVC

+ (void)handlePushAction:(NSString *)fromID fromType:(NSString *)fromType
{
    MessageDetailVC *detailVC = [[MessageDetailVC alloc] init];
    MessageFromInfo *fromInfo = [[MessageFromInfo alloc] init];
    [fromInfo setUid:fromID];
    [fromInfo setType:[fromType integerValue]];
    [detailVC setFromInfo:fromInfo];
    [ApplicationDelegate.rootNavigation pushViewController:detailVC animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"eeeef4"]];
    NSMutableString *text = [NSMutableString stringWithString:self.fromInfo.name];
    if(self.fromInfo.label.length > 0)
        [text appendString:[NSString stringWithFormat:@"(%@)",self.fromInfo.label]];
    self.title = text;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    [self bindTableCell:@"MessageDetailItemCell" tableModel:@"MessageDetailModel"];
    
    [self setSupportPullDown:YES];
    [self setSupportPullUp:YES];
    [self requestData:REQUEST_REFRESH];
}

- (EmptyHintView *)emptyView{
    if(_emptyView == nil){
        _emptyView = [[EmptyHintView alloc] initWithImage:@"NoNotificationDetail" title:@"暂时没有通知记录"];
    }
    return _emptyView;
}

- (void)clear{
    MessageFromInfo *fromInfo = [(MessageDetailModel *)self.tableViewModel fromInfo];
    @weakify(self)
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"确定清空吗?" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"清空"];
    [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
    [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setDestructiveHandler:^(LGAlertView *alertView) {
        @strongify(self)
        //删除消息
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:fromInfo.uid forKey:@"from_id"];
        [params setValue:kStringFromValue(fromInfo.type) forKey:@"from_type"];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/delete_thread" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [self.tableViewModel.modelItemArray removeAllObjects];
            [self saveCache];
            [self.tableView reloadData];
        } fail:^(NSString *errMsg) {
            
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = [super tableView:tableView numberOfRowsInSection:section];
    [self showEmptyView:count == 0];
    return count;
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath{
    MessageDetailItem *detailItem = (MessageDetailItem *)modelItem;
    if(detailItem.type == ChatTypeLianZhiBroadcast || detailItem.type == ChatTypeDoorEntrance){
        
    }
    else{
        MessageNotificationDetailVC *notificationDetailVC = [[MessageNotificationDetailVC alloc] init];
        [notificationDetailVC setMessageDetailItem:detailItem];
        @weakify(self)
        [notificationDetailVC setDeleteSuccessCallback:^(MessageDetailItem *messageDetailItem) {
            @strongify(self)
            NSInteger index = [self.tableViewModel.modelItemArray indexOfObject:detailItem];
            if(index >= 0 && index < self.tableViewModel.modelItemArray.count)
            {
                [self.tableViewModel.modelItemArray removeObject:detailItem];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
        [self.navigationController pushViewController:notificationDetailVC animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) wself = self;
    MessageDetailItem *detailItem = [self.tableViewModel.modelItemArray objectAtIndex:indexPath.row];
    MessageDetailItemCell *itemCell = (MessageDetailItemCell *)cell;
    [itemCell setDeleteCallback:^{
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:@"确定删除这条信息吗?" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除"];
        [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
        [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setDestructiveHandler:^(LGAlertView *alertView) {
            
            [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/delete_notice" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"notice_id":(detailItem.msgID)} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                NSInteger index = [wself.tableViewModel.modelItemArray indexOfObject:detailItem];
                if(index >= 0 && index < wself.tableViewModel.modelItemArray.count)
                {
                    [wself.tableViewModel.modelItemArray removeObject:detailItem];
                    [wself.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                }
            } fail:^(NSString *errMsg) {
                [ProgressHUD showHintText:errMsg];
            }];
            
        }];
        [alertView showAnimated:YES completionHandler:nil];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
