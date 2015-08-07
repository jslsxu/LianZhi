//
//  MessageDetailVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/24.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "MessageDetailVC.h"
#import "MessageDetailItemCell.h"
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
    
    self.title = @"通知提醒";
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    [self setupHeaderView:headerView];
    [self.view addSubview:headerView];
    [self.tableView setFrame:CGRectMake(0, headerView.bottom, self.view.width, self.view.height - headerView.bottom)];
    
    [self bindTableCell:@"MessageDetailItemCell" tableModel:@"MessageDetailModel"];
    [self setSupportPullDown:YES];
    [self setSupportPullUp:YES];
    [self requestData:REQUEST_REFRESH];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageItemDeleteNotification:) name:kMessageDeleteNotitication object:nil];
}

- (void)setupHeaderView:(UIView *)viewParent
{
    [viewParent setBackgroundColor:[UIColor colorWithRed:211 / 255.0 green:211 / 255.0 blue:211 / 255.0 alpha:1.f]];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, viewParent.width - 10 * 2, viewParent.height)];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setFont:[UIFont systemFontOfSize:16]];
    [nameLabel setTextColor:kCommonParentTintColor];
    NSMutableString *text = [NSMutableString stringWithString:self.fromInfo.name];
    if(self.fromInfo.label.length > 0)
        [text appendString:[NSString stringWithFormat:@"(%@)",self.fromInfo.label]];
    [nameLabel setText:text];
    [viewParent addSubview:nameLabel];
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
    TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
    TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"删除" action:^{
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
    TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"确定删除这条信息吗?" buttonItems:@[cancelItem, confirmItem]];
    [alertView show];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
