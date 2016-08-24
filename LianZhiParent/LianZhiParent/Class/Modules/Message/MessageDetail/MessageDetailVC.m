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
    NSMutableString *text = [NSMutableString stringWithString:self.fromInfo.name];
    if(self.fromInfo.label.length > 0)
        [text appendString:[NSString stringWithFormat:@"(%@)",self.fromInfo.label]];
    self.title = text;
    
    [self bindTableCell:@"MessageDetailItemCell" tableModel:@"MessageDetailModel"];
    [self setSupportPullDown:YES];
    [self setSupportPullUp:YES];
    [self requestData:REQUEST_REFRESH];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageItemDeleteNotification:) name:kMessageDeleteNotitication object:nil];
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

- (void)onMessageItemDeleteNotification:(NSNotification *)notification
{
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:@"确定删除这条信息吗?" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除"];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setDestructiveHandler:^(LGAlertView *alertView) {
        NSDictionary *userInfo = notification.userInfo;
        MessageDetailItem *item = (MessageDetailItem *)[userInfo objectForKey:kMessageDeleteModelItemKey];
        
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/delete_notice" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"notice_id":(item.msgID)} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            NSInteger index = [self.tableViewModel.modelItemArray indexOfObject:item];
            if(index >= 0 && index < self.tableViewModel.modelItemArray.count)
            {
                [self.tableViewModel.modelItemArray removeObject:item];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        } fail:^(NSString *errMsg) {
            
        }];

    }];
    [alertView showAnimated:YES completionHandler:nil];
}
- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath{
    MessageDetailItem *detailItem = (MessageDetailItem *)modelItem;
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
